class TeamColorShockComboSphereDark extends ShockComboSphereDark;

var int TeamNum;
var bool bColorSet;

var Material TeamColorMaterial;
var ColorModifier Alpha;
var bool bAlphaSet;

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode == NM_DedicatedServer)
        return;

    if(class'Misc_Player'.default.bTeamColorShock)
    {
        Alpha = ColorModifier(Level.ObjectPool.AllocateObject(class'ColorModifier'));
        Alpha.Material = TeamColorMaterial;
        Alpha.AlphaBlend = true;
        Alpha.RenderTwoSided = true;
        Alpha.Color.A = 255;
        Skins[0] = Alpha;
        bAlphaSet=true;
    }
}
function SetColors()
{
    local Color color;

    if(TeamNum == 255)
        return;

    if(bColorSet)
        return;

    if(class'Misc_Player'.default.bTeamColorShock && !bColorSet && Level.NetMode != NM_DedicatedServer)
    {
        if(TeamNum == 0 || TeamNum == 1)
        {
            LightBrightness=210;
            color = class'TeamColorManager'.static.GetColor(TeamNum, Level.GetLocalPlayerController());
            LightHue = class'TeamColorManager'.static.GetHue(color);

            Alpha.Color.R = color.R;
            Alpha.Color.G = color.G;
            Alpha.Color.B = color.B;
            bColorSet=true;
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
    TeamColorMaterial=Shader'3SPNvSoL.ShockDark_white'

    TeamNum=255
    bColorSet=false
}