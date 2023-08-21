class Misc_RandomPickupSpawner extends Misc_PickupSpawner
    notplaceable;

var Misc_PickupBase Bases[3];

function SpawnPickups()
{
    local int i;
    local float Score[3];
    local float eval;
    local NavigationPoint Best[3];
    local NavigationPoint N;

    for(i = 0; i < 100; i++)
        FRand();

    for(i = 0; i < 3; i++)
    {
        for(N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
        {
            if(InventorySpot(N) == None || InventorySpot(N).myPickupBase == None)
                continue;

            eval = 0;

            if(i == 0)
                eval = FRand() * 5000.0;
            else
            {
                if(Best[0] != None)
                    eval = VSize(Best[0].Location - N.Location) * (0.8 + FRand() * 1.2);

                if(i > 1 && Best[1] != None)
                    eval += VSize(Best[1].Location - N.Location) * (1.5 + FRand() * 0.5);
            }

            if(Best[0] == N)
                eval = 0;
            if(Best[1] == N)
                eval = 0;
            if(Best[2] == N)
                eval = 0;

            if(Score[i] < eval)
            {
                Score[i] = eval;
                Best[i] = N;
            }
        }
    }

    if(Best[0] != None)
    {
        Bases[0] = Spawn(class'Misc_PickupBase',,, Best[0].Location, Best[0].Rotation);
        Bases[0].MyMarker = InventorySpot(Best[0]);
    }
    if(Best[1] != None)
    {
        Bases[1] = Spawn(class'Misc_PickupBase',,, Best[1].Location, Best[1].Rotation);
        Bases[1].MyMarker = InventorySpot(Best[1]);
    }
    if(Best[2] != None)
    {
        Bases[2] = Spawn(class'Misc_PickupBase',,, Best[2].Location, Best[2].Rotation);
        Bases[2].MyMarker = InventorySpot(Best[2]);
    }
}
