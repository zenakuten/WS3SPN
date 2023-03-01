class WeaponFire_ClassicSniper extends ClassicSniperFire;
#exec AUDIO IMPORT FILE=Sounds\ClassicSniper.wav GROUP=Sounds
event ModeDoFire()
{
    Misc_PRI(xPawn(Weapon.Owner).PlayerReplicationInfo).ClassicSniper.Fired += load;
    Super.ModeDoFire();
}

defaultproperties
{
     DamageTypeHeadShot=Class'3SPNvSoL.DamType_ClassicHeadshot'
     DamageMin=70
     DamageMax=70
     FireSound=Sound'3SPNvSoL.Sounds.ClassicSniper'
     FireRate=1.600000
}
