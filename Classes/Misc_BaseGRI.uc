class Misc_BaseGRI extends GameReplicationInfo DependsOn(Team_GameBase);

var string Version;
var string Acronym;

var int RoundTime;
var int RoundMinute;
var int CurrentRound;
var bool bEndOfRound;
var bool bGamePaused;
var Misc_PlayerDataManager_ServerLink PlayerDataManager_ServerLink;
var Team_GameBase TGB;
var bool stat;

var int SecsPerRound;
var int OTDamage;
var int OTInterval;

var int StartingHealth;
var int StartingArmor;
var float MaxHealth;

var float CampThreshold;
var bool bKickExcessiveCampers;
var bool bSpecExcessiveCampers;
var bool UseZAxisRadar;
var bool bForceRUP;
var int ForceRUPMinPlayers;
var string ScoreBoardExtraInfo;
var string statsenableddisabled;
var bool bDisableSpeed;
var bool bDisableBooster;
var bool bDisableInvis;
var bool bDisableBerserk;
var bool bDisableNecro;
var bool bDisableNecroMessage;

var int  TimeOuts;

var bool EnableNewNet;
var bool bDamageIndicator;

var string ShieldTextureName;
var string FlagTextureName;
var bool ShowServerName;
var bool FlagTextureEnabled;
var bool FlagTextureShowAcronym;
var PlayerReplicationInfo NextWhoToRes[2];
var float ServerSkill;
var string ScoreboardCommunityName;
var string ScoreboardRedTeamName;
var string ScoreboardBlueTeamName;

var string SoundAloneName;
var string SoundSpawnProtectionName;

var Team_GameBase.EServerLinkStatus ServerLinkStatus; //enum type dependson Team_GameBase

var bool bCanBoostDodge;
var int MinNetSpeed;
var int MaxNetSpeed;
var bool UseNetUpdateRate;
var float MinNetUpdateRate;
var float MaxNetUpdateRate;
var float FootstepVolume;
var int FootstepRadius;

var bool bAllowColorWeapons;
var bool bKeepMomentumOnLanding;

var bool bLockRolloff;
var float RolloffMinValue;

var bool bBoostedAltShieldJump;
var bool bAllowPauseSounds;
var bool bAllowSetBehindView;
var bool bForceDeadToSpectate;
var float ForceDeadSpectateDelay;

var bool bEnableAntiAwards;
var bool bEnableExtraAwards;

replication
{
    reliable if(bNetInitial && Role == ROLE_Authority)
        RoundTime, SecsPerRound, bDisableSpeed, bDisableBooster, bDisableInvis,
        bDisableBerserk, StartingHealth, StartingArmor, MaxHealth, OTDamage,
        OTInterval, CampThreshold, bKickExcessiveCampers, bSpecExcessiveCampers, bForceRUP, ForceRUPMinPlayers,
        TimeOuts, Acronym, EnableNewNet, ShieldTextureName, ShowServerName,
        FlagTextureEnabled, FlagTextureName, ScoreboardRedTeamName, ScoreboardBlueTeamName, FlagTextureShowAcronym, SoundAloneName,
        SoundSpawnProtectionName,UseZAxisRadar,bDamageIndicator, bCanBoostDodge,
        MaxNetSpeed, MinNetSpeed, FootstepVolume, FootstepRadius, bAllowColorWeapons, bKeepMomentumOnLanding,
        UseNetUpdateRate, MinNetUpdateRate, MaxNetUpdateRate, bLockRolloff, RollOffMinValue,
        bBoostedAltShieldJump, bAllowPauseSounds, bDisableNecro, bDisableNecroMessage, bAllowSetBehindView,
        bForceDeadToSpectate, ForceDeadSpectateDelay, bEnableAntiAwards, bEnableExtraAwards;

    reliable if(!bNetInitial && bNetDirty && Role == ROLE_Authority)
        RoundMinute;

    reliable if(bNetDirty && Role == ROLE_Authority)
        CurrentRound, bEndOfRound, bGamePaused;
		
		 unreliable if ( bNetDirty && (Role == 4) )
    NextWhoToRes, ServerSkill, ServerLinkStatus, ScoreBoardExtraInfo, stat;
}

function float Decimal (float Num)
{
  if ( Num > 0 )
  {
    return int((Num + 0.051) * 10) * 0.1;
  } else {
    return int((Num - 0.051) * 10) * 0.1;
  }
}

function UpdateServerRecorder ()
{
  local string NewText;
  local string Text;
//  local bool teste;
 // local bool stat;
	//stat = TGB.NoStatsForThisMatch;
 // if (teste)
 // {Text = (class'Message_StatsRecordingDisabled'.Default.recor);}
 // else if (!teste) { Text =(class'Message_StatsRecordingDisabled'.Default.disabled);}
  
  if ( Class'Misc_PlayerDataManager_Local'.Default.TopScore > 0 )
  {
    NewText = "Server Record:" @ Class'Misc_PlayerDataManager_Local'.Default.TopName @ string(Class'Misc_PlayerDataManager_Local'.Default.TopScore) @ "Points";
  } else {
    NewText = "Server Record: -";
  }
  if ( ScoreBoardExtraInfo != NewText )
  {
    ScoreBoardExtraInfo = NewText @ Text;
  }
}

simulated function string onoff () {
  local string Text;


  if (stat)
 {Text = (class'Message_StatsRecordingDisabled'.Default.recor);}
  else { Text =(class'Message_StatsRecordingDisabled'.Default.disabled);}
 // statsenableddisabled = Text;
 
  return Text;
}


function UpdateServerSkill ()
{
  local int i;
  local float Players[2];
  local float PPR[2];
  local float AvgPPR;

  i = 0;
  JL0007:
  if ( i < PRIArray.Length )
  {
  if ( (PRIArray[i].Team != None) && (PRIArray[i].Team.TeamIndex < 2) )
    {
  if ( (Misc_PRI(PRIArray[i]) == None) || (Misc_PRI(PRIArray[i]).AvgPPR == 0) )
      {
        goto JL00FF;
      }
    
      PPR[PRIArray[i].Team.TeamIndex] += Decimal(Misc_PRI(PRIArray[i]).AvgPPR);
      Players[PRIArray[i].Team.TeamIndex] += 1;
	  }
    JL00FF:
    i++;
    goto JL0007;
  }
  if ( (Players[0] < 1) || (Players[1] < 1) )
  {
    AvgPPR = 0.0;
  } else {
    AvgPPR = Decimal((Decimal(PPR[0] / Players[0]) + Decimal(PPR[1] / Players[1])) * 0.5);
  }
  if ( ServerSkill != AvgPPR )
  {
    ServerSkill = AvgPPR;
  }
}

simulated function string GetServerSkillText ()
{
  if ( ServerSkill <= 0 )
  {
    return "ÿ(Min.2 Players)";
  }
  if ( ServerSkill < 1 )
  {
    return "ÿ€No-Skill ÿÿÿ(ÿ€" $ Class'Misc_PRI'.static.GetFormattedPPR(ServerSkill) $ "ÿÿÿ)";
  }
  if ( ServerSkill < 1.8 )
  {
    return "ÿÿ@Low ÿÿÿ(ÿÿ@" $ Class'Misc_PRI'.static.GetFormattedPPR(ServerSkill) $ "ÿÿÿ)";
  }
  if ( ServerSkill < 2.1 )
  {
    return "€ÿMid ÿÿÿ(€ÿ" $ Class'Misc_PRI'.static.GetFormattedPPR(ServerSkill) $ "ÿÿÿ)";
  }
  if ( ServerSkill < 2.25 )
  {
    return "€ÿGood ÿÿÿ(€ÿ" $ Class'Misc_PRI'.static.GetFormattedPPR(ServerSkill) $ "ÿÿÿ)";
  }
  if ( ServerSkill < 2.7 )
  {
    return "€ÿHigh ÿÿÿ(€ÿ" $ Class'Misc_PRI'.static.GetFormattedPPR(ServerSkill) $ "ÿÿÿ)";
  }
  if ( ServerSkill > 3.1 )
  {
    return "€ÿInsane ÿÿÿ(€ÿ" $ Class'Misc_PRI'.static.GetFormattedPPR(ServerSkill) $ "ÿÿÿ)";
  }
  
}




function PlayerReplicationInfo PickWhoToRes (TeamInfo Team)
{
  local Controller C;

  if ( Team == None )
  {
    return None;
  }
  C = Class'NecroCombo'.static.PickWhoToRes(Team);
  if ( C == None )
  {
    return None;
  }
  return C.PlayerReplicationInfo;
}

function UpdateWhoToRes ()
{
  local PlayerReplicationInfo PRI;
  local Controller C;
  local int CanRes[2];

  if (  !Level.Game.bGameEnded )
  {
    C = Level.ControllerList;
	JL0031:
    if ( C != None )
    {
      if ( (C.PlayerReplicationInfo != None) && (C.PlayerReplicationInfo.Team != None) &&  !C.PlayerReplicationInfo.bOutOfLives && (C.Adrenaline >= 100) )
      {
        CanRes[C.PlayerReplicationInfo.Team.TeamIndex]++;
      }
      C = C.nextController;
      goto JL0031;
    }
  }
  if ( CanRes[0] > 0 )
  {
    PRI = PickWhoToRes(Teams[0]);
  } else {
    PRI = None;
  }
  if ( NextWhoToRes[0] != PRI )
  {
    NextWhoToRes[0] = PRI;
  }
  if ( CanRes[1] > 0 )
  {
    PRI = PickWhoToRes(Teams[1]);
  } else {
    PRI = None;
  }
  if ( NextWhoToRes[1] != PRI )
  {
    NextWhoToRes[1] = PRI;
  }
}


simulated function Timer()
{ 
    Super.Timer();
	
	UpdateServerRecorder();
	if ( Role == 4 )
  {
	
    UpdateServerSkill();
	}
    UpdateWhoToRes();
  
    if(Level.NetMode == NM_Client)
    {
        if(RoundMinute > 0)
        {
            RoundTime = RoundMinute;
            RoundMinute = 0;
        }

        if(RoundTime > 0 && !bStopCountDown)
            RoundTime--;
    }
}

defaultproperties
{
     Version="SoL 3.7"
     EnableNewNet=True
}
