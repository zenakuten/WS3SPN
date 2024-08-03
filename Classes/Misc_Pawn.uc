class Misc_Pawn extends UTComp_xPawn;

var Misc_Player MyOwner;

var Material OrigBody;
var float SpawnedIconTimer;
var VJustSpawnedIcon SpawnedIcon;
var Vector ShockBall_FireLocation;
/* camping related */
var vector LocationHistory[10];
var int	   NextLocHistSlot;
var bool   bWarmedUp;
var int	   ReWarnTime;
/* camping related */

var bool   SpawnProtectionEnabled;
var int	   SpawnProtectionTimer;
var bool bSpawnKilled;
var xEmitter InvisEmitter;

var config bool bPlayOwnLandings;
var bool bInEndCeremony;

replication
{

    reliable if(bNetDirty && Role == ROLE_Authority)
        SpawnProtectionEnabled,SpawnedIcon;
}

function CreateInventory(string InventoryClassName)
{
    if(Misc_PRI(PlayerReplicationInfo) != None)
    {
        // player selects lightning, don't add classic sniper
        if(InventoryClassName ~= "UTClassic.ClassicSniperRifle")
            return;
    }
    // go up, and add weapon
    Super.CreateInventory(InventoryClassName);
}


function SendAdrenReminder ()
{
  local Controller C;
  local Misc_BaseGRI GRI;
  local bool bDisableNecroMessage;

  // not sure if we need to check both Level.GRI and each 
  // controller but just in case
  bDisableNecroMessage = false;
  GRI=Misc_BaseGRI(Level.GRI);
  if(GRI != None)
    bDisableNecroMessage = GRI.bDisableNecroMessage;

  if(bDisableNecroMessage)
    return;

  C = Level.ControllerList;
  JL0014:
  if ( C != None )
  {
    if ( (Misc_Player(C) != None) && (C.PlayerReplicationInfo != None) && (C.PlayerReplicationInfo.Team != None) && (C.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) )
    {
        bDisableNecroMessage = false;
        GRI=Misc_BaseGRI(Misc_Player(C).GameReplicationInfo);
        if(GRI != None)
            bDisableNecroMessage = GRI.bDisableNecroMessage;

      if ( (C.Pawn != None) && (C.Pawn != self) && (C.Adrenaline >= 100) && (C.Pawn.Health >= 0) )
      {
        if(!bDisableNecroMessage)
        {
            Misc_Player(C).ReceiveLocalizedMessage(Class'Message_Adrenaline',1);
        }
      }
    }
    C = C.nextController;
    goto JL0014;
  }
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if(Misc_Player(Controller)!=None)
		Misc_Player(Controller).NextRezTime = Level.TimeSeconds+1; // 1 second delay after dying
		if ( SpawnedIcon != None )
  {
    bSpawnKilled = True;
    SpawnedIcon.Destroy();
    SpawnedIcon = None;
  }
		SendAdrenReminder ();
	Super.Died(Killer, damageType, HitLocation);
}

simulated function Destroyed()
{
    if(InvisEmitter != None)
    {
        InvisEmitter.mRegen = false;
        InvisEmitter.Destroy();
        InvisEmitter = None;
    }
	
	if ( SpawnedIcon != None )
  {
    SpawnedIcon.Destroy();
    SpawnedIcon = None;
  }

    Super.Destroyed();
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	bSpawnKilled = False;
	if(Level.Game==None)
		return;
	
    ActivateSpawnProtection();
}

simulated function SetStandardSkin()
{
	if(OrigBody != None)
		Skins[0] = OrigBody;

	bUnlit = true;
}

simulated function ColorSkins()
{
    if(bInEndCeremony)
        return;
    super.ColorSkins();
}

simulated function Setup(xUtil.PlayerRecord rec, optional bool bLoadNow)
{
    local int TeamNum;

    if(Level.NetMode == NM_DedicatedServer)
    {
        super.Setup(rec, bLoadNow);
        return;
    }

    TeamNum = 0;
    if ( (PlayerReplicationInfo != None) && (PlayerReplicationInfo.Team != None) )
        TeamNum = PlayerReplicationInfo.Team.TeamIndex;

    class'SpeciesType'.static.SetTeamSkin(self, rec, TeamNum);

    OrigBody = Skins[0];
    super.Setup(rec, bLoadNow);
}

function PossessedBy(Controller C)
{
    Super.PossessedBy(C);

    if(bDeleteMe || Controller != C)
        return;

    if(Misc_PRI(PlayerReplicationInfo) != None)
        Misc_PRI(PlayerReplicationInfo).PawnReplicationInfo.SetMyPawn(self);
}

function UnPossessed()
{
    if(Misc_PRI(PlayerReplicationInfo) != None)
        Misc_PRI(PlayerReplicationInfo).PawnReplicationInfo.SetMyPawn(None);

    Super.UnPossessed();
}

function bool InCurrentCombo()
{
    if(TAM_GRI(Level.GRI) == None || TAM_GRI(Level.GRI).bDisableTeamCombos)
        return Super.InCurrentCombo();
    return false;
}

function DoCombo( class<Combo> ComboClass )
{
	local int i;

    if ( ComboClass != None )
    {
        if (CurrentCombo == None)
	        CurrentCombo = Spawn( ComboClass, self );

        if (CurrentCombo != None)
        {
			// Record stats for using the combo
			UnrealMPGameInfo(Level.Game).SpecialEvent(PlayerReplicationInfo,""$CurrentCombo.Class);
			if ( ComboClass.Name == 'ComboSpeed' )
				i = 0;
			else if ( ComboClass.Name == 'ComboBerserk' )
				i = 1;
			else if ( ComboClass.Name == 'ComboDefensive' )
				i = 2;
			else if ( ComboClass.Name == 'ComboInvis' )
				i = 3;
			else
				i = 4;
			TeamPlayerReplicationInfo(PlayerReplicationInfo).Combos[i] += 1;
        }
    }
}

// changed to save adren
function RemovePowerups()
{
    local float Adren;

    if(TAM_GRI(Level.GRI) == None || TAM_GRI(Level.GRI).bDisableTeamCombos)
    {
        Super.RemovePowerups();
        return;
    }

    if(Controller != None && Misc_DynCombo(CurrentCombo) != None)
    {
        Adren = Controller.Adrenaline;
        Super.RemovePowerups();
        Controller.Adrenaline = Adren; 

        return;
    }

    Super.RemovePowerups();
}

// 75% armor absorbtion rate
function int ShieldAbsorb(int dam)
{
    local float Shield;

    if(ShieldStrength == 0)
        return dam;

    SetOverlayMaterial(ShieldHitMat, ShieldHitMatTime, false);
    PlaySound(Sound'WeaponSounds.ArmorHit', SLOT_Pain, 2 * TransientSoundVolume,, 400);

    Shield = ShieldStrength - (dam * 0.75 + 0.5);
    dam *= 0.25;
    if(Shield < 0)
    {
        dam += -(Shield);
        Shield = 0;
    }

    ShieldStrength = Shield;
    return dam;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    local vector zeroVec;
    zeroVec = vect(0.0,0.0,0.0);

	if(IsSpawnProtectionEnabled() && instigatedBy != self)
        Super.TakeDamage(0, instigatedBy, hitlocation, zeroVec, damageType);
    else
        Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
}



simulated function RemoveFlamingEffects()
{
    local int i;

    if( Level.NetMode == NM_DedicatedServer )
        return;

    for(i = 0; i < Attached.length; i++)
    {
        if(Attached[i].IsA('xEmitter') && !Attached[i].IsA('BloodJet') 
            && !Attached[i].IsA('Emitter_SeeInvis') && !Attached[i].IsA('SpeedTrail')
            && !Attached[i].IsA('RegenCrosses') && !Attached[i].IsA('OffensiveEffect'))
        {
            xEmitter(Attached[i]).mRegen = false;
        }
    }
}

simulated function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);

    if(Level.NetMode == NM_DedicatedServer)
        return;

    // Trick the client the pawn is still on screen so it continues to update
    // movement animations and preserve footsteps sounds.
    if(PlayerController(Controller) == None)
        LastRenderTime = Level.TimeSeconds;

    if(MyOwner == None)
        MyOwner = Misc_Player(Level.GetLocalPlayerController());
	if ( Level.NetMode == 1 )
  {
    if ( (SpawnedIconTimer != 0) && (SpawnedIconTimer < Level.TimeSeconds) )
    {
      SpawnedIconTimer = 0.0;
      SpawnedIcon = Spawn(Class'VJustSpawnedIcon',self);
    }
    return;
  }
    if(MyOwner != None)
    {
        if(bInvis)
        {
            if(MyOwner.bSeeInvis)
            {
                if(InvisEmitter == None)
                    InvisEmitter = Spawn(class'Emitter_SeeInvis', self,, Location, Rotation);
                AttachToBone(InvisEmitter, 'spine');
            }
            else if(InvisEmitter != None)
            {
                DetachFromBone(InvisEmitter);
                InvisEmitter.mRegen = false;
                InvisEmitter.Destroy();
                InvisEmitter = None;
            }

            return;
        }
        else if(InvisEmitter != None)
        {
            DetachFromBone(InvisEmitter);
            InvisEmitter.mRegen = false;
            InvisEmitter.Destroy();
            InvisEmitter = None;
        }
    }
    else if(bInvis)
        return;

    if(bPlayedDeath)
		return;

}

simulated function DefaultSkin()
{
    local int i;
    for(i=0;i<Skins.Length;i++)
    {
        Skins[i] = MakeDMSkin(Skins[i]);
    }
}

simulated event PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    SetStandardSkin();
	bUnlit = false;
	Super.PlayDying(DamageType, HitLoc);
}

simulated function bool IsSpawnProtectionEnabled()
{
	return SpawnProtectionEnabled;
}

function ActivateSpawnProtection()
{
    SpawnProtectionEnabled = true;
	SpawnProtectionTimer = default.SpawnProtectionTimer;
}

function DeactivateSpawnProtection()
{
	if(SpawnProtectionEnabled && SpawnProtectionTimer!=default.SpawnProtectionTimer)
	{
		if(PlayerController(Controller) != None)
			PlayerController(Controller).ReceiveLocalizedMessage(class'Message_SpawnProtection', 0);
	}
	
    SpawnProtectionEnabled = false;
	SpawnProtectionTimer = 0;
}

function UpdateSpawnProtection()
{
	if(SpawnProtectionTimer==0)
		return;
		
	--SpawnProtectionTimer;
	
	if(PlayerController(Controller) != None)
		PlayerController(Controller).ReceiveLocalizedMessage(class'Message_SpawnProtection', SpawnProtectionTimer);
	
	if(SpawnProtectionTimer>0)
		return;
		
	DeactivateSpawnProtection();
}

event Landed(vector HitNormal)
{
    local bool bPlayLandingSound;
    local Controller C;

    super(UnrealPawn).Landed( HitNormal );
    MultiJumpRemaining = MaxMultiJump;

    bPlayLandingSound = true;
    C = Level.GetLocalPlayerController();
    if(C != None && C == Controller)
        bPlayLandingSound = bPlayOwnLandings;

    if ( (Health > 0) && !bHidden && (Level.TimeSeconds - SplashTime > 0.25) && bPlayLandingSound)
        PlayOwnedSound(GetSound(EST_Land), SLOT_Interact, FMin(1,-0.3 * Velocity.Z/JumpZ));
}

simulated function FootStepping(int Side)
{
    local int SurfaceNum, i;
	local actor A;
	local material FloorMat;
	local vector HL,HN,Start,End,HitLocation,HitNormal;
    local float Volume;
    local int Radius;

    Volume = 0.15;
    Radius = 400;

    if(Misc_BaseGRI(Level.GRI) != None)
    {
        Volume = Misc_BaseGRI(Level.GRI).FootstepVolume;
        Radius = Misc_BaseGRI(Level.GRI).FootstepRadius;
    }

    SurfaceNum = 0;

    for ( i=0; i<Touching.Length; i++ )
		if ( ((PhysicsVolume(Touching[i]) != None) && PhysicsVolume(Touching[i]).bWaterVolume)
			|| (FluidSurfaceInfo(Touching[i]) != None) )
		{
			if ( FRand() < 0.5 )
				PlaySound(sound'PlayerSounds.FootStepWater2', SLOT_Interact, FootstepVolume );
			else
				PlaySound(sound'PlayerSounds.FootStepWater1', SLOT_Interact, FootstepVolume );
				
			if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) && (Level.NetMode != NM_DedicatedServer)
				&& !Touching[i].TraceThisActor(HitLocation, HitNormal,Location - CollisionHeight*vect(0,0,1.1), Location) )
					Spawn(class'WaterRing',,,HitLocation,rot(16384,0,0));
			return;
		}

	if ( bIsCrouched || bIsWalking )
		return;

	if ( (Base!=None) && (!Base.IsA('LevelInfo')) && (Base.SurfaceType!=0) )
	{
		SurfaceNum = Base.SurfaceType;
	}
	else
	{
		Start = Location - Vect(0,0,1)*CollisionHeight;
		End = Start - Vect(0,0,16);
		A = Trace(hl,hn,End,Start,false,,FloorMat);
		if (FloorMat !=None)
			SurfaceNum = FloorMat.SurfaceType;
	}
	PlaySound(SoundFootsteps[SurfaceNum], SLOT_Interact, Volume,,Radius );
}

function bool IsHeadshotDamageType(class<DamageType> damageType)
{
    return super.IsHeadshotDamageType(damageType) || DamageType == class'DamType_HeadShot' || DamageType == class'DamType_ClassicHeadShot';
}


defaultproperties
{
     bAlwaysRelevant=true
     bPlayOwnLandings=true
     SpawnProtectionTimer=4
     ShieldHitMatTime=0.350000
     RagdollLifeSpan=14.000000
     RagInvInertia=4.000001
     RagSpinScale=2.500001
     RagGravScale=1.000001
}
