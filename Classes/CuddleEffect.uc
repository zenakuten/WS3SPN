//================================================================================
// CuddleEffect.
//================================================================================

class CuddleEffect extends RegenCrosses;
#exec AUDIO IMPORT FILE=Sounds\CuddlingSoundEffect.wav GROUP=Sounds
var xEmitter ExtraEffect;

simulated function PostNetBeginPlay ()
{
  if ( (ExtraEffect == None) && (Level.NetMode != 1) )
  {
    ExtraEffect = Spawn(Class'OffensiveEffect',Owner,,Owner.Location,Owner.Rotation);
  }
}

simulated function Destroyed ()
{
  if ( ExtraEffect != None )
  {
    ExtraEffect.Destroy();
  }
}

defaultproperties
{
     mMassRange(0)=-0.150000
     mMassRange(1)=-0.150000
     mColorRange(0)=(G=0,R=0)
     mColorRange(1)=(G=80,R=0)
}
