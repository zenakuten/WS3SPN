class Message_StatsRecordingDisabled extends LocalMessage;

var localized string disabled;
var localized string recor;
static function string GetString(
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
	return "Stats are disabled cause Player < 6";
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
     bIsUnique=True
     bFadeMessage=True
     StackMode=SM_Down
     PosY=0.875000
}
