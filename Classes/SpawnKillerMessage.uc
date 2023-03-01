//================================================================================
// SpawnKillerMessage.
//================================================================================

class SpawnKillerMessage extends LocalMessage;

var Sound SpawnKillSound;
var localized string SpawnKillMsg;
var localized string PlayerIsSpawnKiller;

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( Switch == 1 )
  {
    return Default.SpawnKillMsg;
  } else {
    return RelatedPRI_1.PlayerName @ Default.PlayerIsSpawnKiller;
  }
}

static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
  if ( SwitchNum == 1 )
  {
    P.ClientPlaySound(Default.SpawnKillSound);
  }
}

static function GetPos (int Switch, out EDrawPivot OutDrawPivot, out EStackMode OutStackMode, out float OutPosX, out float OutPosY)
{
  Super.GetPos(Switch,OutDrawPivot,OutStackMode,OutPosX,OutPosY);
  if ( Switch == 1 )
  {
    OutPosY = 0.69999999;
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
     SpawnKillSound=Sound'AnnouncerMAIN.Spawn_Killer'
     SpawnKillMsg="S P A W N  K I L L E R  (+1pts)"
     PlayerIsSpawnKiller="IS A SPAWN KILLER"
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(R=0)
}
