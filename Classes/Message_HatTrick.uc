//================================================================================
// Message_HatTrick.
//================================================================================

class Message_HatTrick extends LocalMessage;
//#exec AUDIO IMPORT FILE=Sounds\HatTrick.wav GROUP=Sounds
//var Sound hattricksound;
var localized string HatTrickString;

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( Switch == 0 )
  {
    return Default.HatTrickString;
  }
}

static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
  if ( SwitchNum == 0 )
  {
    UnrealPlayer(P).ClientDelayedAnnouncementNamed('HatTrick',30);
	//P.ClientPlaySound(Default.hattricksound);
  }
}

defaultproperties
{
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(B=243,G=246,R=165)
     PosY=0.250000
}
