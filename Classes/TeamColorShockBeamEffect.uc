class TeamColorShockBeamEffect extends ShockBeamEffect;

var int TeamNum;
var bool bColorSet;
var Texture RedTexture, BlueTexture;
var ShockBeamCoil Coil;
var Color RedColor, BlueColor;

replication
{
    unreliable if(Role == ROLE_Authority)
        TeamNum;
}

simulated function SetColors()
{
    if(class'Misc_Player'.default.bTeamColorShock && !bColorSet && Level.NetMode == NM_Client && Coil != None)
    {
        if(TeamNum == 0)
        {
            Skins[0]=RedTexture;
            if(Coil != None)
            {
                Coil.mColorRange[0]=RedColor;
                Coil.mColorRange[1]=RedColor;
            }
            bColorSet=true;
        }
        else if(TeamNum == 1)
        {
            Skins[0]=BlueTexture;
            if(Coil != None)
            {
                Coil.mColorRange[0]=BlueColor;
                Coil.mColorRange[1]=BlueColor;
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
    RedTexture=Texture'3SPNvSoL.ShockBeamTex_red'
    BlueTexture=Texture'3SPNvSoL.ShockBeamTex_blue'
    RedColor=(R=255,G=0,B=0)
    BlueColor=(R=0,G=0,B=255)

    TeamNum=255
}