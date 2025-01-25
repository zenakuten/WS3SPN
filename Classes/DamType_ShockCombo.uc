//================================================================================
// DamType_ShockCombo.
//================================================================================

class DamType_ShockCombo extends DamTypeShockCombo;

var int AwardLevel;
var int KingAwardLevel;

static function IncrementKills (Controller Killer)
{
  local Misc_PRI xPRI;

  xPRI = Misc_PRI(Killer.PlayerReplicationInfo);
  if ( xPRI != None )
  {
    xPRI.combocount++;

    if ( (xPRI.combocount == Default.AwardLevel) && (Misc_Player(Killer) != None) )
      Misc_Player(Killer).BroadcastAward(Class'Message_Combowhore');

    if ( (xPRI.combocount == Default.AwardLevel) && (Misc_Bot(Killer) != None) )
      Misc_Bot(Killer).BroadcastAward(Class'Message_Combowhore');

    if ( (xPRI.combocount == Default.KingAwardLevel) && (Misc_Player(Killer) != None) )
      Misc_Player(Killer).BroadcastAward(Class'Message_ComboKing');

    if ( (xPRI.combocount == Default.KingAwardLevel) && (Misc_Bot(Killer) != None) )
      Misc_Bot(Killer).BroadcastAward(Class'Message_ComboKing');
  }
}

defaultproperties
{
    AwardLevel=8
    KingAwardLevel=13
}
