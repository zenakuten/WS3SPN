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
		if((xPRI.ShieldCount >= default.AwardLevel) && (Misc_Player(Killer) != None))
			Misc_Player(Killer).BroadcastAward(class'Message_Shield');

		if((xPRI.ShieldCount >= default.AwardLevel) && (Misc_Bot(Killer) != None))
			Misc_Bot(Killer).BroadcastAward(class'Message_Shield');
	} 
}

defaultproperties
{
    AwardLevel=1
}
