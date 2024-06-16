class Message_BallsDeep extends LocalMessage;




var localized string plopptex;
var localized string youblow;

static function string GetString(
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
    if(SwitchNum == 1)
	    return default.plopptex;
    
}

static simulated function ClientReceive(
	PlayerController P,
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, SwitchNum, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    
	
}

defaultproperties
{
     plopptex="B A L L S  D E E P"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=45,G=167,R=224)
     StackMode=SM_Down
     PosY=0.150000
}
