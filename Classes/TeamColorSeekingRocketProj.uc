class TeamColorSeekingRocketProj extends SeekingRocketProj;

var int TeamNum;

var Emitter RocketTrail;

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

//override PostBeginPlay so we can spawn team color effects
simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'RocketTrailSmoke',self);
		Corona = Spawn(class'TeamColorRocketCorona',self);
		RocketTrail = Spawn(class'TeamColorRocketTrail',self);
        if(RocketTrail != None)
            RocketTrail.SetBase(self);
	}

	Dir = vector(Rotation);
	Velocity = speed * Dir;
	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity=0.6*Velocity;
	}

    SetupTeam();

	Super(Projectile).PostBeginPlay();
    Super.SetTimer(0.1, true);
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode != NM_Client)
        return;

    SetupTeam();
}

simulated function Destroyed()
{
    if(RocketTrail != None)
        RocketTrail.Destroy();

    super.Destroyed();
}
defaultproperties
{
    TeamNum=255
}