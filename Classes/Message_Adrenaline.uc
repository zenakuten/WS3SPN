//================================================================================
// Message_Adrenaline.
//================================================================================

class Message_Adrenaline extends LocalMessage;
#exec AUDIO IMPORT FILE=Sounds\MateOut.wav GROUP=Sounds
var string AdrenMessage;
var string MateOutMessage;
var Sound AdrenSound;
var Sound MateOutSound;

static function string GetString (optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( SwitchNum == 0 )
  {
    return Default.AdrenMessage;
  } else {
    return Default.MateOutMessage;
  }
}

static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
  if ( SwitchNum == 0 )
  {
    P.ClientPlaySound(Default.AdrenSound);
  } else {
    P.ClientPlaySound(Default.MateOutSound);
  }
}

defaultproperties
{
     AdrenMessage="Adrenaline"
     MateOutMessage="Mate is out RES! !"
     AdrenSound=Sound'AnnouncerMAIN.adrenalin'
     MateOutSound=Sound'WS3SPN.Sounds.MateOut'
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(B=0,R=66)
     PosY=0.320000
}
