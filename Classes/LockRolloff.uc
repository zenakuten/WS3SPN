/******************************************************************************
Copyright (c) 2005 by Wormbo <wormbo@onlinehome.de>

Enforces the Rolloff value a player connected with, but limits this value to 0.4 and above.
tweaked by Hv for 3SPN RU ----
******************************************************************************/


class LockRolloff extends ReplicationInfo;


//=============================================================================
// Variables
//=============================================================================

var(LockRolloff) noexport const editconst string Build;
var(LockRolloff) noexport const editconst string Copyright;

var AudioSubsystem AudioSubsystem;
var float LockedRolloff;


//== PostBeginPlay ============================================================
/**
Remember the initial rolloff value.
*/
//=============================================================================

simulated function PostBeginPlay()
{
  Super.PostBeginPlay();
  
  if ( Level.NetMode != NM_Client )
    AddToPackageMap();
  
  if ( Level.NetMode == NM_DedicatedServer )
    return;
  
  foreach AllObjects(class'AudioSubsystem', AudioSubsystem) break;
  
  if ( AudioSubsystem != None )
    LockedRolloff = FMax(float(AudioSubsystem.GetPropertyText(string('Rolloff'))), 0.4);
}


//== Tick =====================================================================
/**
Enforce the initial rolloff value.
*/
//=============================================================================

simulated function Tick(float DeltaTime)
{
  local float Rolloff;
  
  if ( Level.NetMode == NM_DedicatedServer ) {
    Disable('Tick');
    return;
  }
  
  if ( AudioSubsystem == None && Level.NextSwitchCountdown == 0 )
    foreach AllObjects(class'AudioSubsystem', AudioSubsystem) break;
  
  if ( AudioSubsystem != None ) {
    Rolloff = float(AudioSubsystem.GetPropertyText(string('Rolloff')));
    if ( Rolloff != FMax(LockedRolloff, 0.4) ) {
      ConsoleCommand('Rolloff' @ FMax(LockedRolloff, 0.4));
    }
  }
}


//=============================================================================
// Default properties
//=============================================================================

defaultproperties
{
     Build="%%%%-%%-%% %%:%%"
     Copyright="Copyright (c) 2005 Wormbo"
}
