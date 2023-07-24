class TeamColorFlakShell extends FlakShell;

#exec TEXTURE IMPORT NAME=NewFlakSkinWhite FILE=textures\NewFlakSkin_white.dds MIPS=off ALPHA=1 DXT=5

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
    local Rotator R;
	local PlayerController PC;
	
	if ( !PhysicsVolume.bWaterVolume && (Level.NetMode != NM_DedicatedServer))
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 6000 )
			Trail = Spawn(class'FlakShellTrail',self);
		Glow = Spawn(class'FlakGlow', self);
	}

	Super(Projectile).PostBeginPlay();
	Velocity = Vector(Rotation) * Speed;  
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	Velocity.z += TossZ; 
	initialDir = Velocity;

    SetupTeam();

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
        if(CanUseColors())
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
    }
}

simulated function Tick(float DT)
{
    super.Tick(DT);
    SetColors();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local FlakChunk NewChunk;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
		for (i=0; i<6; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			//NewChunk = Spawn( class 'FlakChunk',, '', Start, rot);
			NewChunk = Spawn( class 'TeamColorFlakChunk',, '', Start, rot);
		}
	}
    Destroy();
}


defaultproperties
{
    TeamNum=255
    bColorSet=false
    TeamColorMaterial=Texture'NewFlakSkinWhite'
}