//================================================================================
// DamType_ShockBeam.
//================================================================================

class DamType_ShockBeam extends DamTypeShockBeam;

var int AwardLevel;

static function IncrementKills (Controller Killer)
{
  local Misc_PRI xPRI;

  xPRI = Misc_PRI(Killer.PlayerReplicationInfo);
  if ( xPRI != None )
  {
    xPRI.ShockCount++;

    if ( (xPRI.ShockCount == Default.AwardLevel) && (Misc_Player(Killer) != None) )
      Misc_Player(Killer).BroadcastAward(Class'Message_ShockTherapy');

    if ( (xPRI.ShockCount == Default.AwardLevel) && (Misc_Bot(Killer) != None) )
      Misc_Bot(Killer).BroadcastAward(Class'Message_ShockTherapy');
  }
}

defaultproperties
{
    AwardLevel=20
}