//class WeaponFire_Shock extends ShockBeamFire;
class WeaponFire_Shock extends TeamColorShockBeamFire;

event ModeDoFire()
{
    Misc_PRI(xPawn(Weapon.Owner).PlayerReplicationInfo).Shock.Primary.Fired += load;
    Super.ModeDoFire();
}

defaultproperties
{
}
