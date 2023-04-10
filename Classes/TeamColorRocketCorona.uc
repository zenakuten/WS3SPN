class TeamColorRocketCorona extends RocketCorona;

// It looks better with regular rocket coronas, so commenting most of this out


// #exec TEXTURE IMPORT NAME=RocketFlareRed FILE=TEXTURES\RocketFlareRed.dds DXT=5
// #exec TEXTURE IMPORT NAME=RocketFlareBlue FILE=TEXTURES\RocketFlareBlue.dds DXT=5
#exec TEXTURE IMPORT NAME=RocketFlareWhite FILE=TEXTURES\RocketFlareWhite.dds Alpha=1 DXT=5

var int TeamNum;
var ColorModifier Alpha;
var Material TeamColorMaterial;
var bool bColorSet, bAlphaSet;

// get replicated team number from owner projectile and set texture
function SetColors()
{
    /*
    local Color color;
    if(class'Misc_Player'.default.bTeamColorRockets && !bColorSet && Alpha != None)
    {
        if(TeamColorRocketProj(Owner) != None)
            TeamNum = TeamColorRocketProj(Owner).TeamNum;
        else if(TeamColorSeekingRocketProj(Owner) != None)
            TeamNum = TeamColorSeekingRocketProj(Owner).TeamNum;

        if(TeamNum == 0 || TeamNum == 1)
        {
            color = class'TeamColorManager'.static.GetColor(TeamNum, Level.GetLocalPlayerController());
            Alpha.Color.R = color.R;
            Alpha.Color.G = color.G;
            Alpha.Color.B = color.B;
            Alpha.Color.A = color.A;
            bColorSet=true;
        }
    }
    */
}

/*
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode == NM_DedicatedServer)
        return;

    // this works but looks like crap, commenting out for now to use regular ol' rocket flare
    if(class'Misc_Player'.default.bTeamColorRockets)
    {
        Alpha = ColorModifier(Level.ObjectPool.AllocateObject(class'ColorModifier'));
        Alpha.Material = TeamColorMaterial;
        Alpha.AlphaBlend = true;
        Alpha.RenderTwoSided = true;
        Alpha.Color.A = 255;
        //Skins[0] = Alpha;
        Texture=Alpha;
        bAlphaSet=true;
    }

    SetColors();
}
*/

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

/*
simulated function Destroyed()
{
	if ( bAlphaSet )
	{
		//Level.ObjectPool.FreeObject(Skins[0]);
		//Skins[0] = None;
		Level.ObjectPool.FreeObject(Alpha);
		Texture = None;
	}

	super.Destroyed();
}
*/

defaultproperties
{
    TeamNum=255
    Texture=Texture'RocketFlare'
    Skins(0)=Texture'RocketFlare'
    TeamColorMaterial=Texture'RocketFlareWhite'

    DrawType=DT_Sprite
    Style=ST_Normal
}
