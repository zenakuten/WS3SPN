class Message_ForceAutoBalance extends LocalMessage;

var string ForceAutoBalanceString;

static function string GetString(
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
    return default.ForceAutoBalanceString;
}

defaultproperties
{
     ForceAutoBalanceString="Teens will be nakedly balanced like shit and as bad as it can be at round start."
     bIsSpecial=False
}
