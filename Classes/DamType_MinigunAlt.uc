//================================================================================
// DamType_MinigunAlt.
//================================================================================

class DamType_MinigunAlt extends DamTypeMinigunAlt;

var int AwardLevel;
var int ScrubLevel;

static function IncrementKills(Controller Killer)
{
    local Misc_PRI xPRI;

    xPRI = Misc_PRI(Killer.PlayerReplicationInfo);
    
    if(xPRI != none)
    {
        ++ xPRI.MinigunCount;
        
        if((xPRI.MinigunCount == default.AwardLevel) && Misc_Player(Killer) != none)
            Misc_Player(Killer).BroadcastAward(class'Message_Mini');

        if((xPRI.MinigunCount == default.AwardLevel) && Misc_Bot(Killer) != none)
            Misc_Bot(Killer).BroadcastAward(class'Message_Mini');

        if((xPRI.MinigunCount == default.Scrublevel) 
            && Misc_Player(Killer) != none 
            && Misc_BaseGRI(Misc_Player(Killer).GameReplicationInfo) != None
            && Misc_BaseGRI(Misc_Player(Killer).GameReplicationInfo).bEnableAntiAwards)
            Misc_Player(Killer).BroadcastAward(class'Message_MiniScrub');
    }
}

defaultproperties
{
    AwardLevel=3
    ScrubLevel=6
}
