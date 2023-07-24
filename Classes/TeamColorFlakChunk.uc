class TeamColorFlakChunk extends FlakChunk;

#exec TEXTURE IMPORT NAME=FlakChunkWhite FILE=textures\FlakChunkTex_white.dds MIPS=off ALPHA=1 DXT=5

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

simulated function bool CanUseColors()
{
    local Misc_BaseGRI GRI;

    GRI = Misc_BaseGRI(level.GRI);
    if(GRI != None)
        return GRI.bAllowColorWeapons;

    return false;
}

simulated function PostBeginPlay()
{
    local float r;

    if (Level.NetMode != NM_DedicatedServer)
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            //Trail = Spawn(class'FlakTrail',self);
            Trail = Spawn(class'TeamColorFlakTrail',self);
            Trail.Lifespan = Lifespan;
        }
    }

    Velocity = Vector(Rotation) * (Speed);
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

    r = FRand();
    if (r > 0.75)
        Bounces = 2;
    else if (r > 0.25)
        Bounces = 1;
    else
        Bounces = 0;

    SetRotation(RotRand());
    SetupTeam();

    Super(Projectile).PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode == NM_DedicatedServer)
        return;

    if(class'Misc_Player'.default.bTeamColorFlak && CanUseColors())
    {
        Alpha = ColorModifier(Level.ObjectPool.AllocateObject(class'ColorModifier'));
        Alpha.Material = TeamColorMaterial;
        Alpha.AlphaBlend = true;
        Alpha.RenderTwoSided = true;
        Alpha.Color.A = 255;
        Skins[0] = Alpha;
        bAlphaSet=true;
    }

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
    local Color color;
    if(class'Misc_Player'.default.bTeamColorFlak && !bColorSet && Level.NetMode != NM_DedicatedServer && Alpha != None)
    {
        if(Trail != None && TeamColorFlakTrail(Trail) != None)
            TeamColorFlakTrail(Trail).TeamNum=TeamNum;

        if(CanUseColors())
        {
            if(TeamNum == 0 || TeamNum == 1)
            {
                color = class'TeamColorManager'.static.GetColor(TeamNum, Level.GetLocalPlayerController());
                LightHue = class'TeamColorManager'.static.GetHue(color);
                LightBrightness=210;

                Alpha.Color.R = color.R;
                Alpha.Color.G = color.G;
                Alpha.Color.B = color.B;
                bColorSet=true;
            }
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
    TeamColorMaterial=Texture'FlakChunkWhite'
}