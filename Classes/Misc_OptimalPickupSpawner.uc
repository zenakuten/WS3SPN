class Misc_OptimalPickupSpawner extends Misc_PickupSpawner
    notplaceable;

struct Configuration
{
    var float Score;
    var Actor PrimaryActor;
    var Actor SecondaryActors[2];
};

var() int MaxCenters;
var() int MaxConfigurations;
var() bool bRandomize;
var array<Configuration> Configurations;
var array<Misc_PickupBase> Bases;

// SpawnPickups spawns pickups at the best configuration found.
//
// If bRandomize is true, then randomly select 1 out of the best.
function SpawnPickups()
{
    local Configuration Best;

    if (Configurations.Length == 0 && MaxConfigurations > 0)
        FindBestConfigurations();

    if (Configurations.Length == 0)
        return;

    Best = Configurations[0];
    if (bRandomize)
        Best = Configurations[Rand(Configurations.Length)];

    SpawnConfiguration(Best);
}

// SpawnConfiguration spawns pickups at the given configuration.
function SpawnConfiguration(Configuration Cfg)
{
    local Misc_PickupBase Current;
    local int i;

    if (Cfg.PrimaryActor != None)
    {
        Current = Spawn(class'Misc_PickupBase',,, Cfg.PrimaryActor.Location, Cfg.PrimaryActor.Rotation);
        Current.MyMarker = InventorySpot(Cfg.PrimaryActor);
        Bases[Bases.Length] = Current;
    }

    for (i = 0; i < 2; i++)
    {
        if (Cfg.SecondaryActors[i] == None)
            continue;

        Current = Spawn(class'Misc_PickupBase',,, Cfg.SecondaryActors[i].Location, Cfg.SecondaryActors[i].Rotation);
        Current.MyMarker = InventorySpot(Cfg.SecondaryActors[i]);
        Bases[Bases.Length] = Current;
    }
}

// FindBestConfigurations searches for the "best" way to position pickups on
// the map. It follows the following algorithm:
//
// * Search for a location closest to the center of the map, determined by
//   averaging the location of all potentional spawn locations.
// * Find the remaining spawn locations by maximizing the distance from each
//   other and from the center point.
// * Maintain the Configurations list containing the best configurations in
//   sorted order. The size of this list is govern by MaxConfigurations, though
//   it is possible it may be less.
function FindBestConfigurations()
{
    local array<Actor> Actors;
    local array<Actor> CenterMostActors;
    local NavigationPoint N;
    local vector CenterPoint;
    local int i, j, k;
    local Configuration Cfg;

    // Build a list of potential actors to replace
    for (N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
    {
        if (InventorySpot(N) == None || InventorySpot(N).myPickupBase == None)
            continue;

        Actors[Actors.Length] = N;
        CenterPoint += N.Location;
    }

    CenterPoint /= Actors.Length;

    // Find the center most actors
    CenterMostActors.Length = Max(0, MaxCenters);
    FindNearestActors(CenterPoint, Actors, CenterMostActors);

    // Remove center most actors from the list of actors
    RemoveActors(Actors, CenterMostActors);

    // Find the best configurations
    Configurations.Length = Max(0, MaxConfigurations);

    for (i = 0; i < CenterMostActors.Length; i++)
    {
        j = 0;
        k = 0;

        while (NextCombination(Actors.Length, j, k))
        {
            // Maximize the distance between each other and from the
            // designated center point
            Cfg.Score = VSize(Actors[j].Location - Actors[k].Location)
                    * VSize(Actors[j].Location - CenterMostActors[i].Location)
                    * VSize(Actors[k].Location - CenterMostActors[i].Location);

            Cfg.PrimaryActor = CenterMostActors[i];
            Cfg.SecondaryActors[0] = Actors[j];
            Cfg.SecondaryActors[1] = Actors[k];

            InsertConfiguration(Cfg);
        }
    }

    TrimConfigurations();
}

// RemoveActors removes all actors in the Remove array from the From array.
function RemoveActors(out array<Actor> From, array<Actor> Remove)
{
    local bool bRemove;
    local int i, j;

    for (i = From.Length - 1; i >= 0; i--)
    {
        bRemove = false;
        for (j = 0; j < Remove.Length; j++)
        {
            if (From[i] == Remove[j])
            {
                bRemove = true;
                break;
            }
        }

        if (bRemove)
        {
            From[i] = From[From.Length - 1];
            From.Length = From.Length - 1;
        }
    }
}

// InsertConfiguration inserts the configuration to the Configurations array in
// sorted order.
//
// Maintains the invariant Configurations.Size <= MaxConfigurations.
function InsertConfiguration(Configuration Cfg)
{
    local int i;

    // Find where to place it in the list of configurations
    for (i = Configurations.Length - 1; i >= 0 && Cfg.Score > Configurations[i].Score; i--)
    {
        if (i + 1 < Configurations.Length)
            Configurations[i+1] = Configurations[i];

        Configurations[i] = Cfg;
    }
}

// TrimConfigurations removes any invalid configurations from the
// Configurations list. This may happen if we have find less configurations
// than MaxConfigurations.
function TrimConfigurations()
{
    local int i;

    for (i = 0; i < Configurations.Length; i++)
    {
        if (Configurations[i].PrimaryActor == None)
        {
            Configurations.Length = i;
            break;
        }
    }
}

// NextCombination returns the next combination of i and j indexes from an
// array of size n.
function bool NextCombination(int n, out int i, out int j)
{
    // Initialize the base case
    if (i == 0 && j == 0)
    {
        j = 1;
        return true;
    }

    // Find the next combination
    j += 1;
    if (j >= n)
    {
        i += 1;
        if (i >= n - 1)
            return false;
        j = i + 1;
    }

    return true;
}

// FindNearestActors populates Nearest with the actors closest to References.
// The number of actors inserted is determined by the length of the Nearest
// array.
function FindNearestActors(vector Reference, array<Actor> Actors, out array<Actor> Nearest)
{
    local array<float> NearestScores;
    local float Score;
    local int i, j;

    if (Actors.Length == 0 || Nearest.Length == 0)
        return;

    // Initialize scores
    for (i = 0; i < Nearest.Length; i++)
    {
        NearestScores[NearestScores.Length] = 1000000;
    }

    for (i = 0; i < Actors.Length; i++)
    {
        Score = VSize(Actors[i].Location - Reference);

        // Find where to place actor in the list
        for (j = Nearest.Length - 1; j >= 0 && Score < NearestScores[j]; j--)
        {
            if (j + 1 < Nearest.Length)
            {
                Nearest[j+1] = Nearest[j];
                NearestScores[j+1] = NearestScores[j];
            }

            NearestScores[j] = Score;
            Nearest[j] = Actors[i];
        }
    }
}

defaultproperties {
    MaxCenters=1
    MaxConfigurations=3
    bRandomize=true
}
