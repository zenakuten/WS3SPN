//================================================================================
// Message_FlawlessVHumiliatingD.
//================================================================================

class Message_FlawlessVHumiliatingD extends LocalMessage;

var(Message) localized string FlawlessText;
var(Message) localized string HumiliatingDefeatText;

static function string GetString (optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( SwitchNum == 1 )
  {
    return Default.FlawlessText;
  }
  if ( SwitchNum == 2 )
  {
    return Default.HumiliatingDefeatText;
  }
}

static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
  if ( SwitchNum == 1 )
  {
    UnrealPlayer(P).ClientDelayedAnnouncementNamed('Flawless_victory',18);
  }
  if ( SwitchNum == 2 )
  {
    UnrealPlayer(P).ClientDelayedAnnouncementNamed('Humiliating_defeat',18);
  }
}

defaultproperties
{
     FlawlessText="Flawless Victory"
     HumiliatingDefeatText="Humiliating Defeat"
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(B=243,G=246,R=165)
     StackMode=SM_Down
     PosY=0.400000
}
