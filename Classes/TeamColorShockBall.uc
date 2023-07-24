class TeamColorShockBall extends ShockBall;

var int TeamNum;

var bool bColorSet, bAlphaSet;

simulated function bool CanUseColors()
{
    local Misc_BaseGRI GRI;

    GRI = Misc_BaseGRI(level.GRI);
    if(GRI != None)
        return GRI.bAllowColorWeapons;

    return false;
}

// get replicated team number from owner projectile and set texture
function SetColors()
{
    local Color color, altColor;
    if(class'Misc_Player'.default.bTeamColorShock)
    {
        if(CanUseColors())
        {
            if(TeamColorShockProjectile(Owner) != None)
                TeamNum = TeamColorShockProjectile(Owner).TeamNum;

            if(TeamNum == 0 || TeamNum == 1 && !bColorSet)
            {
                LightBrightness=210;
                color = class'TeamColorManager'.static.GetColor(TeamNum, Level.GetLocalPlayerController());
                LightHue = class'TeamColorManager'.static.GetHue(color);

                color.A=255;
                altColor.R = Min(color.R+64,255);
                altColor.G = Min(color.G+64,255);
                altColor.B = Min(color.B+64,255);
                altColor.A = 255;

                Emitters[0].UseColorScale=true;
                Emitters[0].ColorScale[0].Color = color;
                Emitters[0].ColorScale[1].Color = color;

                Emitters[1].UseColorScale=true;
                Emitters[1].ColorScale[0].Color = color;
                Emitters[1].ColorScale[1].Color = altColor;

                Emitters[2].UseColorScale=true;
                Emitters[2].ColorScale[0].Color = color;
                Emitters[2].ColorScale[1].Color = altColor;

                Emitters[3].UseColorScale=true;
                Emitters[3].ColorScale[0].Color = color;
                Emitters[3].ColorScale[1].Color = altColor;

                Emitters[0].Disabled=false;            
                Emitters[1].Disabled=false;            
                Emitters[2].Disabled=false;            
                Emitters[3].Disabled=false;

                bColorSet=true;
            }

            Emitters[1].ParticlesPerSecond=2;
            Emitters[1].InitialParticlesPerSecond=2;
            Emitters[1].AllParticlesDead=false;

            Emitters[3].ParticlesPerSecond=100;
            Emitters[3].InitialParticlesPerSecond=100;
            Emitters[3].AllParticlesDead=false;
        }
    }
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode == NM_DedicatedServer)
        return;
        
    SetColors();
}

simulated function Tick(float DT)
{
    super.Tick(DT);
    SetColors();
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=False
        ColorScale(0)=(Color=(B=130,G=20,R=91,A=255))
        ColorScale(1)=(RelativeTime=0.400000,Color=(B=145,G=80,R=110))
        ColorScale(2)=(RelativeTime=1.000000)

        FadeOut=True
        FadeIn=True
        ResetAfterChange=True
        AutoReset=True
        SpinParticles=True
        UniformSize=True
        FadeOutStartTime=0.320000
        FadeInEndTime=0.050000
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        StartSpinRange=(X=(Min=0.132000,Max=0.900000))
        StartSizeRange=(X=(Min=45.000000,Max=45.000000),Y=(Min=65.000000,Max=65.000000),Z=(Min=65.000000,Max=65.000000))
        Texture=XEffectMat.Shock.shock_core_low
        LifetimeRange=(Min=0.350000,Max=0.350000)
        WarmupTicksPerSecond=20.000000
        RelativeWarmupTime=1.000000
        Name="SpriteEmitter0"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1

        UseColorScale=False
        ColorScale(0)=(Color=(B=130,G=20,R=91,A=255))
        ColorScale(1)=(RelativeTime=0.400000,Color=(B=145,G=80,R=110))
        ColorScale(2)=(RelativeTime=1.000000)

        FadeOut=True
        FadeIn=True
        ResetAfterChange=True
        AutoReset=True
        SpinParticles=True
        UniformSize=True
        FadeOutStartTime=0.200000
        FadeInEndTime=0.250000
        CoordinateSystem=PTCS_Relative
        MaxParticles=2
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.300000))
        StartSpinRange=(X=(Min=0.154000,Max=0.913000))
        StartSizeRange=(X=(Min=60.000000,Max=60.000000))
        InitialParticlesPerSecond=2.000000
        Texture=XEffectMat.Shock.shock_flare_a
        LifetimeRange=(Min=0.400000,Max=0.400000)
        WarmupTicksPerSecond=20.000000
        RelativeWarmupTime=1.000000
        Name="SpriteEmitter1"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2

        UseColorScale=False
        ColorScale(0)=(Color=(B=130,G=20,R=91,A=255))
        ColorScale(1)=(RelativeTime=0.400000,Color=(B=145,G=80,R=110))
        ColorScale(2)=(RelativeTime=1.000000)

        FadeOut=True
        FadeIn=True
        ResetAfterChange=True
        DetailMode=DM_High
        AutoReset=True
        UniformSize=True
        FadeOutStartTime=0.300000
        FadeInEndTime=0.100000
        CoordinateSystem=PTCS_Relative
        MaxParticles=15
        StartSizeRange=(X=(Min=4.500000,Max=4.500000))
        Texture=XEffectMat.Shock.shock_core
        LifetimeRange=(Min=0.350000,Max=0.350000)
        StartVelocityRange=(X=(Min=-70.000000,Max=70.000000),Y=(Min=-70.000000,Max=70.000000),Z=(Min=-70.000000,Max=70.000000))
        VelocityScale(0)=(RelativeTime=1.000000,RelativeVelocity=(X=-1.000000,Y=-1.000000,Z=-1.000000))
        WarmupTicksPerSecond=50.000000
        RelativeWarmupTime=1.000000
        Name="SpriteEmitter2"
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    ///////////////////////////////////////////////////////
    // this emitter replaces the projectile texture when using team colors
    // there wasn't a good way to color the texture without using the emitter system
	Begin Object Class=SpriteEmitter Name=ShockCoreLowWhite

        UseColorScale=True
        ColorScale(0)=(Color=(B=130,G=20,R=91,A=255))
        ColorScale(1)=(RelativeTime=0.400000,Color=(B=145,G=80,R=110))
        ColorScale(2)=(RelativeTime=1.000000)
        FadeOutStartTime=20.800000

        MaxParticles=1
        StartLocationRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        StartSizeRange=(X=(Min=40.000000,Max=40.000000),Y=(Min=40.000000,Max=40.000000))
        UniformSize=True
        SkeletalScale=(X=0.400000,Y=0.400000,Z=0.370000)
        InitialParticlesPerSecond=50.000000
        ParticlesPerSecond=50.000000
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        //Texture=Texture'3SPNvSoL.shock_core_low_white'
        Texture=Texture'XEffectMat.Shock.shock_core_low'
        LifetimeRange=(Min=0.250000,Max=0.500000)
		SecondsBeforeInactive=0
        UseSkeletalLocationAs=PTSU_Location
        CoordinateSystem=PTCS_Relative
        DrawStyle=PTDS_Translucent
        Disabled=true
        Name="SpriteEmitter3"

    End Object
    Emitters(3)=SpriteEmitter'ShockCoreLowWhite'

    TeamNum=255
}