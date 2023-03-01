// *F* Developed 2011-2014 rejecht <rejecht at outlook dot com>

class Klasse extends Object
	abstract
	HideDropDown
	;

static final function string GetPlayerNameString
(
	PlayerReplicationInfo PRI,
	optional bool bPreviousName
)
{
	if (PRI == None)
	{
		return class'XGame.xDeathMessage'.Default.SomeoneString;
	}

	if (!bPreviousName)
	{
		if (PRI.PlayerName != "")
		{
			return PRI.PlayerName;
		}
		else
		{
			return class'XGame.xDeathMessage'.Default.SomeoneString;
		}
	}
	else
	{
		if (PRI.OldName != "")
		{
			return PRI.OldName;
		}
		else
		{
			return class'XGame.xDeathMessage'.Default.SomeoneString;
		}
	}


}

defaultproperties
{
}
