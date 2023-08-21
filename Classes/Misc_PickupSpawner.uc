class Misc_PickupSpawner extends Actor
    abstract
    notplaceable;

function BeginPlay()
{
    Disable('Tick');
}

function SpawnPickups();

defaultproperties{
    bHidden=true
}
