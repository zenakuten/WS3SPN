class Emitter_Damage extends xEmitter;

var int Damage;
var color FontColor;
var ScriptedTexture STexture;
var TexRotator TexRot;

var Material StextureFallBack;
var Font DrawFont;

static function ShowDamage( Actor Dest, Vector ShowLocation, int sDamage )
{
    local Emitter_Damage P;

    if ( (sDamage == 0) || Dest == none ) return;

    P = Dest.spawn( class'Emitter_Damage',,, ShowLocation, rot(16384, 0, 0) );
    P.Damage = sDamage;

    if ( Dest.Level.NetMode != NM_DedicatedServer)
        P.PostNetBeginPlay();
}

event Destroyed()
{
	if ( stexture != none )
	{
		stexture.Client=none;
		Level.ObjectPool.FreeObject(STexture);
	}

	if ( TexRot != none ) Level.ObjectPool.FreeObject(TexRot);

	super.Destroyed();
}

static function Color ColorRamp(int Damage)
{
    local Color C;
    
    if(Damage < 0)
    {
        C.R = 200;
        C.G = 200;
        C.B = 220;
    }
    else if(Damage < 40)
    {
        C.R = Damage * 6;
        C.G = 0;
        C.B = 255;
    }
    else if(Damage < 80)
    {
        C.G = (Damage - 40) * 6;
        C.R = 255 - C.G;
        C.B = 255 - C.G;
    }
    else if(Damage < 120)
    {
        C.R = (Damage - 80) * 6;
        C.G = 255;
        C.B = 0;
    }
    else if(Damage < 160)
    {
        C.R = 255;
        C.G = 255 - (Damage - 120) * 6;
        C.B = 0;
    }
    else
    {
        C.R = 255;
        C.G = 0;
        C.B = 0;
    }
    C.A = 255;
    
    return C;
}

simulated function PostNetBeginPlay()
{
    local rotator R;
	
    if ( Level.NetMode == NM_DedicatedServer )
	{
		LifeSpan = 0.2f;
		return;
	}
	
	FontColor = ColorRamp(Damage);

	STexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
	TexRot = TexRotator(Level.ObjectPool.AllocateObject(class'TexRotator'));
	STexture.SetSize(64,64);
	STexture.Client = self;
	STexture.Revision++;

	TexRot.Material = stexture;
	TexRot.Rotation.Yaw = 8191;
	TexRot.UOffset = 32;
	TexRot.VOffset = 32;
	DrawFont = Font( DynamicLoadObject( "UT2003Fonts.FontEurostile14", class'Font') );
	if ( DrawFont == None ) DrawFont=Default.DrawFont;
	Texture = TexRot;
	Skins[0] = TexRot;
	R.Yaw = Rand(65536);
	R.Pitch = 12384+Rand(7000);
	setRotation(R);
	mStartParticles = 1;
}

simulated event RenderTexture( ScriptedTexture Tex )
{
    local int SizeX, SizeY;
    local string Text;
    local color BackColor;

    BackColor.R = 0;
    BackColor.G = 0;
    BackColor.B = 0;
    BackColor.A = 0;
	Text = string(damage);
	Tex.TextSize(Text, DrawFont, SizeX, SizeY);
	Tex.DrawTile( 0, 0, Tex.USize, Tex.VSize, 0, 0, Tex.USize, Tex.VSize, 
                  STextureFallback, BackColor);
	Tex.DrawText( (Tex.USize - SizeX) * 0.5, 8, Text, DrawFont, FontColor );
}

defaultproperties
{
     Damage=9998
     FontColor=(A=255)
     DrawFont=Font'Engine.DefaultFont'
     mStartParticles=0
     mMaxParticles=1
     mSpeedRange(0)=350.000000
     mSpeedRange(1)=350.000000
     mMassRange(0)=2.000000
     mMassRange(1)=2.000000
     mAirResistance=1.000000
     mSizeRange(0)=40.000000
     mSizeRange(1)=40.000000
     mAttenuate=False
     DrawType=DT_Sprite
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.000000
     Rotation=(Pitch=16383)
     Texture=None
     Skins(0)=None
     Style=STY_Alpha
}
