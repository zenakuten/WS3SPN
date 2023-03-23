class TeamColorShockCombo extends ShockCombo;

var int TeamNum;
var bool bSpawned;

replication
{
    unreliable if(Role == ROLE_Authority)
        TeamNum;
}

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
}

simulated function SpawnEffects()
{
    local actor effects;

    if (Level.NetMode != NM_DedicatedServer)
    {
        if(TeamNum == 255)
            return;

        if(bSpawned)
            return;

        effects = Spawn(class'TeamColorShockComboExpRing');
        if(effects != None && TeamColorShockComboExpRing(effects) != None)
            TeamColorShockComboExpRing(effects).TeamNum = TeamNum;
            
        Flare = Spawn(class'TeamColorShockComboFlare');
        if(Flare != None && TeamColorShockComboFlare(Flare) != None)
            TeamColorShockComboFlare(Flare).TeamNum = TeamNum;

        effects = Spawn(class'TeamColorShockComboCore');
        if(effects != None && TeamColorShockComboCore(effects) != None)
            TeamColorShockComboCore(effects).TeamNum = TeamNum;

        effects = Spawn(class'TeamColorShockComboSphereDark');
        if(effects != None && TeamColorShockComboSphereDark(effects) != None)
            TeamColorShockComboSphereDark(effects).TeamNum = TeamNum;

        effects = Spawn(class'TeamColorShockComboVortex');
        if(effects != None && TeamColorShockComboVortex(effects) != None)
            TeamColorShockComboVortex(effects).TeamNum = TeamNum;

        effects = Spawn(class'TeamColorShockComboWiggles');
        if(effects != None && TeamColorShockComboWiggles(effects) != None)
            TeamColorShockComboWiggles(effects).TeamNum = TeamNum;

        effects = Spawn(class'TeamColorShockComboFlash');
        if(effects != None && TeamColorShockComboFlash(effects) != None)
            TeamColorShockComboFlash(effects).TeamNum = TeamNum;

        bSpawned=true;
    }
}

simulated function Tick(float DT)
{
    super.Tick(DT);
    SpawnEffects();
}


auto simulated state Combo
{
    simulated function Tick(float DT)
    {
        super.Tick(DT);
        SpawnEffects();
    }
Begin:
    Sleep(0.9);
    //Spawn(class'ShockAltExplosion');
    if ( Flare != None )
    {
		Flare.mStartParticles = 2;
		Flare.mRegenRange[0] = 0.0;
		Flare.mRegenRange[1] = 0.0;
		Flare.mLifeRange[0] = 0.3;
		Flare.mLifeRange[1] = 0.3;
		Flare.mSizeRange[0] = 150;
		Flare.mSizeRange[1] = 150;
		Flare.mGrowthRate = -500;
		Flare.mAttenKa = 0.9;
	}
    LightType = LT_None;
} 

defaultproperties
{
    TeamNum=255
}