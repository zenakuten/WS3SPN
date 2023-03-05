class DamType_FlakShell extends DamTypeFlakShell;

var int AwardLevel;

static function IncrementKills(Controller Killer)
{
	local xPlayerReplicationInfo xPRI;

	xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( xPRI != None )
	{
		xPRI.flakcount++;
		if ( (xPRI.flakcount == Default.AwardLevel) && (Misc_Player(Killer) != None) )
			Misc_Player(Killer).BroadcastAward(Class'Message_FlakMan');

		if ( (xPRI.flakcount == Default.AwardLevel) && (Misc_Bot(Killer) != None) )
			Misc_Bot(Killer).BroadcastAward(Class'Message_FlakMan');
	}
}

defaultproperties
{
    AwardLevel=7
}
