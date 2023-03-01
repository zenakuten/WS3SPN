class WeaponFire_LinkAlt extends LinkAltFire;

event ModeDoFire()
{
    Misc_PRI(xPawn(Weapon.Owner).PlayerReplicationInfo).Link.Primary.Fired++;
    Super.ModeDoFire();
}

defaultproperties
{
}
