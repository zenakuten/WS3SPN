class Emoticons extends Actor
    config(Emoticons);

struct sSmileyMessageType
{
	var string Event;
	var Texture Icon;
	var Material MatIcon;
};

var() config array<sSmileyMessageType> Smileys;
var transient EmoticonsReplicationInfo EmoticonsState;

defaultproperties
{
    bHidden=true
}