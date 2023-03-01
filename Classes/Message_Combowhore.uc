//player killed needs a towel
class Message_Combowhore extends LocalMessage;

#exec AUDIO IMPORT FILE=Sounds\Combowhore.wav GROUP=Sounds

var Sound CombowhoreSound;
var localized string YouAreCombowhore;
var localized string PlayerIsCombowhore;

static function string GetString(
    optional int SwitchNum,
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
  if(SwitchNum == 1)
    return default.YouAreCombowhore;
  else
    return RelatedPRI_1.PlayerName@default.PlayerIsCombowhore;
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
        P.ClientPlaySound(default.CombowhoreSound);
}

defaultproperties
{
     CombowhoreSound=Sound'3SPNvSoL.Sounds.Combowhore'
     YouAreCombowhore="C O M B O  W H O R E"
     PlayerIsCombowhore="IS   A   C O M B O  W H O R E"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=224,G=58,R=196)
     StackMode=SM_Down
     PosY=0.100000
}
