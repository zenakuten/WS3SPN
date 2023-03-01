class DamType_ClassicHeadShot extends UTClassic.DamTypeClassicHeadShot;

var int AwardLevel;

static function IncrementKills(Controller Killer)
{
	local xPlayerReplicationInfo xPRI;
	
	if ( PlayerController(Killer) == None )
		return;
		
	PlayerController(Killer).ReceiveLocalizedMessage( Default.KillerMessage, 0, Killer.PlayerReplicationInfo, None, None );
	xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( xPRI != None )
	{
		xPRI.HeadCount++;
		
        if ( (xPRI.HeadCount == Default.AwardLevel) && (Misc_Player(Killer) != None) )
            Misc_Player(Killer).BroadcastAnnouncement(Class'Message_HeadHunter');		
	}
}

defaultproperties
{
     AwardLevel=5
     DeathString="%o's put a silver bullet in %k's skull."
}
