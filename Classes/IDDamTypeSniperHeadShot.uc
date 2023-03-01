//================================================================================
// DamTypeSniperHeadShot.
//================================================================================

class IDDamTypeSniperHeadShot extends WeaponDamageType
  Abstract;
 
var int AwardLevel;

var Class<LocalMessage> KillerMessage;
var Sound Headhunter;

static function IncrementKills (Controller Killer)
{
  local xPlayerReplicationInfo xPRI;

  if ( PlayerController(Killer) == None )
  {
    return;
  }
  PlayerController(Killer).ReceiveLocalizedMessage(Default.KillerMessage,0,Killer.PlayerReplicationInfo,None,None);
  xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
  if ( xPRI != None )
  {
    xPRI.HeadCount++;
		
			if ( (xPRI.HeadCount == Default.AwardLevel) && (Misc_Player(Killer) != None) )
			Misc_Player(Killer).BroadcastAnnouncement(Class'Message_HeadHunter');
  }
}

static function GetHitEffects (out Class<xEmitter> HitEffects[4], int VictemHealth)
{
  HitEffects[0] = Class'HitSmoke';
  HitEffects[1] = Class'HitFlameBig';
}

defaultproperties
{
     AwardLevel=5
     KillerMessage=Class'XGame.SpecialKillMessage'
     WeaponClass=Class'XWeapons.SniperRifle'
     bAlwaysSevers=True
     bSpecial=True
     bCauseConvulsions=True
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DamageOverlayTime=0.900000
}
