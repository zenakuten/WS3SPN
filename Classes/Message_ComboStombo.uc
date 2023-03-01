class Message_ComboStombo extends LocalMessage
  
  HideCategories(Movement,Collision,Lighting,LightColor,Karma,Force);

var(Message) localized string StomboText;
var(Message) localized string ComboStealText;

static function string GetString (optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( SwitchNum ==  2)
  {
    return Default.StomboText;
  }
  if ( SwitchNum == 1 )
  {
    return Default.ComboStealText;
  }
}

defaultproperties
{
     ComboStealText="Combo Stealer"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=2
     DrawColor=(B=243,G=246,R=165)
     PosY=0.320000
}
