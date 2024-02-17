class DelayedSound extends Info;

var Sound SoundToPlay;
var PlayerController PC;

function Timer()
{
    if(PC != None && SoundToPlay != None)
    {
        PC.ClientPlaySound(SoundToPlay);
    }
}

defaultproperties
{
    bHidden=true
}