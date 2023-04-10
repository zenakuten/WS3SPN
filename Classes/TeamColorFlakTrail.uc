class TeamColorFlakTrail extends FlakTrail;

var int TeamNum;
var bool bColorSet;

function SetColors()
{
    local Color color;
    if(bColorSet)
        return;

    if(class'Misc_Player'.default.bTeamColorFlak && Level.NetMode != NM_DedicatedServer)
    {
        if(TeamNum == 0 || TeamNum == 1)
        {
            color = class'TeamColorManager'.static.GetColor(TeamNum, Level.GetLocalPlayerController());
            LightHue = class'TeamColorManager'.static.GetHue(color);

            mColorRange[0].R=color.R;
            mColorRange[0].G=color.G;
            mColorRange[0].B=color.B;

            mColorRange[1].R=color.R;
            mColorRange[1].G=color.G;
            mColorRange[1].B=color.B;
            bColorSet=true;
        }
    }
}

simulated function Tick(float DT)
{
    super.Tick(DT);
    SetColors();
}

defaultproperties
{
    TeamNum=255
}