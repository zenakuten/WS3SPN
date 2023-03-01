class DamType_BioGlob extends DamTypeBioGlob;

#exec AUDIO IMPORT FILE=Sounds\Bukkake.wav     	    GROUP=Sounds

var Sound BukkakeSound;
var int AwardLevel;
static function IncrementKills(Controller Killer)
{
	local xPlayerReplicationInfo xPRI;

	xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( xPRI != None )
	{
		xPRI.ranovercount++;    // using ranovercount to count bio kills for this
		if ((xPRI.ranovercount == 5) && (UnrealPlayer(Killer) != None))
            UnrealPlayer(Killer).ClientDelayedAnnouncement(default.BukkakeSound, 15);
	}
}

defaultproperties
{
     BukkakeSound=Sound'3SPNvSoL.Sounds.Bukkake'
     AwardLevel=5
}
