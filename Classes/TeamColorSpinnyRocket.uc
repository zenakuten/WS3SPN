class TeamColorSpinnyRocket extends Actor;

var() int SpinRate;

var int TeamNum;
var bool bColorSet;

var TeamColorRocketCorona Corona;
var TeamColorRocketTrail RocketTrail;
var vector Dir;

function PostBeginPlay()
{
    Corona = Spawn(class'TeamColorRocketCorona',self);
    if(Corona != None)
        Corona.bHidden=true;

    RocketTrail = Spawn(class'TeamColorRocketTrail',self);
    if(RocketTrail != None)
    {
        RocketTrail.bHidden=true;
        SetTimer(6.0,true);
    }

    if(RocketTrail != None)
        RocketTrail.SetBase(self);

    Dir = vector(Rotation);
	Velocity = 1200 * Dir;

	Super.PostBeginPlay();
}

function Timer()
{
    RocketTrail.Reset();
}

function SetTeam(int team)
{
    TeamNum=team;
    Corona.TeamNum=team;
    RocketTrail.TeamNum=team;
}

function Tick(float Delta)
{
	local rotator NewRot;

	NewRot = Rotation;
	NewRot.Yaw += Delta * SpinRate/Level.TimeDilation;
	SetRotation(NewRot);
    Dir = vector(Rotation);
	Velocity = 1200 * Dir;
    TrailEmitter(RocketTrail.Emitters[0]).ResetTrail();
}

simulated function Destroyed()
{
    if(RocketTrail != None)
    {
        RocketTrail.bHidden=true;
        RocketTrail.Destroy();
    }
	if ( Corona != None )
    {
        Corona.bHidden=true;
		Corona.Destroy();        
    }

    super.Destroyed();
}

defaultproperties
{
    RemoteRole=ROLE_None
	bUnlit=true
	SpinRate=20000
	bAlwaysTick=true
	LODBias=100000
	DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponStaticMesh.RocketProj'

    bHidden=true
}