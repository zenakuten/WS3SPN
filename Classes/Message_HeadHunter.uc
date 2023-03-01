//================================================================================
// Message_HeadHunter.
//================================================================================

class Message_HeadHunter extends LocalMessage;

var Sound HeadHunterSound;
var localized string YouAreHeadHunter;
var localized string PlayerIsHeadHunter;

static function string GetString (optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( SwitchNum == 1 )
  {
    return Default.YouAreHeadHunter;
  } else {
    return RelatedPRI_1.PlayerName @ Default.PlayerIsHeadHunter;
  }
}

static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
  if ( SwitchNum == 1 )
  {
    P.ClientPlaySound(Default.HeadHunterSound);
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
     HeadHunterSound=Sound'AnnouncerMAIN.Headhunter'
     YouAreHeadHunter="H E A D  H U N T E R"
     PlayerIsHeadHunter="Is A Head Hunter"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
}
