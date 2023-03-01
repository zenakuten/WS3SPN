class Message_Thaw_GodOfThaw extends LocalMessage;

#exec AUDIO IMPORT FILE=Sounds\GodOfThaw.wav GROUP=Sounds

var Sound GodOfThawSound;
var localized string YouAreGodOfThaw;
var localized string PlayerIsGodOfThaw;

static function string GetString(
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
    if(SwitchNum == 1)
	    return default.YouAreGodOfThaw;
    else
        return RelatedPRI_1.PlayerName@default.PlayerIsGodOfThaw;
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
		P.ClientPlaySound(default.GodOfThawSound);
}

defaultproperties
{
     GodOfThawSound=Sound'3SPNvSoL.Sounds.GodOfThaw'
     YouAreGodOfThaw="GOD OF THAW!"
     PlayerIsGodOfThaw="IS THE GOD OF THAW!"
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(B=0,G=0)
     StackMode=SM_Down
     PosY=0.100000
}
