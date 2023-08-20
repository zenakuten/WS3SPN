class TAM_GRI extends Misc_BaseGRI;

var bool bChallengeMode;
var bool bDisableTeamCombos;
var int  PickupMode;

replication
{
    reliable if(bNetInitial && Role == ROLE_Authority)
        bDisableTeamCombos, bChallengeMode, PickupMode;
}

defaultproperties
{
}
