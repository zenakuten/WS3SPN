//================================================================================
// TeamKillerMessage.
//================================================================================

class TeamKillerMessage extends LocalMessage;

var Sound TeamKillSound;
var localized string TeamKillMsg;
var localized string PlayerIsTeamKiller;

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( Switch == 1 )
  {
    return Default.TeamKillMsg;
  } else {
    return Misc_PRI(RelatedPRI_1).GetColoredName2(Default.DrawColor) @ Default.PlayerIsTeamKiller;
  }
}

static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
  if ( SwitchNum == 1 )
  {
    P.ClientPlaySound(Default.TeamKillSound);
  }
}

static function GetPos (int Switch, out EDrawPivot OutDrawPivot, out EStackMode OutStackMode, out float OutPosX, out float OutPosY)
{
  Super.GetPos(Switch,OutDrawPivot,OutStackMode,OutPosX,OutPosY);
  if ( Switch == 1 )
  {
    OutPosY = 0.45999999;
  } else {
    OutPosY = 0.12;
  }
}

static function int GetFontSize (int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
  if ( Switch == 1 )
  {
    return 0;
  } else {
    return -1;
  }
}

defaultproperties
{
     TeamKillSound=Sound'AnnouncerMAIN.Team_Killer'
     TeamKillMsg="T E A M  K I L L E R (-3pts)"
     PlayerIsTeamKiller="IS A TEAM KILLER"
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(B=0,G=0)
}
