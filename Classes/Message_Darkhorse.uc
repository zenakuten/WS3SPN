class Message_Darkhorse extends LocalMessage;

#exec AUDIO IMPORT FILE=Sounds\DarkHorse.wav GROUP=Sounds

var Sound DarkhorseSound;

var localized string YouAreADarkHorse;
var localized string PlayerIsDarkHorseOpen;
var localized string PlayerIsDarkHorse;

static function string GetString(
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
    if(SwitchNum == 1)
	    return default.YouAreADarkHorse;
    else
        return default.PlayerIsDarkHorseOpen@RelatedPRI_1.PlayerName@default.PlayerIsDarkHorse;
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

	P.ClientPlaySound(default.DarkHorseSound);
}

defaultproperties
{
     DarkhorseSound=Sound'WS3SPN.Sounds.DarkHorse'
     YouAreADarkHorse="D A R K   H O R S E!"
     PlayerIsDarkHorse="IS   A   D A R K   H O R S E!"
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(B=150,G=0,R=50)
     StackMode=SM_Down
     PosY=0.675000
}
