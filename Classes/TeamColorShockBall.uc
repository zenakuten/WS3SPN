class TeamColorShockBall extends ShockBall;

var Texture RedTexture1, RedTexture2, RedTexture3;
var Texture BlueTexture1, BlueTexture2, BlueTexture3;

var int TeamNum;
var Color RedColor[3];
var Color BlueColor[3];

// get replicated team number from owner projectile and set texture
function SetColors()
{
    if(class'Misc_Player'.default.bTeamColorShock && TeamNum==255)
    {
        if(TeamColorShockProjectile(Owner) != None)
            TeamNum = TeamColorShockProjectile(Owner).TeamNum;

        if(TeamNum == 0)
        {
            Emitters[0].Texture=RedTexture1;
            Emitters[1].Texture=RedTexture2;
            Emitters[2].Texture=RedTexture3;

        }
        else if(TeamNum == 1)
        {
            Emitters[0].Texture=BlueTexture1;
            Emitters[1].Texture=BlueTexture2;
            Emitters[2].Texture=BlueTexture3;
        }
    }
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode != NM_Client)
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
    RedTexture1=Texture'3SPNvSoL.shock_core_low_red'
    RedTexture2=Texture'3SPNvSoL.shock_flare_a_red'
    RedTexture3=Texture'3SPNvSoL.shock_core_red'
    BlueTexture1=Texture'3SPNvSoL.shock_core_low_blue'
    BlueTexture2=Texture'3SPNvSoL.shock_flare_a_blue'
    BlueTexture3=Texture'3SPNvSoL.shock_core_blue'

    RedColor(0)=(R=255,G=0,B=0)
    RedColor(1)=(R=255,G=0,B=0)
    RedColor(2)=(R=255,G=0,B=0)
    BlueColor(0)=(B=255,G=0,R=0)
    BlueColor(1)=(B=255,G=0,R=0)
    BlueColor(2)=(B=255,G=0,R=0)

    TeamNum=255
}