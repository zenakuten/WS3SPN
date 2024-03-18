//================================================================================
// VJustSpawnedIcon.
//================================================================================

class VJustSpawnedIcon extends Actor;

#EXEC TEXTURE IMPORT GROUP=Textures NAME=SpawnKillerIcon FILE="Textures\SpawnKillerIcon.dds" MIPS=Off ALPHA=1 DXT=5 LODSET=LODSET_Interface

  

function PostBeginPlay ()
{
  if ( Pawn(Owner) != None )
  {
    Owner.AttachToBone(self,'Bip01 Pelvis');
  }
}

simulated function PostNetBeginPlay ()
{
  SetRelativeLocation(vect(200.00,0.00,0.00));
}

simulated function Destroyed ()
{
  if ( Level.NetMode != 1 )
  {
    if ( EffectIsRelevant(Location,False) )
    {
      Spawn(Class'VSpawnKillIconSmoke',,,Location,rot(16384,0,0));
      Spawn(Class'VSpawnKillIconChunks',,,Location,rot(16384,0,0));
    }
  }
  Super.Destroyed();
}

function Tick (float DeltaTime)
{
  if ( (Pawn(Owner) == None) || (Pawn(Owner).Health <= 0) )
  {
    Destroy();
  }
}

defaultproperties
{
     LifeSpan=4.500000
     Texture=Texture'WS3SPN.textures.SpawnKillerIcon'
     DrawScale=0.150000
}
