class TeamColorChildLightningBolt extends ChildLightningBolt;

var int TeamNum;
var ColorModifier Alpha;
var bool bColorSet, bAlphaSet;

replication
{
    unreliable if(Role == ROLE_Authority)
        TeamNum;
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode != NM_Client)
        return;

    if(class'Misc_Player'.default.bTeamColorSniper)
    {
        Alpha = ColorModifier(Level.ObjectPool.AllocateObject(class'ColorModifier'));
        Alpha.Material = Skins[0];
        Alpha.AlphaBlend = true;
        Alpha.RenderTwoSided = true;
        Alpha.Color.A = 255;
        Skins[0] = Alpha;
        bAlphaSet=true;
    }

    SetColors();
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
simulated function SetColors()
{
    if(class'Misc_Player'.default.bTeamColorSniper && !bColorSet && Level.NetMode == NM_Client && Alpha != None && TeamNum!=255)
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
        mStartParticles=10;
        mRegen=false;
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
    mStartParticles=10
}