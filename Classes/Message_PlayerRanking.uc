class Message_PlayerRanking extends LocalMessage;

var array<string> RankingMessages;
var array<Color> RankingColors;
var string PlayerName;

static function string GetString(
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
	if(SwitchNum<default.RankingMessages.Length)
		return default.RankingMessages[SwitchNum]$default.PlayerName;
	return "";
}

static simulated function ClientReceive( 
	PlayerController P,
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if(SwitchNum<default.RankingColors.Length)
		default.DrawColor = default.RankingColors[SwitchNum];
	else
		default.DrawColor = default.RankingColors[default.RankingColors.Length-1];

	Super.ClientReceive(P, SwitchNum, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

defaultproperties
{
     RankingMessages(0)="1ST PLACE "
     RankingMessages(1)="2ND PLACE "
     RankingMessages(2)="3RD PLACE "
     RankingMessages(3)="4TH PLACE "
     RankingMessages(4)="5TH PLACE "
     RankingMessages(5)="6TH PLACE "
     RankingMessages(6)="7TH PLACE "
     RankingMessages(7)="8TH PLACE "
     RankingMessages(8)="9TH PLACE "
     RankingMessages(9)="10TH PLACE "
     RankingColors(0)=(G=205,R=255,A=255)
     RankingColors(1)=(B=255,G=239,R=211,A=255)
     RankingColors(2)=(B=41,G=147,R=255,A=255)
     RankingColors(3)=(B=255,G=255,R=255,A=255)
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=6
     StackMode=SM_Down
     PosY=0.250000
     FontSize=1
}
