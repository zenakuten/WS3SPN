// *F* Developed 2011-2014 rejecht <rejecht at outlook dot com>

class LocalMessage_RageQuit extends LocalMessage
	abstract
	;

var private const name RageQuitSoundName;

var private localized const string
	RageQuitStringPrefix,
	RageQuitStringSuffix
	;

// #Queries

static event string GetString
(
	optional int Index,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object O
)
{
	return
	(
		Default.RageQuitStringPrefix
		$ Class'Klasse'.Static.GetPlayerNameString (RelatedPRI_1)
		$ Default.RageQuitStringSuffix
	);
}

protected static function PlayAnnouncement (PlayerController PC)
{
	PC.QueueAnnouncement
	(
		Default.RageQuitSoundName,
		1,
		AP_Normal,
		255
	);
}

// #Dispatch

static event ClientReceive
(
	PlayerController PC,
	optional int Context,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object O
)
{
	PlayAnnouncement (PC);


	Super.ClientReceive (PC, Context, RelatedPRI_1, RelatedPRI_2, O);
}

// #

defaultproperties
{
     RageQuitSoundName="Rage"
     RageQuitStringSuffix=" RAGE QUIT"
     bIsSpecial=False
     DrawColor=(B=239,G=239,R=239)
}
