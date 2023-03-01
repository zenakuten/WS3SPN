//================================================================================
// Misc_KillerMessage.
//================================================================================

class Misc_KillerMessage extends xKillerMessagePlus;

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( RelatedPRI_1 == None )
  {
    return "";
  }
  if ( RelatedPRI_2 == None )
  {
    return "";
  }
  if ( RelatedPRI_2.PlayerName != "()" )
  {
    return Default.YouKilled @ Misc_PRI(RelatedPRI_2).GetColoredName2(Default.DrawColor) @ Default.YouKilledTrailer;
  }
}

defaultproperties
{
     YouKilled="You fragged"
     PosY=0.120000
}
