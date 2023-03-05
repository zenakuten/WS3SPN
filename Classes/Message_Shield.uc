class Message_Shield extends LocalMessage;

#exec AUDIO IMPORT FILE=Sounds\HaHa.wav GROUP=Sounds

var Sound RocketManSound;
var localized string YouAreRocketMan;
var localized string PlayerIsRocketMan;

static function string GetString(
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
    if(SwitchNum == 1)
	    return default.YouAreRocketMan;
    else
        return RelatedPRI_1.PlayerName@default.PlayerIsRocketMan;
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
    
	if(SwitchNum==0 && RelatedPRI_2 == None)
		P.ClientPlaySound(default.RocketManSound);
	
	if(SwitchNum==1)
		P.ClientPlaySound(default.RocketManSound);
}

defaultproperties
{
     RocketManSound=Sound'3SPNvSoL.Sounds.HaHa'
     YouAreRocketMan="H U M I L I A T I O N"
     PlayerIsRocketMan="IS A SHIELDER!"
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(B=0,G=0)
     StackMode=SM_Down
     PosY=0.100000
}
