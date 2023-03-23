class TeamColorShockProjectile extends ShockProjectile;

#exec TEXTURE IMPORT NAME=shock_core_low_white FILE=textures\shock_core_low_white.dds MIPS=off ALPHA=1 DXT=5
#exec TEXTURE IMPORT NAME=shock_core_low_red FILE=textures\shock_core_low_red.dds MIPS=off DXT=1
#exec TEXTURE IMPORT NAME=shock_core_low_blue FILE=textures\shock_core_low_blue.dds MIPS=off DXT=1

var int TeamNum;
var Material TeamColorMaterial;
var ColorModifier Alpha;
var bool bColorSet, bAlphaSet;

replication
{
    unreliable if(Role == Role_Authority)
       TeamNum;
}

function SetupTeam()
{
    if(Instigator != None && Instigator.Controller != None)
    {
        TeamNum=Instigator.Controller.GetTeamNum();
    }
}

simulated function PostBeginPlay()
{
    super(Projectile).PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
	{
        //ShockBallEffect = Spawn(class'ShockBall', self);
        ShockBallEffect = Spawn(class'TeamColorShockBall', self);
        ShockBallEffect.SetBase(self);
	}

	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    SetTimer(0.4, false);
    tempStartLoc = Location;

    SetupTeam();
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode != NM_Client)
        return;

/*
    if(class'Misc_Player'.default.bTeamColorShock)
    {
        Alpha = ColorModifier(Level.ObjectPool.AllocateObject(class'ColorModifier'));
        Alpha.Material = TeamColorMaterial;
        Alpha.AlphaBlend = true;
        Alpha.RenderTwoSided = true;
        Alpha.Color.A = 255;
        Skins[0] = Alpha;
        Texture=Alpha;
        bAlphaSet=true;
    }
    */

    SetupTeam();
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
    if(class'Misc_Player'.default.bTeamColorShock && !bColorSet && Level.NetMode == NM_Client)
    {
        if(TeamNum == 0)
        {
            LightHue=0;
            /*
            Alpha.Color.R = 255;
            Alpha.Color.G = 32;
            Alpha.Color.B = 32;
            */
            Texture=Texture'shock_core_low_red';
            //Texture=Texture'XEffectMat.Shock.shock_core_low';

            bColorSet=true;
        }
        else if(TeamNum == 1)
        {
            LightHue=160;
            /*
            Alpha.Color.R = 32;
            Alpha.Color.G = 32;
            Alpha.Color.B = 255;
            */
            Texture=Texture'shock_core_low_blue';
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
    bColorSet=false
    TeamColorMaterial=Texture'shock_core_low_white'
}