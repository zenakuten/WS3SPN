//================================================================================
// Message_LinkShafter.
//================================================================================

class Message_LinkShafter extends LocalMessage;
#exec AUDIO IMPORT FILE=Sounds\LinkShafter.wav GROUP=Sounds


var Sound LinkShafterSound;
var localized string YouAreLinkShafter;
var localized string PlayerIsLinkShafter;

static function string GetString (optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( SwitchNum == 1 )
  {
    return Default.YouAreLinkShafter;
  } else {
    return RelatedPRI_1.PlayerName @ Default.PlayerIsLinkShafter;
  }
}

static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
  if ( SwitchNum == 1 )
  {
    P.ClientPlaySound(Default.LinkShafterSound);
  }
}

defaultproperties
{
     LinkShafterSound=Sound'3SPNvSoL.Sounds.LinkShafter'
     YouAreLinkShafter="L I N K  S H A F T E R"
     PlayerIsLinkShafter="Is A Link Shafter"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
     DrawColor=(R=128)
}
