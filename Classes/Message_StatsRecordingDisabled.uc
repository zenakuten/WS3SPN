class Message_StatsRecordingDisabled extends LocalMessage;

var localized string disabled;
var localized string recor;
var localized string warmup;
static function string GetString(
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
    switch(SwitchNum)
    {
        case 0: return default.disabled;
        case 1: return default.recor;
        case 2: return default.Warmup;
    }
}

static simulated function ClientReceive( 
	PlayerController P,
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	default.DrawColor.G = 0;
	default.DrawColor.B = 0;
	
	Super.ClientReceive(P, SwitchNum, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

defaultproperties
{
     Disabled="ÿ Stats are disabled"
     recor="ÿ Stats are recorded"
     Warmup="ÿ Stats are disabled in warmup"
     bIsUnique=True
     bFadeMessage=True
     StackMode=SM_Down
     PosY=0.875000
}
