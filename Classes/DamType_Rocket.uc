class DamType_Rocket extends DamTypeRocket;
var int AwardLevel;
static function IncrementKills(Controller Killer)
{
	local Misc_PRI xPRI;
	
	
	
	
	

	xPRI = Misc_PRI(Killer.PlayerReplicationInfo);
	if(xPRI != None)
	{
		++xPRI.RoxCount;
		if((xPRI.RoxCount == 8) && (Misc_Player(Killer) != None))
			Misc_Player(Killer).BroadcastAnnouncement(class'Message_RocketMan');
	} 
	
	
	
	
	
}

defaultproperties
{
     AwardLevel=8
}
