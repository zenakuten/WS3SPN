class DamType_RocketHoming extends DamTypeRocketHoming;

var int AwardLevel;
var int AwardLevelScience;
static function IncrementKills(Controller Killer)
{
	local Misc_PRI xPRI;

	xPRI = Misc_PRI(Killer.PlayerReplicationInfo);
	if(xPRI != None)
	{
		++xPRI.RoxCount;
		if((xPRI.RoxCount == default.AwardLevel) && (Misc_Player(Killer) != None))
			Misc_Player(Killer).BroadcastAward(class'Message_RocketMan');

		if((xPRI.RoxCount == default.AwardLevel) && (Misc_Bot(Killer) != None))
			Misc_Bot(Killer).BroadcastAward(class'Message_RocketMan');

		if((xPRI.RoxCount == default.AwardLevelScience) && (Misc_Player(Killer) != None))
			Misc_Player(Killer).BroadcastAward(class'Message_RocketScience');

		if((xPRI.RoxCount == default.AwardLevelScience) && (Misc_Bot(Killer) != None))
			Misc_Bot(Killer).BroadcastAward(class'Message_RocketScience');            
	}
}

defaultproperties
{
    AwardLevel=8
    AwardLevelScience=15
}
