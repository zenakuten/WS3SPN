//================================================================================
// Misc_VictimMessage.
//================================================================================

class Misc_VictimMessage extends xVictimMessage;

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  local Class<Weapon> WClass;

  if ( RelatedPRI_1 == None )
  {
    return "You Killed Yourself";
  }
  if ( (Class<DamTypeTelefragged>(OptionalObject) != None) || (Class<DamTypeTeleFrag>(OptionalObject) != None) || (Class<Gibbed>(OptionalObject) != None) )
  {
    return Misc_PRI(RelatedPRI_1).GetColoredName2(Default.DrawColor) @ Default.YouWereKilledBy @ Class'DMStatsScreen'.static.MakeColorCode(Class'HUD'.Default.TurqColor) $ "TeleFrag" @ Class'DMStatsScreen'.static.MakeColorCode(Default.DrawColor) $ Default.KilledByTrailer;
  } else {
    if ( Class<WeaponDamageType>(OptionalObject) != None )
    {
      WClass = Class<WeaponDamageType>(OptionalObject).Default.WeaponClass;
      return Misc_PRI(RelatedPRI_1).GetColoredName2(Default.DrawColor) @ Default.YouWereKilledBy @ Class'DMStatsScreen'.static.MakeColorCode(WClass.Default.HudColor) $ WClass.Default.ItemName @ Class'DMStatsScreen'.static.MakeColorCode(Default.DrawColor) $ Default.KilledByTrailer;
    } else {
      if ( Class<FellLava>(OptionalObject) != None )
      {
        return Misc_PRI(RelatedPRI_1).GetColoredName2(Default.DrawColor) @ Default.YouWereKilledBy @ Class'DMStatsScreen'.static.MakeColorCode(Class'HUD'.Default.RedColor) $ "Lava" @ Class'DMStatsScreen'.static.MakeColorCode(Default.DrawColor) $ Default.KilledByTrailer;
      } else {
        if ( Class<fell>(OptionalObject) != None )
        {
          return Misc_PRI(RelatedPRI_1).GetColoredName2(Default.DrawColor) @ Default.YouWereKilledBy @ Class'DMStatsScreen'.static.MakeColorCode(Class'HUD'.Default.WhiteColor) $ "Push" @ Class'DMStatsScreen'.static.MakeColorCode(Default.DrawColor) $ Default.KilledByTrailer;
        } else {
          return Misc_PRI(RelatedPRI_1).GetColoredName2(Default.DrawColor) @ Default.YouWereKilledBy @ Class'DMStatsScreen'.static.MakeColorCode(Default.DrawColor) $ "Fart" @ Class'DMStatsScreen'.static.MakeColorCode(Default.DrawColor) $ Default.KilledByTrailer;
        }
      }
    }
  }
}

defaultproperties
{
     YouWereKilledBy="Killed You With"
     KilledByTrailer=" "
     Lifetime=2
     PosY=0.250000
     FontSize=1
}
