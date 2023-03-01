//================================================================================
// SpecialKillMessage.
//================================================================================

class IDBFSpecialKillMessage extends LocalMessage;

var(Messages) localized string DecapitationString;
var Sound HeadShotSound;

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	return Default.DecapitationString;
}

static simulated function ClientReceive (PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	Super.ClientReceive(P,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
	P.PlayRewardAnnouncement('Headshot',1);
}

defaultproperties
{
     DecapitationString="! H E A D  S H O T !"
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(G=0,R=0)
     PosY=0.120000
}
