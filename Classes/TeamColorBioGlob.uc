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

    if(Level.NetMode != NM_Client)
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
    if(class'Misc_Player'.default.bTeamColorBio && !bColorSet && Level.NetMode == NM_Client)
    {
        if(TeamNum == 0)
        {

            LightBrightness=210;
            LightRadius=0.8;
            LightHue=8;

            Alpha.Color.R = 255;
            Alpha.Color.G = 64;
            Alpha.Color.B = 64;
            bColorSet=true;
        }
        else if(TeamNum == 1)
        {
            LightBrightness=210;
            LightRadius=0.8;
            LightHue=170;

            Alpha.Color.R = 64;
            Alpha.Color.G = 64;
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
    TeamNum=255
    bColorSet=false
    TeamColorMaterial=FinalBlend'3SPNvSoL.GoopFB'
}