
class TeamColorRocketCorona extends RocketCorona;

#exec TEXTURE IMPORT NAME=RocketFlareRed FILE=TEXTURES\RocketFlareRed.dds DXT=5
#exec TEXTURE IMPORT NAME=RocketFlareBlue FILE=TEXTURES\RocketFlareBlue.dds DXT=5

var int TeamNum;

// get replicated team number from owner projectile and set texture
function SetColors()
{
    if(class'Misc_Player'.default.bTeamColorRockets && TeamNum==255)
    {
        if(TeamColorRocketProj(Owner) != None)
            TeamNum = TeamColorRocketProj(Owner).TeamNum;
        else if(TeamColorSeekingRocketProj(Owner) != None)
            TeamNum = TeamColorSeekingRocketProj(Owner).TeamNum;

        if(TeamNum == 0)
        {
            Texture=Texture'RocketFlareRed';
            Skins[0]=Texture'RocketFlareRed';
        }
        else if(TeamNum == 1)
        {
            Texture=Texture'RocketFlareBlue';
            Skins[0]=Texture'RocketFlareBlue';
        }
    }
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode != NM_Client)
        return;
        
    SetColors();
}

simulated function Tick(float DT)
{
    super.Tick(DT);
    SetColors();
}

auto state Start
{
    simulated function Tick(float DT)
    {
        super.Tick(DT);
        SetColors();
    }
}

state End
{
    simulated function Tick(float DT)
    {
        super.Tick(DT);
        SetColors();
    }
}


defaultproperties
{
    TeamNum=255
    Texture=Texture'RocketFlare'
    Skins(0)=Texture'RocketFlare'
}