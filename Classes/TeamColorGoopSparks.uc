class TeamColorGoopSparks extends xEmitter;

#exec OBJ LOAD FILE=XEffectMat.utx

var int TeamNum;
var bool bColorSet;
var Texture WhiteSparks;

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
                Skins[0] = WhiteSparks;
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
    WhiteSparks=Texture'3SPNvSoL.link_spark_white'

    Style=STY_Additive
    Skins(0)=Texture'XEffectMat.Link.link_spark_green'
    mParticleType=PT_Line
    mDirDev=(X=0.8,Y=0.8,Z=0.8)
    mPosDev=(X=0.0,Y=0.0,Z=0.0)
    mLifeRange(0)=0.5
    mLifeRange(1)=0.8
    mSpeedRange(0)=80.0
    mSpeedRange(1)=240.0
    mSizeRange(0)=4.0
    mSizeRange(1)=4.0
    mMassRange(0)=1.5
    mMassRange(1)=2.0
    mRegenRange(0)=0.0
    mRegenRange(1)=0.0
    //mStartParticles=10
    //mRegen=false
    mStartParticles=0
    mRegen=true
    mMaxParticles=10
    ScaleGlow=2.0
    mGrowthRate=-2.0
    mAttenuate=true
    mAttenKa=0.0
    mAirResistance=2.0      
    mColorRange(0)=(R=160,B=180,G=160)
    mColorRange(1)=(R=160,B=180,G=160)
    mSpawnVecB=(X=8.0,Y=0.0,Z=0.04)
    RemoteRole=ROLE_None
}
