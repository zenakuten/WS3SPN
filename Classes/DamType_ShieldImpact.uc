//================================================================================
// DamType_ShieldImpact.
//================================================================================

class DamType_ShieldImpact extends DamTypeShieldImpact;

var int AwardLevel;
static function IncrementKills(Controller Killer)
{
	local Misc_PRI xPRI;
	
	
	
	
	

	xPRI = Misc_PRI(Killer.PlayerReplicationInfo);
	if(xPRI != None)
	{
		++xPRI.ShieldCount;
		if((xPRI.ShieldCount == 1) && (Misc_Player(Killer) != None))
			Misc_Player(Killer).BroadcastAnnouncement(class'Message_Shield');
	} 
	
	
	
	
	
}

defaultproperties
{
     AwardLevel=1
}
