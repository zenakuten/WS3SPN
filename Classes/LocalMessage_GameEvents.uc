// *F* Developed 2014 rejecht <rejecht at outlook dot com>

class LocalMessage_GameEvents extends CriticalEventPlus
	abstract
	;

// #Rendering

static event RenderComplexMessage
(
	Canvas Canvas,
	out float XL,
	out float YL,
	optional string MessageString,
	optional int IndexSymbol,
	optional PlayerReplicationInfo RelatedPRI_1_Subject,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object O
)
{
	if (Canvas.DrawColor.A < (Default.DrawColor.A / Default.Lifetime))
	{
		Canvas.DrawColor.A = Canvas.DrawColor.A * Default.Lifetime;
	}
	else
	{
		Canvas.DrawColor.A = Default.DrawColor.A;
	}

	Canvas.DrawText (MessageString, True);
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
// 	if (PC.Level.NetMode == NM_Client)
// 	{
// 		Super.ClientReceive (PC, Context, RelatedPRI_1, RelatedPRI_2, O);
//     }

	Super.ClientReceive (PC, Context, RelatedPRI_1, RelatedPRI_2, O);
}

// #

defaultproperties
{
     bComplexString=True
     bIsConsoleMessage=False
     DrawColor=(G=255,R=255)
     StackMode=SM_Down
     PosY=0.100000
     FontSize=-2
}
