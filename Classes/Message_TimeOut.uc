class Message_TimeOut extends LocalMessage;

static function string GetString(
    optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
	return "TIME OUT!";
}

defaultproperties
{
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=0)
     StackMode=SM_Down
     PosY=0.500000
}
