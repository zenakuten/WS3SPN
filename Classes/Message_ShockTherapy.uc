//player killed needs a towel
class Message_ShockTherapy extends LocalMessage;

#exec AUDIO IMPORT FILE=Sounds\ShockTherapy.wav GROUP=Sounds

var Sound ShockTherapySound;
var localized string YouAreShockTherapy;
var localized string PlayerIsShockTherapy;

static function string GetString(
    optional int SwitchNum,
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
  if(SwitchNum == 1)
    return default.YouAreShockTherapy;
  else
    return RelatedPRI_1.PlayerName@default.PlayerIsShockTherapy;
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
        P.ClientPlaySound(default.ShockTherapySound);
}

defaultproperties
{
     ShockTherapySound=Sound'WS3SPN.Sounds.ShockTherapy'
     YouAreShockTherapy="S H O C K   T H E R A P Y"
     PlayerIsShockTherapy="IS A SHOCK THERAPIST!"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=224,G=58,R=196)
     StackMode=SM_Down
     PosY=0.100000
}
