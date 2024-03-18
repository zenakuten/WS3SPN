class Message_Grenadier extends LocalMessage;

#exec AUDIO IMPORT FILE=Sounds\grenade.wav GROUP=Sounds

var Sound GrenadeSound;
var localized string Grenade4;
var localized string Secondmessa;

static function string GetString(
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
    if(SwitchNum == 1)
	    return default.Grenade4;
    else
        return RelatedPRI_1.PlayerName@default.Secondmessa;
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
		P.ClientPlaySound(default.GrenadeSound);
}

defaultproperties
{
     GrenadeSound=Sound'WS3SPN.Sounds.Grenade'
     Grenade4="G R E N A D I E R"
     Secondmessa="Is A Grenadier"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=0,G=0)
     StackMode=SM_Down
     PosY=0.100000
}
