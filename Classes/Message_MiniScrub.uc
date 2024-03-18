//================================================================================
// Message_Mini.
//================================================================================

class Message_MiniScrub extends LocalMessage;
//#exec AUDIO IMPORT FILE=Sounds\guun.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\scrub.wav GROUP=Sounds


var Sound MiniSound;
var localized string YouAreGatling;
var localized string PlayerIsGatling;

static function string GetString (optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( SwitchNum == 1 )
  {
    return Default.YouAreGatling;
  } else {
    return RelatedPRI_1.PlayerName @ Default.PlayerIsGatling;
  }
}

static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
  if ( SwitchNum == 1 )
  {
    P.ClientPlaySound(Default.MiniSound);
  }
}

defaultproperties
{
     MiniSound=Sound'WS3SPN.Sounds.scrub'
     YouAreGatling="M I N I G U N    S C R U B"
     PlayerIsGatling="Is a M I N I G U N    S C R U B"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
     DrawColor=(R=128)
}
