//================================================================================
// DamType_MinigunBullet.
//================================================================================

class DamType_MinigunBullet extends DamTypeMinigunBullet;




var int AwardLevel;

static function IncrementKills(Controller Killer)
{
    local Misc_PRI xPRI;

    xPRI = Misc_PRI(Killer.PlayerReplicationInfo);
    
    if(xPRI != none)
    {
        ++ xPRI.MinigunCount;
        
        if((xPRI.MinigunCount == default.AwardLevel) && Misc_Player(Killer) != none)
        {
            Misc_Player(Killer).BroadcastAnnouncement(class'Message_Mini');
        }
    }
   
}

defaultproperties
{
     AwardLevel=3
}
