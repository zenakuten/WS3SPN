//player killed needs a towel
class Message_ComboKing extends LocalMessage;

#exec AUDIO IMPORT FILE=Sounds\ComboKing.wav GROUP=Sounds

var Sound ComboKingSound;
var localized string YouAreComboKing;
var localized string PlayerIsComboKing;

static function string GetString(
    optional int SwitchNum,
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
  if(SwitchNum == 1)
    return default.YouAreComboKing;
  else
    return RelatedPRI_1.PlayerName@default.PlayerIsComboKing;
}

static simulated function ClientReceive(
    PlayerController P,
    optional int SwitchNum,
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    Super.ClientReceive(P, SwitchNum, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    
    if(SwitchNum==1)
        P.ClientPlaySound(default.ComboKingSound);
}

defaultproperties
{
     ComboKingSound=Sound'WS3SPN.Sounds.ComboKing'
     YouAreComboKing="C O M B O  K I N G"
     PlayerIsComboKing="IS   A   C O M B O  K I N G"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=224,G=58,R=196)
     StackMode=SM_Down
     PosY=0.100000
}
