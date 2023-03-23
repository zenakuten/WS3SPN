class TeamColorShockComboSphereDark extends ShockComboSphereDark;

var int TeamNum;
var bool bColorSet;

var Shader RedTexture, BlueTexture, WhiteTexture;

function SetColors()
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
            Skins[1]=RedTexture;
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
    RedTexture=Shader'3SPNvSoL.ShockDark_red'
    BlueTexture=Shader'3SPNvSoL.ShockDark_blue'
    WhiteTexture=Shader'3SPNvSoL.ShockDark_white'

    TeamNum=255
    bColorSet=false
}