class TeamColorShockComboFlare extends ShockComboFlare;

var int TeamNum;
var bool bColorSet;

var Texture RedTexture, BlueTexture;

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
            Skins[0] = RedTexture;
        }
        else if(TeamNum == 1)
        {
            Skins[0] = BlueTexture;
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
    RedTexture=Texture'3SPNvSoL.Shock_flare_a_red'
    BlueTexture=Texture'3SPNvSoL.Shock_flare_a_blue'
    TeamNum=255
    bColorSet=false
}