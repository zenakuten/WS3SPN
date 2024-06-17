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
//-----------------------------------------------------------
//   UTComp Version Src by Aaron 'Lotus' Everitt
//
//   Main Mutator class
//   Last Edited(or, rather, last edited and i bothered to update this)
//    - Mar 15, 2005
//-----------------------------------------------------------

class TAM_Mutator extends MutUTComp;

#exec OBJ LOAD FILE=Textures\3SPNTex.utx PACKAGE=WS3SPN

/* weapons */
struct WeaponData
{
    var string WeaponName;
    var int Ammo[2];                        // 0 = primary ammo, 1 = alt ammo
    var float MaxAmmo[2];                   // 1 is only used for WeaponDefaults
};
var WeaponData  WeaponInfo[10];
var WeaponData  WeaponDefaults[10];
/* weapons */
	
var class<Weapon> BaseWeaponClasses[10];

	
function PreBeginPlay()
{		
    super.PreBeginPlay();
}

function ReplacePawnAndPC()
{
    // Since 3SPN game types set their own
    // playercontroller class and pawn class
    // we don't want UTComp clobbering them
    // Here we override UTComp ReplacePawnAndPC() function to do nothing
    // Misc_Player and Misc_Pawn already derive from UTComp types

    /*
    if(Level.Game.DefaultPlayerClassName~="xGame.xPawn")
        Level.Game.DefaultPlayerClassName=string(class'UTComp_xPawn');
    if(class'xPawn'.default.ControllerClass==class'XGame.XBot') //bots don't skin otherwise
        class'xPawn'.default.ControllerClass=class'UTComp_xBot';

    Level.Game.PlayerControllerClassName=string(class'BS_xPlayer');
    */
    if(class'xPawn'.default.ControllerClass==class'XGame.XBot') //bots don't skin otherwise
        class'xPawn'.default.ControllerClass=class'Misc_Bot';
}


/*function PostBeginPlay()
{
	Super.PostBeginPlay();

	if(EnableNewNet)
	{
		for(M=Level.Game.BaseMutator; M!=None; M=M.NextMutator)
		{
			if(string(M.Class)~="SpawnGrenades.MutSN")
				return;
		}
		class'GrenadeAmmo'.default.InitialAmount = NumGrenadesOnSpawn;
	}
}*/


	
simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

	if(Level.Pauser!=None)
	{	
		if(Level.NetMode==NM_DedicatedServer)
			Team_GameBase(Level.Game).UpdateTimeOut(DeltaTime);
		return;
	}

}

function InitWeapons(int AssaultAmmo,int AssaultGrenades,int BioAmmo,int ShockAmmo,int LinkAmmo,int MiniAmmo,int FlakAmmo,int RocketAmmo,int LightningAmmo, int ClassicSniperAmmo)
{
    local int i;
    local class<Weapon> WeaponClass;

    for(i = 0; i < ArrayCount(WeaponInfo); i++)
    {
        if(WeaponInfo[i].WeaponName ~= "")
            continue;

        if(WeaponInfo[i].WeaponName ~= "XWeapons.AssaultRifle")
        {
            WeaponInfo[i].Ammo[0] = AssaultAmmo;
            WeaponInfo[i].Ammo[1] = AssaultGrenades;
        }
        else if(WeaponInfo[i].WeaponName ~= "XWeapons.BioRifle")
				WeaponInfo[i].Ammo[0] = BioAmmo;
        else if(WeaponInfo[i].WeaponName ~= "XWeapons.ShockRifle")
            WeaponInfo[i].Ammo[0] = ShockAmmo;
        else if(WeaponInfo[i].WeaponName ~= "XWeapons.LinkGun")
            WeaponInfo[i].Ammo[0] = LinkAmmo;
        else if(WeaponInfo[i].WeaponName ~= "XWeapons.MiniGun")
            WeaponInfo[i].Ammo[0] = MiniAmmo;
        else if(WeaponInfo[i].WeaponName ~= "XWeapons.FlakCannon")
            WeaponInfo[i].Ammo[0] = FlakAmmo;
        else if(WeaponInfo[i].WeaponName ~= "XWeapons.RocketLauncher")
            WeaponInfo[i].Ammo[0] = RocketAmmo;
        else if(WeaponInfo[i].WeaponName ~= "XWeapons.SniperRifle")
            WeaponInfo[i].Ammo[0] = LightningAmmo;
       else if(WeaponInfo[i].WeaponName ~= "UTClassic.ClassicSniperRifle")
            WeaponInfo[i].Ammo[0] = ClassicSniperAmmo;			
			
        WeaponClass = class<Weapon>(DynamicLoadObject(WeaponInfo[i].WeaponName, class'Class'));

        if(WeaponClass == None)
        {
            log("Could not find weapon:"@WeaponInfo[i].WeaponName, '3SPN');
            continue;
        }

        // remember defaults
        WeaponDefaults[i].WeaponName = WeaponInfo[i].WeaponName;

        if(class<Translauncher>(WeaponClass) != None && WeaponInfo[i].Ammo[0] > 0)
        {
            WeaponDefaults[i].MaxAmmo[0] = Class'XWeapons.Translauncher'.default.AmmoChargeRate;
            WeaponDefaults[i].MaxAmmo[1] = Class'XWeapons.Translauncher'.default.AmmoChargeF;
            WeaponDefaults[i].Ammo[0] = Class'XWeapons.Translauncher'.default.AmmoChargeMax;
            class'XWeapons.Translauncher'.default.AmmoChargeRate = 0.000000; 
		    class'XWeapons.Translauncher'.default.AmmoChargeMax = WeaponInfo[i].Ammo[0];
		    class'XWeapons.Translauncher'.default.AmmoChargeF = WeaponInfo[i].Ammo[0];
        }
		else if(class<ShieldGun>(WeaponClass) != None)
        {
        }
        else
		{
			if(WeaponClass.default.FireModeClass[0].default.AmmoClass != None)
			{
				WeaponDefaults[i].Ammo[0] = WeaponClass.default.FireModeClass[0].default.AmmoClass.default.InitialAmount;
				WeaponDefaults[i].MaxAmmo[0] = WeaponClass.default.FireModeClass[0].default.AmmoClass.default.MaxAmmo;
				WeaponClass.default.FireModeClass[0].default.AmmoClass.default.InitialAmount = Min(999, WeaponInfo[i].Ammo[0]);
				WeaponClass.default.FireModeClass[0].default.AmmoClass.default.MaxAmmo = Min(999, WeaponInfo[i].Ammo[0] * WeaponInfo[i].MaxAmmo[0]);
			}

			if(WeaponClass.default.FireModeClass[1].default.AmmoClass != None && (WeaponClass.default.FireModeClass[0].default.AmmoClass != WeaponClass.default.FireModeClass[1].default.AmmoClass))
			{
				WeaponDefaults[i].Ammo[1] = WeaponClass.default.FireModeClass[1].default.AmmoClass.default.InitialAmount;
				WeaponDefaults[i].MaxAmmo[1] = WeaponClass.default.FireModeClass[1].default.AmmoClass.default.MaxAmmo;
				WeaponClass.default.FireModeClass[1].default.AmmoClass.default.InitialAmount = Min(999, WeaponInfo[i].Ammo[1]);
				WeaponClass.default.FireModeClass[1].default.AmmoClass.default.MaxAmmo = Min(999, WeaponInfo[i].Ammo[1] * WeaponInfo[i].MaxAmmo[0]);
			}
		}
		
		class'Freon_Pawn'.default.RequiredEquipment[i + 1] = WeaponInfo[i].WeaponName;
		class'Misc_Pawn'.default.RequiredEquipment[i + 1] = WeaponInfo[i].WeaponName;
    }
	
	class'ShieldFire'.Default.DamageType = Class'DamType_ShieldImpact';
	class'AssaultFire'.Default.DamageType = Class'DamType_AssaultBullet';
    class'Grenade'.Default.MyDamageType = class'DamType_AssaultGrenade';
    class'BioGlob'.default.MyDamageType = class'DamType_BioGlob';
	class'LinkFire'.Default.DamageType = Class'DamType_LinkShaft';
    class'LinkProjectile'.Default.MyDamageType = Class'DamType_LinkPlasma';
    class'MinigunFire'.Default.DamageType = Class'DamType_MinigunBullet';
    class'MinigunAltFire'.Default.DamageType = Class'DamType_MinigunAlt';
    class'FlakChunk'.default.MyDamageType = class'DamType_FlakChunk';
    class'FlakShell'.default.MyDamageType = class'DamType_FlakShell';
	class'RocketProj'.default.MyDamageType = class'DamType_Rocket';
	class'SeekingRocketProj'.default.MyDamageType = class'DamType_RocketHoming';
	//class'ShieldGun'.Default.DamageType = Class'DamType_ShieldImpact';

	//if(EnableNewNet)
	//{
        class'NewNet_AssaultFire'.Default.DamageType = Class'DamType_AssaultBullet';
        class'Grenade'.Default.MyDamageType = class'DamType_AssaultGrenade';
        class'ShieldFire'.Default.DamageType = Class'DamType_ShieldImpact';
        //class'WeaponFire_Shield'.Default.DamageType = Class'DamType_ShieldImpact';
		class'NewNet_BioGlob'.default.MyDamageType = class'DamType_BioGlob';
        class'NewNet_ShockBeamFire'.Default.DamageType = class'DamType_ShockBeam';
        class'NewNet_ShockProjectile'.Default.MyDamageType = class'DamType_ShockBall';
        class'NewNet_ShockProjectile'.Default.ComboDamageType = class'DamType_ShockBeam';
        class'NewNet_ShockProjectile'.Default.ComboRadiusDamageType = class'DamType_ShockCombo';
		class'NewNet_LinkFire'.Default.DamageType = Class'DamType_LinkShaft';
		class'NewNet_LinkProjectile'.Default.MyDamageType = Class'DamType_LinkPlasma';
		class'NewNet_MiniGunFire'.Default.DamageType = Class'DamType_MinigunBullet';
		class'NewNet_MiniGunAltFire'.Default.DamageType = Class'DamType_MinigunAlt';
		class'NewNet_FlakChunk'.default.MyDamageType = class'DamType_FlakChunk';
		class'NewNet_FlakShell'.default.MyDamageType = class'DamType_FlakShell';
		class'NewNet_RocketProj'.default.MyDamageType = class'DamType_Rocket';
		class'NewNet_SeekingRocketProj'.default.MyDamageType = class'DamType_RocketHoming';
		class'NewNet_SniperFire'.default.DamageType = class'DamType_SniperShot';
		class'NewNet_SniperFire'.default.DamageTypeHeadshot = class'DamType_HeadShot';
		class'NewNet_ClassicSniperFire'.default.DamageType = class'DamType_ClassicSniperShot';
		class'NewNet_ClassicSniperFire'.default.DamageTypeHeadShot = class'DamType_ClassicHeadShot';

		
		
        class'DamType_ShieldImpact'.default.WeaponClass = class'NewNet_ShieldGun';
		class'DamType_AssaultBullet'.default.WeaponClass = class'NewNet_AssaultRifle';
		class'DamType_AssaultGrenade'.default.WeaponClass = class'NewNet_AssaultRifle';
		//class'DamTypeAssaultGrenade'.default.WeaponClass = class'DamType_AssaultGrenade';
		class'DamType_BioGlob'.default.WeaponClass = class'NewNet_BioRifle';
		class'DamType_ShockBall'.default.WeaponClass = class'NewNet_ShockRifle';
		class'DamType_ShockBeam'.default.WeaponClass = class'NewNet_ShockRifle';
		class'DamType_ShockCombo'.default.WeaponClass = class'NewNet_ShockRifle';
		class'DamType_LinkShaft'.default.WeaponClass = class'NewNet_LinkGun';
		class'DamType_LinkPlasma'.default.WeaponClass = class'NewNet_LinkGun';
		class'DamType_MinigunAlt'.default.WeaponClass = class'NewNet_MiniGun';
		class'DamType_MinigunBullet'.default.WeaponClass = class'NewNet_MiniGun';
		class'DamType_FlakChunk'.default.WeaponClass = class'NewNet_FlakCannon';
		class'DamType_FlakShell'.default.WeaponClass = class'NewNet_FlakCannon';
		class'DamType_Rocket'.default.WeaponClass = class'NewNet_RocketLauncher';
		class'DamType_RocketHoming'.default.WeaponClass = class'NewNet_RocketLauncher';
		class'DamType_SniperShot'.default.WeaponClass = class'NewNet_SniperRifle';
		class'DamType_HeadShot'.default.WeaponClass = class'NewNet_SniperRifle';
		class'DamType_ClassicSniperShot'.default.WeaponClass = class'NewNet_ClassicSniperRifle';
		class'DamType_ClassicHeadshot'.default.WeaponClass = class'NewNet_ClassicSniperRifle';
	//}

    //snarf setup old weapons, these are used when newnet=false
    class'FlakFire'.default.ProjectileClass = class'TeamColorFlakChunk';
    class'FlakAltFire'.default.ProjectileClass = class'TeamColorFlakShell';
    class'ShockProjFire'.default.ProjectileClass = class'TeamColorShockProjectile';
}
	
function ResetWeaponsToDefaults(bool bModifyShieldGun,float ShieldGunSelfForceScale,float ShieldGunSelfDamageScale,int ShieldGunMinSelfDamage)
{
    local int i;
    local class<Weapon> WeaponClass;

    for(i = 0; i < ArrayCount(WeaponDefaults); i++)
    {
        if(WeaponDefaults[i].WeaponName ~= "")
            continue;

        WeaponClass = class<Weapon>(DynamicLoadObject(WeaponDefaults[i].WeaponName, class'Class'));

        if(WeaponClass == None)
            continue;

        // reset defaults
        if(class<Translauncher>(WeaponClass) != None && WeaponDefaults[i].Ammo[0] > 0)
        {
            Class'XWeapons.Translauncher'.default.AmmoChargeRate = WeaponDefaults[i].MaxAmmo[0]; 
		    Class'XWeapons.Translauncher'.default.AmmoChargeMax = WeaponDefaults[i].Ammo[0];
		    Class'XWeapons.Translauncher'.default.AmmoChargeF = WeaponDefaults[i].MaxAmmo[1];
            continue;
        }

		if(class<ShieldGun>(WeaponClass) != None)
            continue;
        
        if(WeaponClass.default.FireModeClass[0].default.AmmoClass != None)
        {
            WeaponClass.default.FireModeClass[0].default.AmmoClass.default.InitialAmount = WeaponDefaults[i].Ammo[0];
            WeaponClass.default.FireModeClass[0].default.AmmoClass.default.MaxAmmo = WeaponDefaults[i].MaxAmmo[0];
        }

        if(WeaponClass.default.FireModeClass[1].default.AmmoClass != None && (WeaponClass.default.FireModeClass[0].default.AmmoClass != WeaponClass.default.FireModeClass[1].default.AmmoClass))
        {
            WeaponClass.default.FireModeClass[1].default.AmmoClass.default.InitialAmount = WeaponDefaults[i].Ammo[1];
            WeaponClass.default.FireModeClass[1].default.AmmoClass.default.MaxAmmo = WeaponDefaults[i].MaxAmmo[1];
        }
    }

    if(bModifyShieldGun)
	{
		Class'XWeapons.ShieldFire'.default.SelfForceScale = 1.0;
		Class'XWeapons.ShieldFire'.default.SelfDamageScale = 0.3;
		Class'XWeapons.ShieldFire'.default.MinSelfDamage = 8;
        
	}

    class'FlakChunk'.default.MyDamageType = class'DamTypeFlakChunk';
    class'FlakShell'.default.MyDamageType = class'DamTypeFlakShell';
    class'BioGlob'.default.MyDamageType = class'DamTypeBioGlob';
	class'RocketProj'.default.MyDamageType = class'DamTypeRocket';
	class'SeekingRocketProj'.default.MyDamageType = class'DamTypeRocketHoming';


    //snarf restore old weapons
    class'FlakFire'.default.ProjectileClass = class'XWeapons.FlakChunk';
    class'FlakAltFire'.default.ProjectileClass = class'XWeapons.FlakShell';
    class'ShockProjFire'.default.ProjectileClass = class'XWeapons.ShockProjectile';
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    bSuperRelevant = 0;
	
    if(Other.IsA('Pickup') && !Other.IsA('Misc_PickupHealth') && !Other.IsA('Misc_PickupShield') && !(Other.IsA('Misc_PickupAdren')))
        return false;
		
    if(Other.IsA('xPickupBase') && !Other.IsA('Misc_PickupBase'))
        Other.bHidden = true;

    return super.CheckReplacement(Other, bSuperRelevant);
}

function string GetInventoryClassOverride(string InventoryClassName)
{
    local int x;

    if(InventoryClassName ~= "XWeapons.ShieldGun")
        return "WS3SPN.NewNet_ShieldGun";

    if(bEnhancedNetCodeEnabledAtStartOfMap)
    {
        for(x=0; x<ArrayCount(WeaponClassNames); x++)
           if(InventoryClassName ~= WeaponClassNames[x])
               return string(WeaponClasses[x]);
    }
    else
    {
         for(x=0; x<ArrayCount(WeaponClassNames); x++)
           if(InventoryClassName ~= WeaponClassNames[x])
               return string(WeaponClassesUTComp[x]);
    }

    if ( NextMutator != None )
		return NextMutator.GetInventoryClassOverride(InventoryClassName);

	return InventoryClassName;
}


function bool ReplaceWith(actor Other, string aClassName)
{
	local Actor A;
	local class<Actor> aClass;

	if ( aClassName == "" )
		return true;

	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if ( aClass != None )
		A = Spawn(aClass,Other.Owner,Other.tag,Other.Location, Other.Rotation);
	if ( Other.IsA('Pickup') )
	{
		if ( Pickup(Other).MyMarker != None )
		{
			Pickup(Other).MyMarker.markedItem = Pickup(A);
			if ( Pickup(A) != None )
			{
				Pickup(A).MyMarker = Pickup(Other).MyMarker;
				A.SetLocation(A.Location
					+ (A.CollisionHeight - Other.CollisionHeight) * vect(0,0,1));
			}
			Pickup(Other).MyMarker = None;
		}
		else if ( A.IsA('Pickup') && !A.IsA('WeaponPickup') )
			Pickup(A).Respawntime = 0.0;
	}
	if ( A != None )
	{
		A.event = Other.event;
		A.tag = Other.tag;
		return true;
	}
	return false;
}	

function GiveWeapons(Pawn P)
{
    local int i;
	local Misc_Pawn xP;

	xP = Misc_Pawn(P);
	if(xP==None)
		return;
		
    for(i = 0; i < ArrayCount(WeaponInfo); i++)
    {
        if(BaseWeaponClasses[i]==None || (WeaponInfo[i].Ammo[0]<=0 && WeaponInfo[i].Ammo[1]<=0))
            continue;
			
		xP.GiveWeaponClass(BaseWeaponClasses[i]);
    }
}

function GiveAmmo(Pawn P)
{
    local Weapon W;
    local int i;

	for(i = 0; i < ArrayCount(WeaponInfo); i++)
	{
		if(WeaponInfo[i].WeaponName == "" || (WeaponInfo[i].Ammo[0] <= 0 && WeaponInfo[i].Ammo[1] <= 0))
			continue;
			
		W = Weapon(P.FindInventoryType(BaseWeaponClasses[i]));
		if(W == None)
			continue;

		if(WeaponInfo[i].Ammo[0] > 0)
			W.AmmoCharge[0] = WeaponInfo[i].Ammo[0];

		if(WeaponInfo[i].Ammo[1] > 0)
			W.AmmoCharge[1] = WeaponInfo[i].Ammo[1];

        //fix shield bug
        if(ShieldGun(W) != None)
        {
            W.FillToInitialAmmo();
        }
	}
}

function ServerTraveling(string URL, bool bItems)
{
	if(Team_GameBase(Level.Game) != None)
        Team_GameBase(Level.Game).ResetDefaults();
    else if(ArenaMaster(Level.Game) != None)
        ArenaMaster(Level.Game).ResetDefaults();
		
    Super.ServerTraveling(URL, bItems);
}

function WarmupEnded()
{
	if(Team_GameBase(Level.Game) != None)
        Team_GameBase(Level.Game).bWarmupEnded = true;
}


defaultproperties
{
     WeaponInfo(0)=(WeaponName="XWeapons.ShockRifle",Ammo[0]=20,MaxAmmo[0]=1.500000)
     WeaponInfo(1)=(WeaponName="XWeapons.LinkGun",Ammo[0]=100,MaxAmmo[0]=1.500000)
     WeaponInfo(2)=(WeaponName="XWeapons.MiniGun",Ammo[0]=75,MaxAmmo[0]=1.500000)
     WeaponInfo(3)=(WeaponName="XWeapons.FlakCannon",Ammo[0]=12,MaxAmmo[0]=1.500000)
     WeaponInfo(4)=(WeaponName="XWeapons.RocketLauncher",Ammo[0]=12,MaxAmmo[0]=1.500000)
     WeaponInfo(5)=(WeaponName="XWeapons.SniperRifle",Ammo[0]=10,MaxAmmo[0]=1.500000)
     WeaponInfo(6)=(WeaponName="XWeapons.BioRifle",Ammo[0]=20,MaxAmmo[0]=1.500000)
     WeaponInfo(7)=(WeaponName="XWeapons.AssaultRifle",Ammo[0]=999,Ammo[1]=5,MaxAmmo[0]=1.500000)
     WeaponInfo(8)=(WeaponName="XWeapons.ShieldGun",Ammo[1]=100,MaxAmmo[0]=1.000000,MaxAmmo[1]=1.000000)
     WeaponInfo(9)=(WeaponName="UTClassic.ClassicSniperRifle",Ammo[0]=0,MaxAmmo[0]=1.500000)
     BaseWeaponClasses(0)=Class'XWeapons.ShockRifle'
     BaseWeaponClasses(1)=Class'XWeapons.LinkGun'
     BaseWeaponClasses(2)=Class'XWeapons.Minigun'
     BaseWeaponClasses(3)=Class'XWeapons.FlakCannon'
     BaseWeaponClasses(4)=Class'XWeapons.RocketLauncher'
     BaseWeaponClasses(5)=Class'XWeapons.SniperRifle'
     BaseWeaponClasses(6)=Class'XWeapons.BioRifle'
     BaseWeaponClasses(7)=Class'XWeapons.AssaultRifle'
     BaseWeaponClasses(8)=Class'XWeapons.ShieldGun'
     BaseWeaponClasses(9)=Class'UTClassic.ClassicSniperRifle'
     bAddToServerPackages=True
     FriendlyName="3SPN"
     Description="3SPN"
     bNetTemporary=True
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
     bAlwaysTick=True
     WarmupClass=class'TAM_Warmup'
}
