//================================================================================
// Message_OverTime.
//================================================================================

class Message_OverTime extends LocalMessage;
#exec AUDIO IMPORT FILE=Sounds\overtime.wav GROUP=Sounds

var Sound OvertimeSound;
var string overtime;

static function string GetString (optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  return Default.overtime;
}

static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
  P.ClientPlaySound(Default.OvertimeSound);
}

defaultproperties
{
     OvertimeSound=Sound'WS3SPN.Sounds.overtime'
     overtime="Overtime"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=2
     DrawColor=(G=20,R=20)
     PosY=0.320000
}
