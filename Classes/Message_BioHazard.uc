//player killed needs a towel
class Message_BioHazard extends LocalMessage;

#exec AUDIO IMPORT FILE=Sounds\BioHazard.wav GROUP=Sounds

var Sound BukkakeSound;
var localized string YouGaveBukkake;
var localized string PlayerGaveBukkake;

static function string GetString(
    optional int SwitchNum,
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
  if(SwitchNum == 1)
    return default.YouGaveBukkake;
  else
    return RelatedPRI_1.PlayerName@default.PlayerGaveBukkake;
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
        P.ClientPlaySound(default.BukkakeSound);
}

defaultproperties
{
     BukkakeSound=Sound'3SPNvSoL.Sounds.BioHazard'
     YouGaveBukkake="BIO HAZARD!"
     PlayerGaveBukkake="BIO HAZARD!"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=93,G=220,R=126)
     StackMode=SM_Down
     PosY=0.100000
}
