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
			Misc_Player(Killer).BroadcastAnnouncement(Class'Message_FlakMan');
	}
}

defaultproperties
{
     AwardLevel=7
}
