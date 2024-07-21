class KillingSpreeCheersMessage extends KillingSpreeMessage;

#exec AUDIO IMPORT FILE=Sounds\killingspree.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\rampage.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\dominating.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\unstoppable.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\godlike.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\wickedsick.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\aww1.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\aww2.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\lol1.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\lol2.wav GROUP=Sounds

var Sound CheerSound[6];
var Sound EndCheerSound[2];
var Sound EndSelfCheerSound[2];

enum SpreeType
{
    SpreeType_NONE,
    SpreeType_NORMAL,
    SpreeType_ENDSELF,
    SpreeType_ENDPLAYER
};

static function SpreeType GetSpreeType(
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2
	)
{
	if (RelatedPRI_2 == None)
	{
		if (RelatedPRI_1 == None)
			return SpreeType_NONE;

		if (RelatedPRI_1.PlayerName != "")
			return SpreeType_NORMAL;
	} 
	else 
	{
		if (RelatedPRI_1 == None)
		{
			if (RelatedPRI_2.PlayerName != "")
			{
                return SpreeType_ENDSELF;
			}
		} 
		else 
		{
			return SpreeType_ENDPLAYER;
		}
	}

	return SpreeType_NONE;
}


static simulated function ClientReceive( 
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
    local SpreeType spree;

	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    spree = GetSpreeType(RelatedPRI_1, RelatedPRI_2);
    if(Misc_Player(P) != None && Misc_Player(P).bKillingSpreeCheers)
    {
        if(spree == SpreeType_ENDPLAYER)
        {
            if(RelatedPRI_1 != None)
            {
                if ( (RelatedPRI_1 == P.PlayerReplicationInfo) 
                    || (P.PlayerReplicationInfo.bOnlySpectator && (Pawn(P.ViewTarget) != None) && (Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_1)) )
                {
                    Misc_Player(P).ClientDelayedSound(Default.EndCheerSound[Rand(1)], 1.5, 1.0);
                }
            }
        }
        else if(spree == SpreeType_ENDSELF)
        {
            if(RelatedPRI_2 != None)
            {
                if ( (RelatedPRI_2 == P.PlayerReplicationInfo) 
                    || (P.PlayerReplicationInfo.bOnlySpectator && (Pawn(P.ViewTarget) != None) && (Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_2)) )
                {
                    Misc_Player(P).ClientDelayedSound(Default.EndSelfCheerSound[Rand(1)], 1.5, 1.0);
                }
            }
        }
    }

	if (RelatedPRI_2 != None)
		return;

	if ( (RelatedPRI_1 == P.PlayerReplicationInfo) 
		|| (P.PlayerReplicationInfo.bOnlySpectator && (Pawn(P.ViewTarget) != None) && (Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_1)) )
    {
		P.PlayRewardAnnouncement(Default.SpreeSoundName[Switch],1,true);
        if(Misc_Player(P) != None && Misc_Player(P).bKillingSpreeCheers)
        {
            Misc_Player(P).ClientDelayedSound(Default.CheerSound[Switch], 1.5, 1.0);
        }
    }
	else
    {
        P.PlayBeepSound();
    }
}

defaultproperties
{
    CheerSound(0)=Sound'WS3SPN.Sounds.killingspree'
    CheerSound(1)=Sound'WS3SPN.Sounds.rampage'
    CheerSound(2)=Sound'WS3SPN.Sounds.dominating'
    CheerSound(3)=Sound'WS3SPN.Sounds.unstoppable'
    CheerSound(4)=Sound'WS3SPN.Sounds.godlike'
    CheerSound(5)=Sound'WS3SPN.Sounds.wickedsick'
    EndCheerSound(0)=Sound'WS3SPN.Sounds.aww1'
    EndCheerSound(1)=Sound'WS3SPN.Sounds.aww2'
    EndSelfCheerSound(0)=Sound'WS3SPN.Sounds.lol1'
    EndSelfCheerSound(1)=Sound'WS3SPN.Sounds.lol2'
}