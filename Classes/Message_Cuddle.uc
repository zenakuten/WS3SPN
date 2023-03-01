//================================================================================
// Message_Cuddle.
//================================================================================

class Message_Cuddle extends LocalMessage;

var localized string CuddleText;
var localized string HuggedText;

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( Switch == 0 )
  {
    return Default.CuddleText;
  }
  if ( (Switch == 1) && (RelatedPRI_1 != None) && (RelatedPRI_2 != None) )
  {
    return Misc_PRI(RelatedPRI_1).GetColoredName2(Default.DrawColor) @ Default.HuggedText @ Misc_PRI(RelatedPRI_2).GetColoredName2(Default.DrawColor);
  }
  return "";
}

static function GetPos (int Switch, out EDrawPivot OutDrawPivot, out EStackMode OutStackMode, out float OutPosX, out float OutPosY)
{
  Super.GetPos(Switch,OutDrawPivot,OutStackMode,OutPosX,OutPosY);
  if ( Switch == 0 )
  {
    OutPosY = 0.69999999;
  } else {
    OutPosY = 0.12;
  }
}

static function int GetFontSize (int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
  if ( Switch == 0 )
  {
    return 0;
  } else {
    return -1;
  }
}

defaultproperties
{
     CuddleText="! C U D L L E !"
     HuggedText="Hugged"
     bIsPartiallyUnique=True
     bFadeMessage=True
     DrawColor=(G=128)
}
