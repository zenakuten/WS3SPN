class KillingSpreeCheersMessage extends KillingSpreeMessage;

#exec AUDIO IMPORT FILE=Sounds\killingspree.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\rampage.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\dominating.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\unstoppable.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\godlike.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\wickedsick.wav GROUP=Sounds

var Sound CheerSound[6];

static simulated function ClientReceive( 
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	if (RelatedPRI_2 != None)
		return;

	if ( (RelatedPRI_1 == P.PlayerReplicationInfo) 
		|| (P.PlayerReplicationInfo.bOnlySpectator && (Pawn(P.ViewTarget) != None) && (Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_1)) )
    {
		P.PlayRewardAnnouncement(Default.SpreeSoundName[Switch],1,true);
        if(Misc_Player(P) != None && Misc_Player(P).bKillingSpreeCheers)
        {
            Misc_Player(P).ClientDelayedSound(Default.CheerSound[Switch], 1.5);
        }
    }
	else
    {
		P.PlayBeepSound();
    }
}

defaultproperties
{
    CheerSound(0)=Sound'3SPNvSoL.Sounds.killingspree'
    CheerSound(1)=Sound'3SPNvSoL.Sounds.rampage'
    CheerSound(2)=Sound'3SPNvSoL.Sounds.dominating'
    CheerSound(3)=Sound'3SPNvSoL.Sounds.unstoppable'
    CheerSound(4)=Sound'3SPNvSoL.Sounds.godlike'
    CheerSound(5)=Sound'3SPNvSoL.Sounds.wickedsick'
}