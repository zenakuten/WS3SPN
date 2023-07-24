class TeamColorGoopSmoke extends xEmitter;

var int TeamNum;
var bool bColorSet;

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode == NM_DedicatedServer)
        return;

    SetColors();
}

simulated function bool CanUseColors()
{
    local Misc_BaseGRI GRI;

    GRI = Misc_BaseGRI(level.GRI);
    if(GRI != None)
        return GRI.bAllowColorWeapons;

    return false;
}


simulated function SetColors()
{
    local Color color;
    if(Level.NetMode == NM_DedicatedServer)
        return;

    if(bColorSet)
        return;

    if(TeamNum == 255)
        return;

    if(class'Misc_Player'.default.bTeamColorBio)
    {
        if(CanUseColors())
        {
            color = class'TeamColorManager'.static.GetColor(TeamNum, Level.GetLocalPlayerController());

            if(TeamNum == 0 || TeamNum == 1)
            {
                mColorRange[0].R=color.R;
                mColorRange[0].G=color.G;
                mColorRange[0].B=color.B;
                mColorRange[1].R=color.R;
                mColorRange[1].G=color.G;
                mColorRange[1].B=color.B;
            }
        }
    }

    mStartParticles=10;
    mRegen=false;
    bColorSet=true;
}

simulated function Tick(float DT)
{
    super.Tick(DT);
    SetColors();
}

defaultproperties
{
	bHighDetail=true
    Skins(0)=Texture'EmitSmoke_t'
    mNumTileColumns=4
    mNumTileRows=4
    Style=STY_Translucent
    mParticleType=PCL_Burst
    mDirDev=(X=0.25,Y=0.25,Z=0.25)
    mPosDev=(X=8.0,Y=8.0,Z=8.0)
    mDelayRange(0)=0.0
    mDelayRange(1)=0.15
    mLifeRange(0)=1.0
    mLifeRange(1)=2.0
    mSpeedRange(0)=20.0
    mSpeedRange(1)=80.0
    mSizeRange(0)=20.0
    mSizeRange(1)=30.0
    mGrowthRate=10.0
    //snarf mRegen has to be true to change color dynamically :(
    //mRegen=false
    mRegen=true
    mRandOrient=true
    mRandTextures=true
    mAttenuate=true
    mAttenKa=0.1
    //mStartParticles=10
    mStartParticles=0
    mMaxParticles=10
    mAirResistance=1.1
    mColorRange(0)=(R=20,G=120,B=20,A=255)
    mColorRange(1)=(R=20,G=150,B=20,A=255)
    mSpinRange(0)=-100.0
    mSpinRange(1)=100.0
    RemoteRole=ROLE_None

    TeamNum=255
}
