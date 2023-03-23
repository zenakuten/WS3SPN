class TeamColorBioDecal extends xScorch;

// snarf I tried, this just does not work correctly
// Projectors and ColorModifier seem to be incompatible

// #exec TEXTURE IMPORT NAME=xbiosplat_white FILE=TEXTURES\xbiosplat_white.tga LODSET=2 MODULATED=1 UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP
// #exec TEXTURE IMPORT NAME=xbiosplat2_white FILE=TEXTURES\xbiosplat2_white.tga LODSET=2 MODULATED=1 UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP

#exec TEXTURE IMPORT NAME=xbiosplat_white FILE=TEXTURES\xbiosplat_white.tga LODSET=2 ALPHA=1 UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP
#exec TEXTURE IMPORT NAME=xbiosplat2_white FILE=TEXTURES\xbiosplat2_white.tga LODSET=2 ALPHA=1 UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP

var ColorModifier Alpha;
var bool bColorSet, bAlphaSet;
var int TeamNum;

replication
{
    unreliable if(Role == ROLE_Authority)
        TeamNum;
}

simulated function BeginPlay()
{
	if ( !Level.bDropDetail && (FRand() < 0.5) )
		ProjTexture = texture'xbiosplat2';

	Super.BeginPlay();
}

simulated function PostBeginPlay()
{
    if(Level.NetMode != NM_Client)
    {
        super.PostBeginPlay();
        return;
    }

    if(class'Misc_Player'.default.bTeamColorBio)
    {
        ProjTexture=Texture'xbiosplat_white';
        if ( !Level.bDropDetail && (FRand() < 0.5) )
            ProjTexture = texture'xbiosplat2_white';

        Alpha = ColorModifier(Level.ObjectPool.AllocateObject(class'ColorModifier'));
        Alpha.Material = ProjTexture;
        Alpha.AlphaBlend = true;
        Alpha.RenderTwoSided = true;
        Alpha.Color.A = 255;
        ProjTexture = Alpha;
        bAlphaSet=true;
    }

    SetColors();

    super.PostBeginPlay();
}

simulated function Destroyed()
{
	if ( bAlphaSet )
	{
		Level.ObjectPool.FreeObject(ProjTexture);
		ProjTexture = None;
	}

	super.Destroyed();
}

simulated function SetColors()
{
    if(class'Misc_Player'.default.bTeamColorBio && !bColorSet && Level.NetMode == NM_Client && Alpha != None)
    {
        if(TeamNum == 0)
        {
            Alpha.Color.R = 255;
            Alpha.Color.G = 32;
            Alpha.Color.B = 32;
            bColorSet=true;
        }
        else if(TeamNum == 1)
        {
            Alpha.Color.R = 32;
            Alpha.Color.G = 32;
            Alpha.Color.B = 255;
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
	LifeSpan=6
	DrawScale=+0.65
	ProjTexture=texture'xbiosplat'
	bClipStaticMesh=True
    CullDistance=+7000.0

    TeamNum=255
    bColorSet=false
    bAlphaSet=false

    Style=STY_Alpha
    bProjectOnAlpha=true

    MaterialBlendingOp=PB_None
    FrameBufferBlendingOp=PB_AlphaBlend
}
