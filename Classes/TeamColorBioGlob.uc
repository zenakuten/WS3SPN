class TeamColorBioGlob extends BioGlob;

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
    SetupTeam();
    super.PostBeginPlay();

}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode == NM_DedicatedServer)
        return;

    if(class'Misc_Player'.default.bTeamColorBio)
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
    local xEmitter emitter;
	if ( bAlphaSet )
	{
		Level.ObjectPool.FreeObject(Skins[0]);
		Skins[0] = None;
	}

    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        emitter = Spawn(class'TeamColorGoopSmoke');
        if(emitter != None)
            TeamColorGoopSmoke(emitter).TeamNum=TeamNum;
        emitter = Spawn(class'TeamColorGoopSparks');
        if(emitter != None)
            TeamColorGoopSparks(emitter).TeamNum=TeamNum;
    }
	if ( Fear != None )
		Fear.Destroy();
    if (Trail != None)
        Trail.Destroy();

	super(Projectile).Destroyed();
}

// get replicated team number from owner projectile and set texture
simulated function SetColors()
{
    local Color color;
    if(class'Misc_Player'.default.bTeamColorBio && !bColorSet && Level.NetMode != NM_DedicatedServer)
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

simulated function Tick(float DT)
{
    super.Tick(DT);
    SetColors();
}

defaultproperties
{
    TeamNum=255
    bColorSet=false
    TeamColorMaterial=FinalBlend'3SPNvSoL.GoopFB'
}