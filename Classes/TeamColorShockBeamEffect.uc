class TeamColorShockBeamEffect extends ShockBeamEffect;

var int TeamNum;
var bool bColorSet, bAlphaSet;
var ShockBeamCoil Coil;
var Material TeamColorMaterial;
var ColorModifier Alpha;

replication
{
    unreliable if(Role == ROLE_Authority)
        TeamNum;
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if(Level.NetMode == NM_DedicatedServer)
        return;

    if(class'Misc_Player'.default.bTeamColorShock)
    {
        Alpha = ColorModifier(Level.ObjectPool.AllocateObject(class'ColorModifier'));
        Alpha.Material = TeamColorMaterial;
        Alpha.AlphaBlend = true;
        Alpha.RenderTwoSided = true;
        Alpha.Color.A = 255;
        Skins[0] = Alpha;
        bAlphaSet=true;
    }

    SetColors();
}

simulated function Destroyed()
{
	if ( bAlphaSet )
	{
		Level.ObjectPool.FreeObject(Skins[0]);
		Skins[0] = None;
	}

	super.Destroyed();
}


simulated function SetColors()
{
    local Color color;
    if(class'Misc_Player'.default.bTeamColorShock && !bColorSet && Level.NetMode != NM_DedicatedServer && Coil != None)
    {
        color = class'TeamColorManager'.static.GetColor(TeamNum, Level.GetLocalPlayerController());
        if(TeamNum == 0 || TeamNum == 1)
        {
            Alpha.Color.R = color.R;
            Alpha.Color.G = color.G;
            Alpha.Color.B = color.B;
            if(Coil != None)
            {
                Coil.mColorRange[0]=color;
                Coil.mColorRange[1]=color;
            }
            bColorSet=true;
        }
    }
}

simulated function Tick(float DT)
{
    super.Tick(DT);
    SetColors();
}

simulated function SpawnEffects()
{
    local xWeaponAttachment Attachment;
	
    if (Instigator != None)
    {
        if ( Instigator.IsFirstPerson() )
        {
			if ( (Instigator.Weapon != None) && (Instigator.Weapon.Instigator == Instigator) )
				SetLocation(Instigator.Weapon.GetEffectStart());
			else
				SetLocation(Instigator.Location);
            Spawn(MuzFlashClass,,, Location);
        }
        else
        {
            Attachment = xPawn(Instigator).WeaponAttachment;
            if (Attachment != None && (Level.TimeSeconds - Attachment.LastRenderTime) < 1)
                SetLocation(Attachment.GetTipLocation());
            else
                SetLocation(Instigator.Location + Instigator.EyeHeight*Vect(0,0,1) + Normal(mSpawnVecA - Instigator.Location) * 25.0); 
            Spawn(MuzFlash3Class);
        }
    }

    if ( EffectIsRelevant(mSpawnVecA + HitNormal*2,false) && (HitNormal != Vect(0,0,0)) )
		SpawnImpactEffects(Rotator(HitNormal),mSpawnVecA + HitNormal*2);
	
    if ( (!Level.bDropDetail && (Level.DetailMode != DM_Low) && (VSize(Location - mSpawnVecA) > 40) && !Level.GetLocalPlayerController().BeyondViewDistance(Location,0))
		|| ((Instigator != None) && Instigator.IsFirstPerson()) )
    {
	    Coil = Spawn(CoilClass,,, Location, Rotation);
	    if (Coil != None)
        {
		    Coil.mSpawnVecA = mSpawnVecA;
        }
    }
}

defaultproperties
{

    TeamNum=255

    TeamColorMaterial=Texture'3SPNvSoL.ShockBeamTex_white'
}