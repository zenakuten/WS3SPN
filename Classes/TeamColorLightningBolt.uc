class TeamColorLightningBolt extends NewLightningBolt;

var int TeamNum;
var ColorModifier Alpha;
var bool bColorSet, bAlphaSet;

replication
{
    unreliable if(Role == ROLE_Authority)
        TeamNum;
}

simulated function bool CanUseColors()
{
    local Misc_BaseGRI GRI;

    GRI = Misc_BaseGRI(level.GRI);
    if(GRI != None)
        return GRI.bAllowColorWeapons;

    return false;
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode != NM_Client)
        return;

    if(class'Misc_Player'.default.bTeamColorSniper)
    {
        if(CanUseColors())
        {
            Alpha = ColorModifier(Level.ObjectPool.AllocateObject(class'ColorModifier'));
            Alpha.Material = Skins[0];
            Alpha.AlphaBlend = true;
            Alpha.RenderTwoSided = true;
            Alpha.Color.A = 255;
            Skins[0] = Alpha;
            bAlphaSet=true;
        }
    }
}

simulated function Destroyed()
{
	if ( bAlphaSet )
	{
		Level.ObjectPool.FreeObject(Skins[0]);
		Skins[0] = None;
	}

    super.Destroyed();
}

// get replicated team number from owner projectile and set texture
function SetColors()
{
    if(class'Misc_Player'.default.bTeamColorSniper && !bColorSet && Level.NetMode == NM_Client && Alpha != None && TeamNum!=255)
    {
        if(CanUseColors())
        {
            if(TeamNum == 0)
            {
                LightHue=0;
                Alpha.Color.R = 255;
                Alpha.Color.G = 32;
                Alpha.Color.B = 32;
            }
            else if(TeamNum == 1)
            {
                LightHue=160;
                Alpha.Color.R = 32;
                Alpha.Color.G = 32;
                Alpha.Color.B = 255;
            }
            bColorSet=true;
            mRegen=false;
            mStartParticles=30;
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
    bColorSet=false

    //hacks
    mRegen=true
    mStartParticles=30
}