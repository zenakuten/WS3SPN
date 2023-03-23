class TeamColorShockComboVortex extends ShockComboVortex;

var int TeamNum;
var bool bColorSet;

var FinalBlend RedTexture, BlueTexture, WhiteTexture;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
}

simulated function SetColors()
{
    if(TeamNum == 255)
        return;

    if(bColorSet)
        return;

    if(class'Misc_Player'.default.bTeamColorShock && !bColorSet && Level.NetMode == NM_Client)
    {
        if(TeamNum == 0)
        {
            Skins[0]=RedTexture;
        }
        else if(TeamNum == 1)
        {
            Skins[0]=BlueTexture;
        }
    }

    bColorSet=true;
}

simulated function Tick(float DT)
{
    super.Tick(DT);
    SetColors();
}

defaultproperties
{
    RedTexture=FinalBlend'3SPNvSoL.ElecRingFB_red'
    BlueTexture=FinalBlend'3SPNvSoL.ElecRingFB_blue'
    WhiteTexture=FinalBlend'3SPNvSoL.ElecRingFB_white'

    TeamNum=255
    bColorSet=false
}