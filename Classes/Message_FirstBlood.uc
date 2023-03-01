//================================================================================
// Message_FirstBlood.
//================================================================================

class Message_FirstBlood extends LocalMessage;

//#exec AUDIO IMPORT FILE=Sounds\firstblood.wav GROUP=Sounds
//var Sound firstblood;
//
//var localized string YouHaveFirstBlood;
//var localized string HasFirstBlood;
//
//static function string GetString (optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
//{
//  if ( SwitchNum == 1 )
//  {
//    return Default.YouHaveFirstBlood;
//  } else {
//    return RelatedPRI_1.PlayerName @ Default.HasFirstBlood;
//  }
//}
//
//static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
//{
//  if ( RelatedPRI_1 == P.PlayerReplicationInfo )
//  {
//    SwitchNum = 1;
//  }
//  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
//  if ( SwitchNum == 1 )
//  {
//    P.PlayRewardAnnouncement('first_blood',1,True);
//	P.ClientPlaySound(default.firstblood);
//	
//  }
//}
//
//static function GetPos (int Switch, out EDrawPivot OutDrawPivot, out EStackMode OutStackMode, out float OutPosX, out float OutPosY)
//{
//  Super.GetPos(Switch,OutDrawPivot,OutStackMode,OutPosX,OutPosY);
//  if ( Switch == 1 )
//  {
//    OutPosY = 0.69999999;
//  } else {
//    OutPosY = 0.82999998;
//  }
//}
//
//static function int GetFontSize (int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
//{
//  if ( Switch == 1 )
//  {
//    return 0;
//  } else {
//    return -1;
//  }
//}

defaultproperties
{
}
