//================================================================================
// Misc_DeathMessage.
//================================================================================

class Misc_DeathMessage extends xDeathMessage
  Config(User);

var Color TextColor;
var string Text;
var config bool bDrawColoredNamesInDeathMessages;
var config bool bEnableTeamColoredDeaths;

static function string MakeTeamColor (PlayerReplicationInfo PRI)
{
  if ( (PRI == None) || (PRI.Team == None) || (PRI.Team.TeamIndex > 1) )
  {
    return Class'DMStatsScreen'.static.MakeColorCode(Class'HUD'.Default.WhiteColor);
  }
  if ( PRI.Team.TeamIndex == 0 )
  {
    return Class'DMStatsScreen'.static.MakeColorCode(Class'Misc_Player'.Default.RedMessageColor);
  }
  return Class'DMStatsScreen'.static.MakeColorCode(Class'Misc_Player'.Default.BlueMessageColor);
}

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  local string KillerName;
  local string VictimName;
  local Misc_PRI PRI;

  if ( Class<DamageType>(OptionalObject) == None )
  {
    return "";
  }
  PRI = Misc_PRI(RelatedPRI_2);
  if ( RelatedPRI_2 == None )
  {
    VictimName = Default.SomeoneString;
  } else {
    if ( Default.bDrawColoredNamesInDeathMessages && (PRI != None) && (PRI.GetColoredName() != "") )
    {
      VictimName = MakeTeamColor(PRI) $ PRI.GetColoredName() $ Class'DMStatsScreen'.static.MakeColorCode(Class'HUD'.Default.GreenColor);
    } else {
      if ( Default.bEnableTeamColoredDeaths )
      {
        VictimName = MakeTeamColor(PRI) $ RelatedPRI_2.PlayerName $ Class'DMStatsScreen'.static.MakeColorCode(Class'HUD'.Default.GreenColor);
      } else {
        VictimName = RelatedPRI_2.PlayerName;
      }
    }
  }
  if ( Switch == 1 )
  {
    return Class'GameInfo'.static.ParseKillMessage(KillerName,VictimName,Class<DamageType>(OptionalObject).static.SuicideMessage(RelatedPRI_2));
  }
  PRI = Misc_PRI(RelatedPRI_1);
  if ( RelatedPRI_1 == None )
  {
    KillerName = Default.SomeoneString;
  } else {
    if ( Default.bDrawColoredNamesInDeathMessages && (PRI != None) && (PRI.GetColoredName() != "") )
    {
      KillerName = MakeTeamColor(PRI) $ PRI.GetColoredName() $ Class'DMStatsScreen'.static.MakeColorCode(Class'HUD'.Default.GreenColor);
    } else {
      if ( Default.bEnableTeamColoredDeaths )
      {
        KillerName = MakeTeamColor(PRI) $ RelatedPRI_1.PlayerName $ Class'DMStatsScreen'.static.MakeColorCode(Class'HUD'.Default.GreenColor);
      } else {
        KillerName = RelatedPRI_1.PlayerName;
      }
    }
  }
  return Class'GameInfo'.static.ParseKillMessage(KillerName,VictimName,Class<DamageType>(OptionalObject).static.DeathMessage(RelatedPRI_1,RelatedPRI_2));
}

static function string PriName (PlayerReplicationInfo PRI)
{
  if ( PRI == None )
  {
    return "";
  }
  return PRI.PlayerName;
}

static function ClientReceive (PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( Switch == 1 )
  {
    if (  !Class'xDeathMessage'.Default.bNoConsoleDeathMessages )
    {
      Super(LocalMessage).ClientReceive(P,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
    }
    if ( RelatedPRI_2 == P.PlayerReplicationInfo )
    {
      P.ReceiveLocalizedMessage(Class'Misc_VictimMessage',1);
    }
    return;
  }
  if ( (RelatedPRI_1 == P.PlayerReplicationInfo) || P.PlayerReplicationInfo.bOnlySpectator && (Pawn(P.ViewTarget) != None) && (Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_1) )
  {
    P.myHUD.LocalizedMessage(Class'Misc_KillerMessage',Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
    if (  !Class'xDeathMessage'.Default.bNoConsoleDeathMessages )
    {
      P.myHUD.LocalizedMessage(Default.Class,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
    }
    if ( P.Role == 4 )
    {
      if ( UnrealPlayer(P).MultiKillLevel > 0 )
      {
        P.ReceiveLocalizedMessage(Class'MultiKillMessage',UnrealPlayer(P).MultiKillLevel);
      }
    } else {
      if ( (RelatedPRI_1 != RelatedPRI_2) && (RelatedPRI_2 != None) && ((RelatedPRI_2.Team == None) || (RelatedPRI_1.Team != RelatedPRI_2.Team)) )
      {
        if ( (P.Level.TimeSeconds - UnrealPlayer(P).LastKillTime < 4) && (Switch != 1) )
        {
          UnrealPlayer(P).MultiKillLevel++;
          P.ReceiveLocalizedMessage(Class'MultiKillMessage',xPlayer(P).MultiKillLevel);
        } else {
          UnrealPlayer(P).MultiKillLevel = 0;
        }
        UnrealPlayer(P).LastKillTime = P.Level.TimeSeconds;
      } else {
        UnrealPlayer(P).MultiKillLevel = 0;
      }
    }
  } else {
    if ( RelatedPRI_2 == P.PlayerReplicationInfo )
    {
      P.ReceiveLocalizedMessage(Class'Misc_VictimMessage',0,RelatedPRI_1,,OptionalObject);
      if (  !Class'xDeathMessage'.Default.bNoConsoleDeathMessages )
      {
        Super(LocalMessage).ClientReceive(P,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
      }
    } else {
      if (  !Class'xDeathMessage'.Default.bNoConsoleDeathMessages )
      {
        Super(LocalMessage).ClientReceive(P,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
      }
    }
  }
}

defaultproperties
{
     TextColor=(B=210,G=210,R=210,A=255)
     bDrawColoredNamesInDeathMessages=True
}
