class DamType_HeadShot extends DamTypeSniperHeadShot;

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
			Misc_Player(Killer).BroadcastAward(Class'Message_HeadHunter');	

		if ( (xPRI.HeadCount == Default.AwardLevel) && (Misc_Bot(Killer) != None) )
			Misc_Bot(Killer).BroadcastAward(Class'Message_HeadHunter');	
	}
}

defaultproperties
{
    AwardLevel=5
}
