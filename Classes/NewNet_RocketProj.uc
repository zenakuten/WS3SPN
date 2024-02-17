/*
UTComp - UT2004 Mutator
Copyright (C) 2004-2005 Aaron Everitt & Joël Moffatt

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/
class NewNet_RocketProj extends TeamColorRocketProj;

#exec AUDIO IMPORT FILE=Sounds\AirRocket.wav        GROUP=Sounds

var PlayerController PC;
var vector DesiredDeltaFake;
var float CurrentDeltaFakeTime;
var bool bInterpFake;
var bool bOwned;

var NewNet_FakeProjectileManager FPM;

var int Index;
var Sound AirRocketSound;

replication
{
    reliable if(Role == Role_Authority && bNetInitial)
       Index;
    unreliable if(bDemoRecording)
       DoMove, DoSetLoc;
}

const INTERP_TIME = 0.50;

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();
    if(Level.NetMode != NM_Client)
        return;

    PC = Level.GetLocalPlayerController();
    if (CheckOwned())
       CheckForFakeProj();
}

simulated function bool CheckOwned()
{
	if(class'Misc_Player'.default.bEnableEnhancedNetCode==False)
		return false;
    bOwned = (PC!=None && PC.Pawn!=None && PC.Pawn == Instigator);
    return bOwned;
}

simulated function DoMove(Vector V)
{
    Move(V);
}

simulated function DoSetLoc(Vector V)
{
    SetLocation(V);
}

simulated function bool CheckForFakeProj()
{
     local float ping;
     local Projectile FP;

     ping = FMax(0.0, Class'NewNet_PRI'.default.PredictedPing - 0.5*Class'NewNet_TimeStamp'.default.AverDT);

    if(FPM==None)
	{
        FindFPM();
		if(FPM==None)
			return false;
	}
		
     FP = FPM.GetFP(Class'NewNet_Fake_RocketProj', index);
     if(FP != none)
     {
         bInterpFake=true;
         DesiredDeltaFake = Location - FP.Location;
         DoSetLoc(FP.Location);
         FPM.RemoveProjectile(FP);
         bOwned=False;
         return true;
     }
     return false;
}

simulated function FindFPM()
{
    foreach DynamicActors(Class'NewNet_FakeProjectileManager', FPM)
        break;
}

simulated function Tick(float deltatime)
{
    super.Tick(deltatime);
    if(Level.NetMode != NM_Client)
        return;
    if(bInterpFake)
        FakeInterp(deltatime);
    else if(bOwned)
        CheckForFakeProj();
}

simulated function FakeInterp(float dt)
{
    local vector V;
    local float OldDeltaFakeTime;

    V=DesiredDeltaFake*dt/INTERP_TIME;

    OldDeltaFakeTime = CurrentDeltaFakeTime;
    CurrentDeltaFakeTime+=dt;

    if(CurrentDeltaFakeTime < INTERP_TIME)
        DoMove(V);
    else // (We overshot)
    {
        DoMove((INTERP_TIME - OldDeltaFakeTime)/dt*V);
        bInterpFake=False;
        //Turn off checking for fakes
    }
}

// copy from projectile -> hurt radius, return true if anybody killed
simulated function bool HurtRadiusEx( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector rocketdir;
    local bool bKilledPlayerInAir;
    local EPhysics prePhysics;
    local bool bAboveGround;

	if ( bHurtEntry )
		return false;

	bHurtEntry = true;
    bKilledPlayerInAir = false;
    prePhysics=PHYS_None;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') )
		{
			rocketdir = Victims.Location - HitLocation;
            bAboveGround = Victims.FastTrace(Victims.Location + vect(0,0,-150));
            
			dist = FMax(1,VSize(rocketdir));
			rocketdir = rocketdir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			if ( Victims == LastTouched )
				LastTouched = None;
            prePhysics = Victims.Physics;
			Victims.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * rocketdir,
				(damageScale * Momentum * rocketdir),
				DamageType
			);
			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

            if(Pawn(Victims) != None && Pawn(Victims).Health <= 0 && prePhysics == PHYS_Falling && bAboveGround && Victims != Instigator)
                bKilledPlayerInAir = true;

		}
	}
	if ( (LastTouched != None) && (LastTouched != self) && (LastTouched.Role == ROLE_Authority) && !LastTouched.IsA('FluidSurfaceInfo') )
	{
		Victims = LastTouched;
		LastTouched = None;
		rocketdir = Victims.Location - HitLocation;
        bAboveGround = Victims.FastTrace(Victims.Location + vect(0,0,-150));
		dist = FMax(1,VSize(rocketdir));
		rocketdir = rocketdir/dist;
		damageScale = FMax(Victims.CollisionRadius/(Victims.CollisionRadius + Victims.CollisionHeight),1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius));
		if ( Instigator == None || Instigator.Controller == None )
			Victims.SetDelayedDamageInstigatorController(InstigatorController);
        prePhysics = Victims.Physics;
		Victims.TakeDamage
		(
			damageScale * DamageAmount,
			Instigator,
			Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * rocketdir,
			(damageScale * Momentum * rocketdir),
			DamageType
		);
		if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
			Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

        if(Pawn(Victims) != None && Pawn(Victims).Health <= 0 && prePhysics == PHYS_Falling && bAboveGround && Victims != Instigator)
            bKilledPlayerInAir = true;
	}

	bHurtEntry = false;

    return bKilledPlayerInAir;
}

function BlowUp(vector HitLocation)
{
    local bool bKilledPlayerInAir;
	bKilledPlayerInAir = HurtRadiusEx(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);

    if(bKilledPlayerInAir
        && Misc_BaseGRI(Level.GRI) != None 
        && Misc_BaseGRI(Level.GRI).bEnableExtraAwards)
    {    
        if(Misc_Player(Instigator.Controller) != None)
        {
            Misc_Player(Instigator.Controller).ClientDelayedSound(AirRocketSound,0.5);
        }
    }
}

defaultproperties
{
    AirRocketSound=Sound'3SPNvSoL.Sounds.AirRocket'
}
