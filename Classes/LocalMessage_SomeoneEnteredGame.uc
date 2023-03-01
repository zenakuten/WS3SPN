// *F* Developed 2014 rejecht <rejecht at outlook dot com>

class LocalMessage_SomeoneEnteredGame extends LocalMessage_GameEvents
	abstract
	;

// #Class

var private float LastTime;
var private int AccumulatedCount;
var private string
	AccumulatedString,
	CompositeString;

// #Class

var(ConstantStrings) private localized const string
	SomeoneJoinedSingularPrefixString,
	SomeoneJoinedSingularSuffixString,
	SomeoneJoinedPluralPrefixString,
	SomeoneJoinedPluralSuffixString;

// #Class

protected static function string GetCompositeString
(
	PlayerController PC,
	optional int Count,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object O,
	optional string PlayersString
)
{
	if (Count > 1)
	{
		return
		(
			Default.SomeoneJoinedPluralPrefixString
			$ Count
			$ Default.SomeoneJoinedPluralSuffixString
		);
    }
    else
    {
		return
		(
			Default.SomeoneJoinedSingularPrefixString
			$ Count
			$ Default.SomeoneJoinedSingularSuffixString
		);
    }
}

// #Queries

static event string GetString
(
	optional int Count,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object O
)
{
	return Default.CompositeString;
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
	local string PlayerNameString;
	local float Difference;

	if
	(
		(Default.LastTime == 0.0f)
		||
		(Default.LastTime > PC.Level.TimeSeconds)
	)
	{
		Default.LastTime = PC.Level.TimeSeconds - GetLifeTime (Context);
    }

	Difference = PC.Level.TimeSeconds - Default.LastTime;
	PlayerNameString = Class'Klasse'.Static.GetPlayerNameString (RelatedPRI_1);

	if (Difference >= GetLifeTime (Context))
	{
		Default.AccumulatedString = PlayerNameString;
		Default.AccumulatedCount = 1;
	}
	else
	{
		if (InStr (Default.AccumulatedString, PlayerNameString) == -1)
		{
			Default.AccumulatedString = PlayerNameString $ "," @ Default.AccumulatedString;
			++Default.AccumulatedCount;
		}
		else
		{
			++Default.AccumulatedCount;
		}
	}

	Default.LastTime = PC.Level.TimeSeconds;

	Default.CompositeString = Static.GetCompositeString (PC, Default.AccumulatedCount, RelatedPRI_1, RelatedPRI_2, O, Default.AccumulatedString);


	Super.ClientReceive (PC, Default.AccumulatedCount, RelatedPRI_1, RelatedPRI_2, O);
}

// #

defaultproperties
{
     SomeoneJoinedSingularSuffixString=" player entered the game!"
     SomeoneJoinedPluralSuffixString=" players entered the game!"
}
