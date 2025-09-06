class Misc_Player extends BS_xPlayer dependson(TAM_Mutator);

#exec AUDIO IMPORT FILE=Sounds\alone.wav     	    GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\hitsound.wav         GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\Bleep.wav            GROUP=Sounds

/* Combo related */
var config bool bShowCombos;            // show combos on the HUD

var config bool bDisableRadar;
var config bool bDisableAmmoRegen;
/* Combo related */

/* HUD related */
var config bool bShowTeamInfo;          // show teams info on the HUD
var config bool bExtendedInfo;          // show extra teammate info

var config int DamageIndicatorType;     // 1 = Disabled, 2 = Centered, 3 = Floating

enum ReceiveAwardTypes
{
    RAT_Disabled,
    RAT_Player,
    RAT_Team,
    RAT_All
};

var config ReceiveAwardTypes ReceiveAwardType;  // what awards does player see

enum AbortNecroSounds
{
    ANS_None,
    ANS_Meow,
    ANS_Buzz,
    ANS_Fart
};

var config AbortNecroSounds AbortNecroSoundType;

/* brightskins related */

/* misc related */
var bool bAdminVisionInSpec;
var bool bDrawTargetingLineInSpec;
var bool bReportNewNetStats;

var int  Spree;                         // kill count at new round
var bool bFirstOpen;                    // used by the stat screen

var float NewFriendlyDamage;            // friendly damage done
var float NewEnemyDamage;               // enemy damage done

var config bool bDisableAnnouncement;
var config bool bAutoScreenShot;
var bool bShotTaken;

var bool bSeeInvis;

var Pawn OldPawn;
/* misc related */

/* sounds */
var config bool  bAnnounceOverkill;

var Sound ServerSoundAlone;
var config Sound SoundAlone;
var config float SoundAloneVolume;

var config Sound SoundTMDeath;

var config Sound SoundUnlock;

var Sound ServerSoundSpawnProtection;
var config Sound SoundSpawnProtection;
/* sounds */

var config int ShowInitialMenu;
var config Interactions.EInputKey Menu3SPNKey;

var config bool bDisableEndCeremonySound;

var bool EndCeremonyStarted;
var float EndCeremonyTimer;
var int EndCeremonyPlayerIdx;
var array<name> EndCeremonyAnimNames;
var array<string> EndCeremonyWeaponNames;
var array<class> EndCeremonyWeaponClasses;
var bool WinnerAnnounced;
var int EndCeremonyWinningTeamIndex;
var int EndCeremonyPlayerCount;
var Team_GameBase.SEndCeremonyInfo EndCeremonyInfo[10];
var Pawn EndCeremonyPawns[10];

var Misc_PlayerData PlayerData;
var bool ActiveThisRound;

var float NextRezTime;
var float LastRezTime;

var bool PlayerInitialized;

var Color WhiteMessageColor;
var Color WhiteColor;

var config bool bConfigureNetSpeed;
var config int ConfigureNetSpeedValue;

var AudioSubsystem AudioSubsystem;
var int LastNetSpeed;

var float BufferedClickTimer; 
var Actor.eDoubleClickDir BufferedClickDir;

var int NumSpectators;
var config bool bShowSpectators;
var config bool bKillingSpreeCheers;
var config bool bUseEloScoreboard;
var bool bOverlayInitialized;

replication
{
    reliable if(Role == ROLE_Authority)
        ClientResetClock, ClientPlayAlone, ClientPlaySpawnProtection,
        ClientListBest, ClientAddCeremonyRanking, ClientStartCeremony, 
		ClientReceiveStatsListName, ClientReceiveStatsListIdx,
        ClientKillBases, ClientSendAssaultStats,
        ClientSendBioStats, ClientSendShockStats, ClientSendLinkStats,
        ClientSendMiniStats, ClientSendFlakStats, ClientSendRocketStats,
        ClientSendSniperStats, ClientSendClassicSniperStats, ClientSendComboStats, ClientSendMiscStats,
        ReceiveAwardMessage, AbortNecro, NumSpectators;

    reliable if(bNetDirty && Role == ROLE_Authority)
        bSeeInvis;

    reliable if( Role==ROLE_Authority && !bDemoRecording )
        PlayCustomRewardAnnouncement, PlayStatusAnnouncementReliable;
        
    reliable if(Role < ROLE_Authority)
        ServerSetMapString, ServerCallTimeout,
		SetNetCodeDisabled, SetTeamScore,
		ServerReportNewNetStats,
        ServerPlaySound, ServerPausePass;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if ( Level.NetMode == NM_DedicatedServer )
        return;

      foreach AllObjects(class'AudioSubsystem', AudioSubsystem) 
        break;
}

function SetNetCodeDisabled()
{
}

function Misc_PlayerDataManager_ServerLink GetPlayerDataManager_ServerLink()
{
	if(Team_GameBase(Level.Game)!=None && Team_GameBase(Level.Game).PlayerDataManager_ServerLink!=None)
		return Team_GameBase(Level.Game).PlayerDataManager_ServerLink;
	/*else if(ArenaMaster(Level.Game)!=None && ArenaMaster(Level.Game).PlayerDataManager_ServerLink!=None)
		return ArenaMaster(Level.Game).PlayerDataManager_ServerLink*/
	return None;
}

function ResetPlayerData()
{
	local int CurrentRound;

	PlayerReplicationInfo.Score = 0;
	PlayerReplicationInfo.Kills = 0;
	PlayerReplicationInfo.Deaths = 0;
	Misc_PRI(PlayerReplicationInfo).PointsToRankUp = 0.0;
	Misc_PRI(PlayerReplicationInfo).Rank = 0;
	Misc_PRI(PlayerReplicationInfo).AvgPPR = 0;
	
	if(Freon_PRI(PlayerReplicationInfo)!=None) {
		Freon_PRI(PlayerReplicationInfo).Thaws = 0;
		Freon_PRI(PlayerReplicationInfo).Git = 0;
	}
	
	if(Team_GameBase(Level.Game)!=None)
		CurrentRound = Team_GameBase(Level.Game).CurrentRound;
	else if(ArenaMaster(Level.Game)!=None)
		CurrentRound = ArenaMaster(Level.Game).CurrentRound;
	Misc_PRI(PlayerReplicationInfo).PlayedRounds = 0;
}

function LoadPlayerDataStats()
{
	
	

  local int idx;
  local int PPRListLength;
  local Misc_PRI MPRI;

  MPRI = Misc_PRI(PlayerReplicationInfo);
  MPRI.Elo = PlayerData.Elo;
  MPRI.KillCount = PlayerData.KillCount;
  MPRI.FraggedCount = PlayerData.FraggedCount;
  MPRI.Rank = PlayerData.Rank;
  MPRI.AvgPPR = PlayerData.AvgPPR;
  MPRI.PointsToRankUp = PlayerData.PointsToRankUp;
//  MPRI.Moneyreal = PlayerData.Moneyreal;
  PPRListLength = Min(30,PlayerData.PPRListLength);
  MPRI.PPRListLength = PPRListLength;
  idx = 0;
  JL009C:
  if ( idx < PPRListLength )
  {
    MPRI.PPRList[idx] = PlayerData.PPRList[idx];
    idx++;
    goto JL009C;
  }

	//Misc_PRI(PlayerReplicationInfo).Rank = PlayerData.Rank;
	//Misc_PRI(PlayerReplicationInfo).AvgPPR = PlayerData.AvgPPR;
	
	
}


//simulated event ReceiveLocalizedMessage (Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
//{
//  if ( (Level.NetMode == 1) || (GameReplicationInfo == None) )
// {
//    return;
//  }
//  if ( Message == Class'KillingSpreeMessage' )
//  {
//    Message = Class'Message_KillingSpree';
//  }
//  Message.static.ClientReceive(self,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
//  if ( Message.static.IsConsoleMessage(Switch) && (Player != None) && (Player.Console != None) )
//  {
//    Player.Console.Message(Message.static.GetString(Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject),0.0);
//  }
//}

function LoadPlayerData()
{
	local int CurrentRound;

	LoadPlayerDataStats();

	PlayerReplicationInfo.Score = PlayerData.Current.Score;
	PlayerReplicationInfo.Kills = PlayerData.Current.Kills;
	PlayerReplicationInfo.Deaths = PlayerData.Current.Deaths;
	
	if(Freon_PRI(PlayerReplicationInfo)!=None) {
		Freon_PRI(PlayerReplicationInfo).Thaws = PlayerData.Current.Thaws;
		Freon_PRI(PlayerReplicationInfo).Git = PlayerData.Current.Git;
	}
		
	if(Team_GameBase(Level.Game)!=None)
		CurrentRound = Team_GameBase(Level.Game).CurrentRound;
	else if(ArenaMaster(Level.Game)!=None)
		CurrentRound = ArenaMaster(Level.Game).CurrentRound;
		
	if(ActiveThisRound)
		Misc_PRI(PlayerReplicationInfo).PlayedRounds = PlayerData.Current.Rounds-1;
	else
		Misc_PRI(PlayerReplicationInfo).PlayedRounds = PlayerData.Current.Rounds;

    Misc_PRI(PlayerReplicationInfo).Elo = PlayerData.Elo;
    Misc_PRI(PlayerReplicationInfo).KillCount = PlayerData.KillCount;
    Misc_PRI(PlayerReplicationInfo).FraggedCount = PlayerData.FraggedCount;
}

function StorePlayerData()
{
	local int CurrentRound;

	if(PlayerData==None)
	{
		Log("No player data was being tracked for "$PlayerReplicationInfo.PlayerName);	
		return;
	}

	Log("Storing player data for "$PlayerReplicationInfo.PlayerName);	
	
	PlayerData.Current.Score = PlayerReplicationInfo.Score;
	PlayerData.Current.Kills = PlayerReplicationInfo.Kills;
	PlayerData.Current.Deaths = PlayerReplicationInfo.Deaths;	
	
	if(Freon_PRI(PlayerReplicationInfo)!=None) {
		PlayerData.Current.Thaws = Freon_PRI(PlayerReplicationInfo).Thaws;
		PlayerData.Current.Git = Freon_PRI(PlayerReplicationInfo).Git;
	}
	
	if(Team_GameBase(Level.Game)!=None)
		CurrentRound = Team_GameBase(Level.Game).CurrentRound;
	else if(ArenaMaster(Level.Game)!=None)
		CurrentRound = ArenaMaster(Level.Game).CurrentRound;
	
	if(ActiveThisRound)
		PlayerData.Current.Rounds = Misc_PRI(PlayerReplicationInfo).PlayedRounds+1;
	else
		PlayerData.Current.Rounds = Misc_PRI(PlayerReplicationInfo).PlayedRounds;

    PlayerData.Elo = Misc_PRI(PlayerReplicationInfo).Elo;
    PlayerData.KillCount = Misc_PRI(PlayerReplicationInfo).KillCount;
    PlayerData.FraggedCount = Misc_PRI(PlayerReplicationInfo).FraggedCount;
}

function SetTeamScore(int RedScore, int BlueScore)
{
	local TeamGame TeamGame;
	
    if((PlayerReplicationInfo==None || !PlayerReplicationInfo.bAdmin) && Level.NetMode!=NM_Standalone)
		return;

	TeamGame = TeamGame(Level.Game);
	if(TeamGame == None)
		return;
	
	if(TeamGame.Teams[0]!=None)
		TeamGame.Teams[0].Score = RedScore;
	if(TeamGame.Teams[1]!=None)
		TeamGame.Teams[1].Score = BlueScore;
}

function PlayerTick(float DeltaTime)
{
    local float Rolloff;
    
    Super.PlayerTick(DeltaTime);

	if(Pawn!=None)
	{
		// if we have a pawn, we must be looking at it
		if(ViewTarget!=Pawn && 
            TransBeacon(ViewTarget) == None &&
            RedeemerWarhead(ViewTarget) == None)
        {
            SetViewTarget(Pawn);
        }
	}

	if(!PlayerInitialized && PlayerReplicationInfo!=None)
	{	
        class'Misc_Player'.default.bAdminVisionInSpec = false;
        class'Misc_Player'.default.bDrawTargetingLineInSpec = false;
        class'Misc_Player'.default.bReportNewNetStats = false;
        SetInitialColoredName();
        SetInitialNetSpeed();
		PlayerInitialized = true;
	}

    if(Overlay != None && !bOverlayInitialized)
    {
        // utcomp overlay conflicts
        Overlay.OverlayEnabled = false;
        bOverlayInitialized = true;
    }

    //enforce rolloff
    if (Level.NetMode == NM_Client && Misc_BaseGRI(Level.GRI) != none) 
    {
        if ( AudioSubsystem != None && Misc_BaseGRI(Level.GRI).bLockRolloff) 
        {
            Rolloff = float(AudioSubsystem.GetPropertyText(string('Rolloff')));
            if ( Rolloff < Misc_BaseGRI(Level.GRI).RollOffMinValue )
            {
                ConsoleCommand("Rolloff " @ Misc_BaseGRI(Level.GRI).RolloffMinValue);
            }
        }
    }
	
	if(EndCeremonyStarted)
	{
		UpdateEndCeremony(DeltaTime);
		return;
	}

}

simulated function ClientAddCeremonyRanking(int PlayerIndex, Team_GameBase.SEndCeremonyInfo InEndCeremonyInfo)
{
	if(Level.NetMode == NM_DedicatedServer)
		return;

	EndCeremonyInfo[PlayerIndex].PlayerName = InEndCeremonyInfo.PlayerName;
	EndCeremonyInfo[PlayerIndex].CharacterName = InEndCeremonyInfo.CharacterName;
	EndCeremonyInfo[PlayerIndex].PlayerTeam = InEndCeremonyInfo.PlayerTeam;
	EndCeremonyInfo[PlayerIndex].SpawnPos = InEndCeremonyInfo.SpawnPos;
	EndCeremonyInfo[PlayerIndex].SpawnRot = InEndCeremonyInfo.SpawnRot;
}

simulated function ClientStartCeremony(int PlayerCount, int WinningTeamIndex, string EndCeremonySound)
{
	local int i, i2;
	local Pawn P;
	local Sound LoadedEndCeremonySound;
	
	if(Level.NetMode == NM_DedicatedServer)
		return;
	
	EndCeremonyStarted = true;
	
	EndCeremonyPlayerCount = PlayerCount;
	EndCeremonyWinningTeamIndex = WinningTeamIndex;
	
	if(!class'Misc_Player'.default.bDisableEndCeremonySound)
	{
		LoadedEndCeremonySound = Sound(DynamicLoadObject(EndCeremonySound, class'Sound', True));
		class'Message_WinningTeam'.default.EndCeremonySound = LoadedEndCeremonySound;
	}
	
	for(i=0; i<PlayerCount; ++i)
	{
		P = Spawn(class'Misc_Pawn',,,EndCeremonyInfo[i].SpawnPos,EndCeremonyInfo[i].SpawnRot);
		if(P!=None)
		{		
			P.Role = ROLE_Authority;
			P.RemoteRole = ROLE_None;

            Misc_Pawn(P).bInEndCeremony=true;
			Misc_Pawn(P).Setup(class'xUtil'.static.FindPlayerRecord(EndCeremonyInfo[i].CharacterName), true);
			i2 = Rand(EndCeremonyWeaponNames.Length); 
			Misc_Pawn(P).GiveWeapon(EndCeremonyWeaponNames[i2]);
			Misc_Pawn(P).PendingWeapon = Weapon(Misc_Pawn(P).FindInventoryType(EndCeremonyWeaponClasses[i2]));
			Misc_Pawn(P).ChangedWeapon();
            Misc_Pawn(P).DefaultSkin();
			Misc_Pawn(P).bNetNotify = false;
			Misc_Pawn(P).SetAnimAction('None');

			EndCeremonyPawns[i] = P;
		}
	}
	
	EndCeremonyTimer = 7.0;
	EndCeremonyPlayerIdx = -1;
	
	GotoState('GameEnded');
}

simulated function ClientReceiveStatsListName (string ListName)
{
  local Team_HUDBase th;

  th = Team_HUDBase(myHUD);
  if ( th != None )
  {
    if ( Right(ListName,1) == "*" )
    {
      th.CurrentStatsList = 0;
      ListName = Left(ListName,Len(ListName) - 1);
    } else {
      th.CurrentStatsList = int((th.CurrentStatsList + 1) % 4);
    }
    th.StatsLists[th.CurrentStatsList].ListName = ListName;
    th.StatsLists[th.CurrentStatsList].RecvTime = Level.TimeSeconds;
    th.StatsLists[th.CurrentStatsList].RecvTimeRow = 99999.0;
    th.StatsLists[th.CurrentStatsList].RowNames.Length = 0;
    th.StatsLists[th.CurrentStatsList].RowValues.Length = 0;
  }
}

simulated function ClientReceiveStatsListIdx (int Index, string RowName, string RowValue)
{
  local Team_HUDBase th;

  th = Team_HUDBase(myHUD);
  if ( th != None )
  {
    if ( Index == 0 )
    {
      th.StatsLists[th.CurrentStatsList].RecvTimeRow = Level.TimeSeconds;
    }
    th.StatsLists[th.CurrentStatsList].RowNames.Length = Index + 1;
    th.StatsLists[th.CurrentStatsList].RowNames[Index] = RowName;
    th.StatsLists[th.CurrentStatsList].RowValues.Length = Index + 1;
    th.StatsLists[th.CurrentStatsList].RowValues[Index] = RowValue;
  }
}

simulated function UpdateEndCeremony(float DeltaTime)
{
	local Pawn P;
	local rotator R;
	local int i;
	
	if(EndCeremonyPlayerCount==0)
		return;

	EndCeremonyTimer += DeltaTime;	
	if(EndCeremonyTimer>=7.0)
	{
		EndCeremonyTimer -= 7.0;
		++EndCeremonyPlayerIdx;
			
		if(EndCeremonyPlayerIdx>=EndCeremonyPlayerCount)
			EndCeremonyPlayerIdx = 0;

		P = EndCeremonyPawns[EndCeremonyPlayerIdx];
			
		if(EndCeremonyAnimNames.Length>0)
		{
			i = Rand(EndCeremonyAnimNames.Length); 
			if(P!=None)
			{
				P.PlayAnim(EndCeremonyAnimNames[i], 0.5, 0.0);
				P.bWaitForAnim = true;
				
				ClientSetViewTarget(P);
				SetViewTarget(P);
				ClientSetBehindView(true);
			}
			
			if(!WinnerAnnounced)
			{
				class'Message_WinningTeam'.static.ClientReceive(self, EndCeremonyWinningTeamIndex);
				WinnerAnnounced = true;
			}
		}

		if(P!=None)
		{
			class'Message_PlayerRanking'.default.PlayerName = EndCeremonyInfo[EndCeremonyPlayerIdx].PlayerName;
			class'Message_PlayerRanking'.static.ClientReceive(self, EndCeremonyPlayerIdx);
		}
	}
	
	P = EndCeremonyPawns[EndCeremonyPlayerIdx];
	if(P!=None)
	{
		R = P.Rotation;
		R.Yaw += 32768;
		R.Pitch = -2730;
		SetRotation(R);
	}
}

function ClientListBest(string acc, string dam, string hs)
{
    if(class'Misc_Player'.default.bDisableAnnouncement)
        return;

    if(acc != "")
        ClientMessage(acc);
    if(dam != "")
        ClientMessage(dam);
    if(hs != "")
        ClientMessage(hs);
}

function ServerSetMapString(string s)
{
    if(TeamArenaMaster(Level.Game) != None)
        TeamArenaMaster(Level.Game).SetMapString(self, s);
    else if(ArenaMaster(Level.Game) != None)
        ArenaMaster(Level.Game).SetMapString(self, s);
}

function ServerThrowWeapon()
{
    local int ammo[2];
    local Inventory inv;
    local class<Weapon> WeaponClass;

    if(Misc_Pawn(Pawn) == None || Pawn.Weapon == None)
        return;

    ammo[0] = Pawn.Weapon.AmmoCharge[0];
    ammo[1] = Pawn.Weapon.AmmoCharge[1];
    WeaponClass = Pawn.Weapon.Class;

    Super.ServerThrowWeapon();

    Misc_Pawn(Pawn).GiveWeapon(string(WeaponClass));

    for(inv = Pawn.Inventory; inv != None; inv = inv.Inventory)
    {
        if(inv.Class == WeaponClass)
        {
            Weapon(inv).AmmoCharge[0] = ammo[0];
            Weapon(inv).AmmoCharge[1] = ammo[1];
            break;
        }
    }
}

function AwardAdrenaline(float amount)
{
    if(bAdrenalineEnabled)
    {
        if((TAM_GRI(GameReplicationInfo) == None || TAM_GRI(GameReplicationInfo).bDisableTeamCombos) && (Pawn != None && Pawn.InCurrentCombo()))
            return;
		if ( (Adrenaline < 100) && (Adrenaline + Amount >= 100) )
    {
      ReceiveLocalizedMessage(Class'Message_Adrenaline',0);
    }
        if((Adrenaline < AdrenalineMax) && (Adrenaline + amount >= AdrenalineMax))
			ClientDelayedAnnouncementNamed('Adrenalin', 15);
        Adrenaline = FClamp(Adrenaline + amount, 0.1, AdrenalineMax);
    }
}

simulated function PostNetBeginPlay()
{
    Super.PostNetBeginPlay();

    if(Level.GRI != None)
        Level.GRI.MaxLives = 0;	

}

simulated function InitInputSystem()
{
	local PlayerController C;

	Super.InitInputSystem();
	
	C = Level.GetLocalPlayerController();
	if(C != None)
	{
		C.Player.InteractionMaster.AddInteraction("WS3SPN.Menu_Interaction", C.Player);
	}
}

function ClientKillBases()
{
    local xPickupBase p;

    ForEach AllActors(class'xPickupBase', p)
    {
        if(P.IsA('Misc_PickupBase'))
            continue;

        p.bHidden = true;
        if(p.myEmitter != None)
            p.myEmitter.Destroy();
    }
}

function Reset()
{
    local NavigationPoint P;
    local float Adren;
	
    Adren = Adrenaline;

    P = StartSpot;
    Super.Reset();
    StartSpot = P;

    if(Pawn == None || !Pawn.InCurrentCombo())
        Adrenaline = Adren;
    else
        Adrenaline = 0.1;

    WaitDelay = 0;
}

/*function ClientLockWeapons(bool bLock)
{
    if(xPawn(Pawn) != None)
        xPawn(Pawn).bNoWeaponFiring = bLock;
}*/

function ClientPlayAlone()
{
  if(ServerSoundAlone==None && Len(Misc_BaseGRI(GameReplicationInfo).SoundAloneName)>0) {
    ServerSoundAlone = Sound(DynamicLoadObject(Misc_BaseGRI(GameReplicationInfo).SoundAloneName, class'Sound', True));
  }
  if(ServerSoundAlone!=None)
    ClientPlaySound(ServerSoundAlone, true, class'Misc_Player'.default.SoundAloneVolume);
  else
    ClientPlaySound(class'Misc_Player'.default.SoundAlone, true, class'Misc_Player'.default.SoundAloneVolume);
}

function ClientPlaySpawnProtection()
{
  if(ServerSoundSpawnProtection==None && Len(Misc_BaseGRI(GameReplicationInfo).SoundSpawnProtectionName)>0) {
    ServerSoundSpawnProtection = Sound(DynamicLoadObject(Misc_BaseGRI(GameReplicationInfo).SoundSpawnProtectionName, class'Sound', True));
  }
  if(ServerSoundSpawnProtection!=None)
    ClientPlaySound(ServerSoundSpawnProtection);
  else
    ClientPlaySound(class'Misc_Player'.default.SoundSpawnProtection);
}

function LogMultiKills (float Reward, bool bEnemyKill)
{
  Super.LogMultiKills(Reward,bEnemyKill);
  if ( (MultiKillLevel > 0) && (PlayerReplicationInfo != None) )
  {
    Level.Game.Broadcast(None,PlayerReplicationInfo.PlayerName @ "had a" @ Class'MultiKillMessage'.static.GetString(MultiKillLevel));
  }
}

simulated function PlayCustomRewardAnnouncement(sound ASound, byte AnnouncementLevel, optional bool bForce)
{
	local float Atten;

	// Wait for player to be up to date with replication when joining a server, before stacking up messages
	if(Level.NetMode == NM_DedicatedServer || GameReplicationInfo == None)
		return;

	if((AnnouncementLevel > AnnouncerLevel) || (RewardAnnouncer == None))
		return;
	if(!bForce && (Level.TimeSeconds - LastPlaySound < 1.5))
		return;
    LastPlaySound = Level.TimeSeconds;  // so voice messages won't overlap
	LastPlaySpeech = Level.TimeSeconds;	// don't want chatter to overlap announcements

	Atten = 2.0 * FClamp(0.1 + float(AnnouncerVolume) * 0.225, 0.2, 1.0);
	if(ASound != None)
		ClientPlaySound(ASound, true, Atten, SLOT_Talk);
}

function BroadcastAnnouncement(class<LocalMessage> message)
{
	local Controller C;
    for(C = Level.ControllerList; C != None; C = C.NextController)
        if(Misc_Player(C)!=None)
            Misc_Player(C).ReceiveLocalizedMessage(message, int(C==self), PlayerReplicationInfo);
}

function BroadcastAward(class<LocalMessage> message)
{
	local Controller C;
    for(C = Level.ControllerList; C != None; C = C.NextController)
    {
        if(Misc_Player(C)!=None)
        {
            Misc_Player(C).ReceiveAwardMessage(message, int(C==self), PlayerReplicationInfo);
        }
    }
}

simulated event ReceiveAwardMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    if(ReceiveAwardType == ReceiveAwardTypes.RAT_Disabled)
        return;

    if((ReceiveAwardType == ReceiveAwardTypes.RAT_All) ||
       (ReceiveAwardType == ReceiveAwardTypes.RAT_Player && Switch == 1) ||
       (ReceiveAwardType == ReceiveAwardTypes.RAT_Team && RelatedPRI_1 != None && PlayerReplicationInfo.Team.TeamIndex == RelatedPRI_1.Team.TeamIndex ))
    {
        ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }
}

simulated function PlayStatusAnnouncementReliable(name AName, byte AnnouncementLevel, optional bool bForce)
{
	local float Atten;
	local sound ASound;

	// Wait for player to be up to date with replication when joining a server, before stacking up messages
	if ( Level.NetMode == NM_DedicatedServer || GameReplicationInfo == None )
		return;

	if ( (AnnouncementLevel > AnnouncerLevel) || (StatusAnnouncer == None) )
		return;
	if ( !bForce && (Level.TimeSeconds - LastPlaySound < 1) )
		return;
    LastPlaySound = Level.TimeSeconds;  // so voice messages won't overlap
	LastPlaySpeech = Level.TimeSeconds;	// don't want chatter to overlap announcements

	Atten = 2.0 * FClamp(0.1 + float(AnnouncerVolume)*0.225,0.2,1.0);
	ASound = StatusAnnouncer.GetSound(AName);
	if ( ASound != None )
		ClientPlaySound(ASound,true,Atten,SLOT_Talk);
}

function ClientResetClock(int seconds)
{
    Misc_BaseGRI(GameReplicationInfo).RoundTime = seconds;
}

function AcknowledgePossession(Pawn P)
{
    Super.AcknowledgePossession(P);

    SetupCombos();
	
	if(P!=None && PlayerReplicationInfo!=None)
		P.OwnerName = PlayerReplicationInfo.PlayerName;
	
//    if(xPawn(P) != None && Misc_BaseGRI(GameReplicationInfo) != None)
//        xPawn(P).bNoWeaponFiring = Misc_BaseGRI(GameReplicationInfo).bWeaponsLocked;
}

function ClientReceiveCombo(string ComboName)
{
    Super.ClientReceiveCombo(ComboName);

    SetupCombos();
}

function SetupCombos()
{
    local int i;
    local Misc_BaseGRI GRI;
    local bool bDisable;
    local string ComboName;

    GRI = Misc_BaseGRI(Level.GRI);
    if(GRI == None)
        return;

    for(i = 0; i < ArrayCount(ComboList); i++)
    {
        ComboName = ComboNameList[i];
        if(ComboName ~= "")
            continue;

		bDisable = false;
			
        if(ComboName ~= "xGame.ComboDefensive")
            bDisable = (class'Misc_Player'.default.bDisableBooster || GRI.bDisableBooster);
        else if(ComboName ~= "xGame.ComboSpeed")
            bDisable = (class'Misc_Player'.default.bDisableSpeed || GRI.bDisableSpeed);
        else if(ComboName ~= "xGame.ComboBerserk")
            bDisable = (class'Misc_Player'.default.bDisableBerserk || GRI.bDisableBerserk);
        else if(ComboName ~= "xGame.ComboInvis")
            bDisable = (class'Misc_Player'.default.bDisableInvis || GRI.bDisableInvis);
        else if(ComboName ~= "WS3SPN.NecroCombo")
            bDisable = (GRI.bDisableNecro);

        if(bDisable)
            ComboName = "xGame.Combo";

        ComboList[i] = class<Combo>(DynamicLoadObject(ComboName, class'Class'));
        if(ComboList[i] == None)
            log("Could not find combo:"@ComboName, '3SPN');
    }
}

function ServerViewNextPlayer()
{
    local Controller C, Pick;
    local bool bFound, bRealSpec, bWasSpec;
	local TeamInfo RealTeam;

    bRealSpec = PlayerReplicationInfo.bOnlySpectator;
    bWasSpec = (ViewTarget != Pawn) && (ViewTarget != self);
    PlayerReplicationInfo.bOnlySpectator = true;
    RealTeam = PlayerReplicationInfo.Team;

    // view next player
    for ( C=Level.ControllerList; C!=None; C=C.NextController )
    {
		if ( bRealSpec && (C.PlayerReplicationInfo != None) ) // hack fix for invasion spectating
			PlayerReplicationInfo.Team = C.PlayerReplicationInfo.Team;
        if ( Level.Game.CanSpectate(self,bRealSpec,C) )
        {
            if ( Pick == None )
                Pick = C;
            if ( bFound )
            {
                Pick = C;
                break;
            }
            else
                bFound = ( (RealViewTarget == C) || (ViewTarget == C) );
        }
    }
    PlayerReplicationInfo.Team = RealTeam;
    SetViewTarget(Pick);
    ClientSetViewTarget(Pick);

    if(!bWasSpec)
        bBehindView = false;

    if((bRealSpec || bWasSpec) && !Misc_BaseGRI(GameReplicationInfo).bAllowSetBehindView)
        bBehindView = false;        

    ClientSetBehindView(bBehindView);
    PlayerReplicationInfo.bOnlySpectator = bRealSpec;
}

function ClientSetBehindView(bool B)
{
    if(Misc_BaseGRI(Level.GRI) != None && !Misc_BaseGRI(GameReplicationInfo).bAllowSetBehindView && Vehicle(Pawn) == None)
        B = false;

    super.ClientSetBehindView(B);
}

state Dead
{
ignores SeePlayer, HearNoise, KilledBy, SwitchWeapon;

Begin:
    if(Misc_BaseGRI(GameReplicationInfo).bForceDeadToSpectate)
    {
        Sleep(Misc_BaseGRI(GameReplicationInfo).ForceDeadSpectateDelay);
        ServerViewNextPlayer();
        GotoState('Spectating');
    }
}

state Spectating
{
    ignores SwitchWeapon, RestartLevel, ClientRestart, Suicide,
     ThrowWeapon, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange;

    exec function Fire( optional float F )
    {
    	if(bFrozen)
	    {
		    if((TimerRate <= 0.0) || (TimerRate > 1.0))
			    bFrozen = false;
		    return;
	    }

        ServerViewNextPlayer();
    }

    // Return to spectator's own camera.
    exec function AltFire( optional float F )
    {
	    if(!PlayerReplicationInfo.bOnlySpectator && !PlayerReplicationInfo.bAdmin && Level.NetMode != NM_Standalone && GameReplicationInfo.bTeamGame)
        {
            if(ViewTarget == None)
            {
                Fire();
            }
            else if(Misc_BaseGRI(GameReplicationInfo).bAllowSetBehindView)
            {
		        ToggleBehindView();
            }
        }
	    else
	    {
        	bBehindView = false;
        	ServerViewSelf();
	    }
    }

	function Timer()
	{
    	bFrozen = false;
	}
	
    function BeginState()
    {
        if ( Pawn != None )
        {
            SetLocation(Pawn.Location);
            UnPossess();
        }
		
	    bCollideWorld = true;
	    CameraDist = Default.CameraDist;
    }

    function EndState()
    {
        PlayerReplicationInfo.bIsSpectator = false;
        bCollideWorld = false;
    }
}

function ServerChangeTeam(int Team)
{ 
  local int Adren;

  if(Team_GameBase(Level.Game)!=None && Team_GameBase(Level.Game).TournamentModule!=None)
    if(!Team_GameBase(Level.Game).TournamentModule.AllowChangeTeam(self, Team))
      return;
    
  Adren = Adrenaline;
    Super.ServerChangeTeam(Team);
  Adrenaline = Adren;

    if(Team_GameBase(Level.Game) != None && Team_GameBase(Level.Game).bRespawning)
    {
        PlayerReplicationInfo.bOutOfLives = false;
        PlayerReplicationInfo.NumLives = 1;
    }
}
//spectating player wants to become active and join the game
function BecomeActivePlayer()
{
   local bool bRespawning;
   local int TeamIdx;

	if (Role < ROLE_Authority)
		return;

	if ( !Level.Game.AllowBecomeActivePlayer(self) )
		return;

	if(!IsInState('GameEnded'))
	{
		bBehindView = false;
		FixFOV();
		ServerViewSelf();
	}
	
	PlayerReplicationInfo.bOnlySpectator = false;
	Level.Game.NumSpectators--;
	Level.Game.NumPlayers++;
	if (Level.Game.GameStats != None)
	{
		Level.Game.GameStats.ConnectEvent(PlayerReplicationInfo);
	}
	PlayerReplicationInfo.Reset();
    if(Team_GameBase(Level.Game) != None && !Team_GameBase(Level.Game).bSpecsKeepAdren)
    {
        Adrenaline = 0;
    }
	LastRezTime = Level.TimeSeconds;
	BroadcastLocalizedMessage(Level.Game.GameMessageClass, 1, PlayerReplicationInfo);

	if (Level.Game.bTeamGame)
	{
		if( Team_GameBase(Level.Game)==None || !Team_GameBase(Level.Game).AutoBalanceTeams)
			TeamIdx = int(GetURLOption("Team"));
		else
			TeamIdx = 255;
		Level.Game.ChangeTeam(self, Level.Game.PickTeam(TeamIdx, None), false);
    
    if( Team_GameBase(Level.Game)!=None && Team_GameBase(Level.Game).AutoBalanceOnJoins )
      Team_GameBase(Level.Game).ForceAutoBalance = true;
	}
	
	if(!IsInState('GameEnded'))
	{
		if (!Level.Game.bDelayedStart)
		{
			// start match, or let player enter, immediately
			Level.Game.bRestartLevel = false;  // let player spawn once in levels that must be restarted after every death
			if (Level.Game.bWaitingToStartMatch)
				Level.Game.StartMatch();
			else
				Level.Game.RestartPlayer(PlayerController(Owner));
			Level.Game.bRestartLevel = Level.Game.Default.bRestartLevel;
		}
		else
			GotoState('PlayerWaiting');
	}
	
    ClientBecameActivePlayer();

    if(Role == ROLE_Authority)
    {		
		NextRezTime = Level.TimeSeconds+2; // 2 seconds before can be resurrected

		if(!IsInState('GameEnded'))
		{
			if(Level.Game.bWaitingToStartMatch)
			{
				PlayerReplicationInfo.bOutOfLives = false;
				PlayerReplicationInfo.NumLives = 1;
			}
			else
			{
				if(Team_GameBase(Level.Game) != None)
					bRespawning = Team_GameBase(Level.Game).bRespawning;
				else if(ArenaMaster(Level.Game) != None)
					bRespawning = ArenaMaster(Level.Game).bRespawning;
				else
					return;

				PlayerReplicationInfo.bOutOfLives = !bRespawning;
				PlayerReplicationInfo.NumLives = int(bRespawning);
			}

			if(!bRespawning)
				GotoState('Spectating');
			else
				GotoState('PlayerWaiting');
		}
    }
}

function DoCombo(class<Combo> ComboClass)
{
    if(TAM_GRI(GameReplicationInfo) == None || TAM_GRI(Level.GRI).bDisableTeamCombos)
    {
        Super.DoCombo(ComboClass);
        return;
    }

    ServerDoCombo(ComboClass);
}

function bool CanDoCombo(class<Combo> ComboClass)
{
    if(Misc_BaseGRI(GameReplicationInfo) == None)
        return true;

    if(class<ComboSpeed>(ComboClass) != None)
        return (!Misc_BaseGRI(GameReplicationInfo).bDisableSpeed);
    if(class<ComboDefensive>(ComboClass) != None)
        return (!Misc_BaseGRI(GameReplicationInfo).bDisableBooster);
    if(class<ComboInvis>(ComboClass) != None)
        return (!Misc_BaseGRI(GameReplicationInfo).bDisableInvis);
    if(class<ComboBerserk>(ComboClass) != None)
        return (!Misc_BaseGRI(GameReplicationInfo).bDisableBerserk);
    if(class<NecroCombo>(ComboClass) != None)
        return (!Misc_BaseGRI(GameReplicationInfo).bDisableNecro);

    return true;
}

function ServerDoCombo(class<Combo> ComboClass)
{
    if(class<ComboBerserk>(ComboClass) != None)
        ComboClass = class<Combo>(DynamicLoadObject("WS3SPN.Misc_ComboBerserk", class'Class'));
    else if(class<ComboSpeed>(ComboClass) != None && class<Misc_ComboSpeed>(ComboClass) == None)
        ComboClass = class<Combo>(DynamicLoadObject("WS3SPN.Misc_ComboSpeed", class'Class'));

    if(Adrenaline < ComboClass.default.AdrenalineCost)
        return;

    if(!CanDoCombo(ComboClass))
        return;

    if(TAM_GRI(GameReplicationInfo) == None || TAM_GRI(Level.GRI).bDisableTeamCombos || ComboClass.default.Duration<=1)
    {
        Super.ServerDoCombo(ComboClass);
        return;
    }

    if(xPawn(Pawn) != None)
    {
        if(TAM_TeamInfo(PlayerReplicationInfo.Team) != None)
            TAM_TeamInfo(PlayerReplicationInfo.Team).PlayerUsedCombo(self, ComboClass);
        else if(TAM_TeamInfoRed(PlayerReplicationInfo.Team) != None)
            TAM_TeamInfoRed(PlayerReplicationInfo.Team).PlayerUsedCombo(self, ComboClass);
        else if(TAM_TeamInfoBlue(PlayerReplicationInfo.Team) != None)
            TAM_TeamInfoBlue(PlayerReplicationInfo.Team).PlayerUsedCombo(self, ComboClass);
        else
            log("Could not get TeamInfo for player:"@PlayerReplicationInfo.PlayerName, '3SPN');
    }
}

function ServerUpdateStatArrays(TeamPlayerReplicationInfo PRI)
{
    local Misc_PRI P;

	if(PRI!=None)
		Super.ServerUpdateStatArrays(PRI);

    P = Misc_PRI(PRI);
    if(P == None)
        return;


    MapUTCompStatsTo3SPN(P);
    ClientSendAssaultStats(P, P.Assault);
    ClientSendBioStats(P, P.Bio);
    ClientSendShockStats(P, P.Shock);
    ClientSendLinkStats(P, P.Link);
    ClientSendMiniStats(P, P.Mini);
    ClientSendFlakStats(P, P.Flak);
    ClientSendRocketStats(P, P.Rockets);
    ClientSendSniperStats(P, P.Sniper);
    ClientSendClassicSniperStats(P, P.ClassicSniper);
    ClientSendComboStats(P, P.Combo);
    ClientSendMiscStats(P, P.HeadShots, P.EnemyDamage, P.ReverseFF, P.AveragePercent, 
        P.FlawlessCount, P.OverkillCount, P.DarkHorseCount, P.HatTrickCount, P.SGDamage, P.LinkCount, P.RoxCount, P.ShieldCount, P.GrenCount, P.MinigunCount, P.ResCount);
}

function MapUTCompStatsTo3SPN(Misc_PRI P)
{
    local UTComp_PRI U;
    U = class'UTComp_Util'.static.GetUTCompPRI(P);
    if(U == None)
        return;

    //weapon fired stats were all previously handled by weapon.firemodes in 3spn
    //since we removed 3spn weapons, need to use utcomp weapon fired stats
    //all other damage related (hit, damage) is still tracked by 3spn code
    //so no need to change that

    P.Assault.Primary.Fired = U.NormalWepStatsPrim[12];
    P.Assault.Secondary.Fired = U.NormalWepStatsAlt[12];
    P.Bio.Fired = U.NormalWepStatsPrim[11];
    //P.ClassicSniper.Fired = U.NormalWepStatsPrim[5];
    P.Flak.Primary.Fired = U.NormalWepStatsPrim[7];
    P.Flak.Secondary.Fired = U.NormalWepStatsAlt[7];
    P.Mini.Primary.Fired = U.NormalWepStatsPrim[8];
    P.Mini.Secondary.Fired = U.NormalWepstatsAlt[8];
    P.Link.Primary.Fired = U.NormalWepStatsPrim[9];
    P.Link.Secondary.Fired = U.NormalWepStatsAlt[9];
    P.Rockets.Fired = U.NormalWepStatsPrim[6];
    P.Shock.Primary.Fired = U.NormalWepStatsPrim[10];
    P.Shock.Secondary.Fired = U.NormalWepStatsAlt[10];
    P.Combo.Fired = U.NormalWepStatsPrim[0];
    P.Sniper.Fired = U.NormalWepStatsPrim[5]; // shared with classic?
}

function ClientSendMiscStats(Misc_PRI P, int HS, int ED, float RFF, float AP, int FC, int OC, int DHC, int HTC, int SGD, int LinkCount, int RoxCount, int ShieldCount, int GrenCount, int MinigunCount, int ResCount)
{
    P.HeadShots = HS;
	P.EnemyDamage = ED;
	P.ReverseFF = RFF;
	P.AveragePercent = AP;
    P.FlawlessCount = FC;
	P.OverkillCount = OC;
	P.DarkHorseCount = DHC;
	P.HatTrickCount = HTC;
	P.SGDamage = SGD;
	P.LinkCount = LinkCount;
	P.RoxCount = RoxCount;
	P.ShieldCount = ShieldCount;
	P.GrenCount = GrenCount;
    P.MinigunCount = MinigunCount;
    P.ResCount = ResCount;
}

function ClientSendAssaultStats(Misc_PRI P, Misc_PRI.HitStats Assault)
{
    P.Assault.Primary.Fired     = Assault.Primary.Fired;
    P.Assault.Primary.Hit       = Assault.Primary.Hit;
    P.Assault.Primary.Damage    = Assault.Primary.Damage;
    P.Assault.Secondary.Fired   = Assault.Secondary.Fired;
    P.Assault.Secondary.Hit     = Assault.Secondary.Hit;
    P.Assault.Secondary.Damage  = Assault.Secondary.Damage;
}

function ClientSendShockStats(Misc_PRI P, Misc_PRI.HitStats Shock)
{
    P.Shock.Primary.Fired     = Shock.Primary.Fired;
    P.Shock.Primary.Hit       = Shock.Primary.Hit;
    P.Shock.Primary.Damage    = Shock.Primary.Damage;
    P.Shock.Secondary.Fired   = Shock.Secondary.Fired;
    P.Shock.Secondary.Hit     = Shock.Secondary.Hit;
    P.Shock.Secondary.Damage  = Shock.Secondary.Damage;
}

function ClientSendLinkStats(Misc_PRI P, Misc_PRI.HitStats Link)
{
    P.Link.Primary.Fired     = Link.Primary.Fired;
    P.Link.Primary.Hit       = Link.Primary.Hit;
    P.Link.Primary.Damage    = Link.Primary.Damage;
    P.Link.Secondary.Fired   = Link.Secondary.Fired;
    P.Link.Secondary.Hit     = Link.Secondary.Hit;
    P.Link.Secondary.Damage  = Link.Secondary.Damage;
}

function ClientSendMiniStats(Misc_PRI P, Misc_PRI.HitStats Mini)
{
    P.Mini.Primary.Fired     = Mini.Primary.Fired;
    P.Mini.Primary.Hit       = Mini.Primary.Hit;
    P.Mini.Primary.Damage    = Mini.Primary.Damage;
    P.Mini.Secondary.Fired   = Mini.Secondary.Fired;
    P.Mini.Secondary.Hit     = Mini.Secondary.Hit;
    P.Mini.Secondary.Damage  = Mini.Secondary.Damage;
}

function ClientSendFlakStats(Misc_PRI P, Misc_PRI.HitStats Flak)
{
    P.Flak.Primary.Fired     = Flak.Primary.Fired;
    P.Flak.Primary.Hit       = Flak.Primary.Hit;
    P.Flak.Primary.Damage    = Flak.Primary.Damage;
    P.Flak.Secondary.Fired   = Flak.Secondary.Fired;
    P.Flak.Secondary.Hit     = Flak.Secondary.Hit;
    P.Flak.Secondary.Damage  = Flak.Secondary.Damage;
}

function ClientSendRocketStats(Misc_PRI P, Misc_PRI.HitStat Rockets)
{
    P.Rockets.Fired = Rockets.Fired;
    P.Rockets.Hit = Rockets.Hit;
    P.Rockets.Damage = Rockets.Damage;
}

function ClientSendSniperStats(Misc_PRI P, Misc_PRI.HitStat Sniper)
{
    P.Sniper.Fired = Sniper.Fired;
    P.Sniper.Hit = Sniper.Hit;
    P.Sniper.Damage = Sniper.Damage;
}

function ClientSendClassicSniperStats(Misc_PRI P, Misc_PRI.HitStat ClassicSniper)
{
    P.ClassicSniper.Fired = ClassicSniper.Fired;
    P.ClassicSniper.Hit = ClassicSniper.Hit;
    P.ClassicSniper.Damage = ClassicSniper.Damage;
}

function ClientSendBioStats(Misc_PRI P, Misc_PRI.HitStat Bio)
{
    P.Bio.Fired = Bio.Fired;
    P.Bio.Hit = Bio.Hit;
    P.Bio.Damage = Bio.Damage;
}

function ClientSendComboStats(Misc_PRI P, Misc_PRI.HitStat Combo)
{
    P.Combo.Fired = Combo.Fired;
    P.Combo.Hit = Combo.Hit;
    P.Combo.Damage = Combo.Damage;
}

state GameEnded
{
    function BeginState()
    {
        Super.BeginState();

        if(Level.NetMode == NM_DedicatedServer)
            return;

        if(MyHUD != None)
        {
            //MyHUD.bShowScoreBoard = false;
            MyHUD.bShowScoreBoard = true;
            MyHUD.bShowLocalStats = false;
        }

		bBehindView = true;
		ClientSetBehindView(true);
		
        //SetTimer(1.0, false);
        SetTimer(0.1, false);
    }

    function Timer()
    {
		if(class'Misc_Player'.default.bAutoScreenShot && !bShotTaken)
            TakeShot();

        Super.Timer();
	}			
}

function BecomeSpectator()
{
	local Misc_PlayerDataManager_ServerLink PlayerDataManager_ServerLink;
	
	if (Role < ROLE_Authority)
		return;

	if ( !Level.Game.BecomeSpectator(self) )
		return;

	if ( Pawn != None )
		Pawn.Died(self, class'DamageType', Pawn.Location);

	if ( PlayerReplicationInfo.Team != None )
		PlayerReplicationInfo.Team.RemoveFromTeam(self);
	PlayerReplicationInfo.Team = None;

	PlayerDataManager_ServerLink = GetPlayerDataManager_ServerLink();
	if(PlayerDataManager_ServerLink!=None)
		PlayerDataManager_ServerLink.PlayerLeft(self);
		
	ServerSpectate();
	BroadcastLocalizedMessage(Level.Game.GameMessageClass, 14, PlayerReplicationInfo);

	ClientBecameSpectator();
}

function ServerSpectate()
{
	// Proper fix for phantom pawns

	if (Pawn != none && !Pawn.bDeleteMe)
	{
		Pawn.Died(self, class'DamageType', Pawn.Location);
	}

	if(!IsInState('GameEnded'))
	{
		GotoState('Spectating');
		bBehindView = true;	
		ServerViewNextPlayer();
	}
}

function ClientSetWeapon( class<Weapon> WeaponClass )
{
	Log("ClientSetWeapon "$string(WeaponClass.name));
	Super.ClientSetWeapon(WeaponClass);
}

/* exec functions */
exec function Suicide()
{
    if(Pawn != None)
        Pawn.Suicide();
}

function TakeShot()
{
    if(GameReplicationInfo.bTeamGame)
        ConsoleCommand("shot TAM-"$Left(string(Level), InStr(string(Level), "."))$"-"$Level.Month$"-"$Level.Day$"-"$Level.Hour$"-"$Level.Minute);
    else
        ConsoleCommand("shot AM-"$Left(string(Level), InStr(string(Level), "."))$"-"$Level.Month$"-"$Level.Day$"-"$Level.Hour$"-"$Level.Minute);
    bShotTaken = true;
}

function ServerSay(string Msg)
{
  local bool isAdmin; //pass player admin status if they say 'teams'
  
  Super.ServerSay(Msg);
  
  if(Msg ~= "teams" || Msg ~= "teens")
  {
      isAdmin = False;

      if(PlayerReplicationInfo != None)
          isAdmin = PlayerReplicationInfo.bAdmin;

      if(Team_GameBase(Level.Game) != None)
         Team_GameBase(Level.Game).QueueAutoBalance(isAdmin);
  }
}

exec function Menu3SPN()
{
	local Rotator r;

	r = GetViewRotation();
	r.Pitch = 0;
	SetRotation(r);

	ClientOpenMenu("WS3SPN.Menu_Menu3SPN");
}

exec function ToggleTeamInfo()
{
    class'Misc_Player'.default.bShowTeamInfo = !class'Misc_Player'.default.bShowTeamInfo;
    class'Misc_Player'.static.StaticSaveConfig();
}

exec function BehindView(bool b)
{
	if((PlayerReplicationInfo.bOnlySpectator && Misc_BaseGRI(GameReplicationInfo).bAllowSetBehindView) 
        || (Pawn == None && !Misc_BaseGRI(GameReplicationInfo).bEndOfRound) 
        || PlayerReplicationInfo.bAdmin 
        || Level.NetMode == NM_Standalone)
		Super.BehindView(b);
	else
		Super.BehindView(false);
}

exec function ToggleBehindView()
{
	if((PlayerReplicationInfo.bOnlySpectator && Misc_BaseGRI(GameReplicationInfo).bAllowSetBehindView) 
        || (Pawn == None && !Misc_BaseGRI(GameReplicationInfo).bEndOfRound) 
        || PlayerReplicationInfo.bAdmin 
        || Level.NetMode == NM_Standalone)
		Super.ToggleBehindView();
	else
		Super.BehindView(false);
}

exec function DisableCombos(bool s, bool b, bool be, bool i, optional bool r, optional bool a)
{
    class'Misc_Player'.default.bDisableRadar = r;
    class'Misc_Player'.default.bDisableAmmoRegen = a;

    SetupCombos();
}

exec function UseSpeed()
{
    if(Adrenaline < class'ComboSpeed'.default.AdrenalineCost)
        return;

    DoCombo(class'ComboSpeed');
}

exec function UseBooster()
{
    if(Adrenaline < class'ComboDefensive'.default.AdrenalineCost)
        return;

    DoCombo(class'ComboDefensive');
}

exec function UseInvis()
{
    if(Adrenaline < class'ComboInvis'.default.AdrenalineCost)
        return;

    DoCombo(class'ComboInvis');
}

exec function UseBerserk()
{
    if(Adrenaline < class'ComboBerserk'.default.AdrenalineCost)
        return;

    DoCombo(class'ComboBerserk');
}

exec function UseNecro()
{
    if(Adrenaline < class'NecroCombo'.default.AdrenalineCost)
        return;

    DoCombo(class'NecroCombo');
}

exec function CallTimeout()
{
    ServerCallTimeout();
}

function ServerCallTimeout()
{
    if(Team_GameBase(Level.Game) != None)
        Team_GameBase(Level.Game).CallTimeout(self);
}
/* exec functions */

/* colored names */

simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType )
{
	local Class<LocalMessage> LocalMessageClass2;

	switch( MsgType )
	{
		case 'Say':
			if ( PRI == None )
				return;

            if(Misc_PRI(PRI)==None || Misc_PRI(PRI).GetColoredName()=="")
               Msg = PRI.PlayerName$": "$Msg;
            else if(!PRI.bOnlySpectator && PRI.Team!=None && PRI.Team.TeamIndex == 0)
               Msg = Misc_PRI(PRI).GetColoredName()$class'Misc_Util'.Static.MakeColorCode(class'Misc_Player'.default.RedMessageColor)$": "$Msg;
			else if(!PRI.bOnlySpectator && PRI.Team!=None && PRI.Team.TeamIndex == 1)
			   Msg = Misc_PRI(PRI).GetColoredName()$class'Misc_Util'.Static.MakeColorCode(class'Misc_Player'.default.BlueMessageColor)$": "$Msg;
			else
               Msg = Misc_PRI(PRI).GetColoredName()$class'Misc_Util'.Static.MakeColorCode(class'Misc_Player'.default.YellowMessageColor)$": "$Msg;
			LocalMessageClass2 = class'SayMessagePlus';
            break;

		case 'TeamSay':
            if ( PRI == None )
				return;
			if(Misc_PRI(PRI)==None || Misc_PRI(PRI).GetColoredName()=="")
               Msg = PRI.PlayerName$"("$PRI.GetLocationName()$"): "$Msg;
			else
			   Msg = Misc_PRI(PRI).GetColoredName()$class'Misc_Util'.Static.MakeColorCode(class'Misc_Player'.default.GreenMessageColor)$"("$PRI.GetLocationName()$"): "$Msg;
			LocalMessageClass2 = class'TeamSayMessagePlus';
            break;
			
		case 'CriticalEvent':
			LocalMessageClass2 = class'CriticalEventPlus';
			myHud.LocalizedMessage( LocalMessageClass2, 0, None, None, None, Msg );
			return;
			
		case 'DeathMessage':
			LocalMessageClass2 = class'xDeathMessage';
			break;
			
		default:
			LocalMessageClass2 = class'StringMessagePlus';
			break;
	}
	
    if(myHud!=None)
		myHud.AddTextMessage(Msg,LocalMessageClass2,PRI);
}

simulated function ReloadDefaults()
{
	
	bShowCombos = class'Misc_Player'.default.bShowCombos;
	bDisableSpeed = class'Misc_Player'.default.bDisableSpeed;
	bDisableInvis = class'Misc_Player'.default.bDisableInvis;
	bDisableBooster = class'Misc_Player'.default.bDisableBooster;
	bDisableBerserk = class'Misc_Player'.default.bDisableBerserk;
	bDisableRadar = class'Misc_Player'.default.bDisableRadar;
	bDisableAmmoRegen = class'Misc_Player'.default.bDisableAmmoRegen;
	
	bShowTeamInfo = class'Misc_Player'.default.bShowTeamInfo;
	bExtendedInfo = class'Misc_Player'.default.bExtendedInfo;	
	
    DamageIndicatorType = class'Misc_Player'.default.DamageIndicatorType;
    ReceiveAwardType = class'Misc_Player'.default.ReceiveAwardType;
	bDisableAnnouncement = class'Misc_Player'.default.bDisableAnnouncement;
	bAutoScreenShot = class'Misc_Player'.default.bAutoScreenShot;
	
	bAnnounceOverkill = class'Misc_Player'.default.bAnnounceOverkill;
	SoundAlone = class'Misc_Player'.default.SoundAlone; 
	SoundAloneVolume = class'Misc_Player'.default.SoundAloneVolume;
    SoundSpawnProtection = class'Misc_Player'.default.SoundSpawnProtection;
	SoundTMDeath = class'Misc_Player'.default.SoundTMDeath;
	SoundUnlock = class'Misc_Player'.default.SoundUnlock;
	
	ShowInitialMenu = class'Misc_Player'.default.ShowInitialMenu;
	Menu3SPNKey = class'Misc_Player'.default.Menu3SPNKey;
	bDisableEndCeremonySound = class'Misc_Player'.default.bDisableEndCeremonySound;
	
    bConfigureNetSpeed = class'Misc_Player'.default.bConfigureNetSpeed;
    ConfigureNetSpeedValue = class'Misc_Player'.default.ConfigureNetSpeedValue;

    AbortNecroSoundType = class'Misc_Player'.default.AbortNecroSoundType;
    bShowSpectators = class'Misc_Player'.default.bShowSpectators;
    bKillingSpreeCheers = class'Misc_Player'.default.bKillingSpreeCheers;
    bUseEloScoreboard = class'Misc_Player'.default.bUseEloScoreboard;
}

function ServerReportNewNetStats(bool enable)
{
  bReportNewNetStats = enable;
}


function NotifyServerStartFire(float ClientTimeStamp, float ServerTimeStamp, float AverDT)
{
  local Color  color;
  local string Text, Number;
  
  color = class'Canvas'.static.MakeColor(100, 100, 210);
  Text = class'DMStatsScreen'.static.MakeColorCode(color);

  color = class'Canvas'.static.MakeColor(210, 0, 0);
  Number = class'DMStatsScreen'.static.MakeColorCode(color);
  
  if(!bReportNewNetStats)
    return;
    
  ClientMessage("StartFire: "$Text$"Delta="$Number$ClientTimeStamp-ServerTimeStamp$Text$" ClientTS="$Number$ClientTimeStamp$Text$" ServerTS="$Number$ServerTimeStamp$Text$" AverDT="$Number$AverDT$Text);
}

function bool WantsSmoothedView()
{
    if (Pawn == none) return false;

    return
        (((Pawn.Physics == PHYS_Walking) || (Pawn.Physics == PHYS_Spider)) && Pawn.bJustLanded == false) ||
        (Pawn.Physics == PHYS_Falling && Misc_Pawn(Pawn).OldPhysics2 == PHYS_Walking);
}

state PlayerSwimming {
ignores SeePlayer, HearNoise, Bump;

    function bool WantsSmoothedView()
    {
        return ( !Pawn.bJustLanded );
    }
}


simulated function SetInitialNetSpeed()
{
    local int netspeed;
    local bool bConfigure;
    if(Role < ROLE_Authority)
    {
        netspeed = class'Misc_Player'.default.ConfigureNetSpeedValue;
        bConfigure = class'Misc_Player'.default.bConfigureNetSpeed;
        if(bConfigure)
        {
            SetNetSpeed(netspeed);
        }
    }
}

simulated function AbortNecro()
{
    local float rnd;
    local Sound soundToPlay;

    if(AbortNecroSoundType == ANS_None)
        return;

    switch(AbortNecroSoundType)
    {
        case ANS_Buzz:
            soundToPlay=Sound'ShortCircuit';
        break;
        case ANS_Fart:
            soundToPlay=Sound'Fart';
        break;
        case ANS_Meow:
            rnd = FRand();
            if(rnd < 0.33)
                soundToPlay = Sound'Meow1';
            else if(rnd < 0.66)
                soundToPlay = Sound'Meow2';
            else
                soundToPlay = Sound'Meow3';
        break;
    }

    ClientPlaySound(soundToPlay, false, 300.0, SLOT_None);
}

function ServerPlaySound(Sound S, Pawn P)
{
    P.PlaySound(S, SLOT_None, 600.0);
}

// this can be used to call base consolecommand for overridden commands
function ProxyCommand(string command)
{
    local PlayerController PC;
    PC = spawn(class'PlayerController');
    PC.ConsoleCommand(command);
    PC.Destroy();
    PC=None;
}

exec function PauseSounds() 
{ 
    local Misc_BaseGRI GRI;
    GRI=Misc_BaseGRI(Level.GRI);
    if(GRI != None && GRI.bAllowPauseSounds)
    {
        ProxyCommand("pausesounds");
    }
    else
    {
        ClientPlaySound(Sound'Fart');
    }
}

exec function UnPauseSounds() 
{ 
    local Misc_BaseGRI GRI;
    GRI=Misc_BaseGRI(Level.GRI);
    if(GRI != None && GRI.bAllowPauseSounds)
    {
        ProxyCommand("unpausesounds");
    }
    else
    {
        ClientPlaySound(Sound'Fart');
    }
}

exec function StopSounds() 
{ 
    local Misc_BaseGRI GRI;
    GRI=Misc_BaseGRI(Level.GRI);
    if(GRI != None && GRI.bAllowPauseSounds)
    {
        ProxyCommand("stopsounds");
    }
    else
    {
        ClientPlaySound(Sound'Fart');
    }
}

exec function passpause(string pass)
{
    ServerPausePass(self, pass);
}

function ServerPausePass(PlayerController PC, string pass)
{
    local bool bPause;
    local bool bCanPause;

    if(Role == ROLE_Authority
    && Team_GameBase(Level.Game) != none 
    && Team_GameBase(level.Game).bEnablePasswordPause
    && Team_GameBase(Level.Game).PasswordPausePassword != "")
    {
        if(pass == Team_GameBase(Level.Game).PasswordPausePassword)
        {
            bPause = Level.Pauser == None;
            bCanPause = Level.Game.bPauseable;
            Level.Game.bPauseable = true;
            Level.Game.SetPause(bPause, PC);
            Level.Game.bPauseable = bCanPause;
        }
    }
}

// Reset TAM stats when UTComp stats get reset (warmup etc)
simulated function ResetUTCompStats()
{
    super.ResetUTCompStats();
    If(Misc_PRI(PlayerReplicationInfo) != None)
        Misc_PRI(PlayerReplicationInfo).ResetStats();
}

simulated function bool IsGroupedDamageType(class<DamageType> DamageType)
{
    return DamageType == class'DamType_FlakChunk'
        || DamageType == class'DamType_FlakShell'
        || DamageType == class'DamType_Rocket'
        || DamageType == class'DamType_RocketHoming'
        || DamageType == class'DamType_SniperShot'
        || super.IsGroupedDamageType(DamageType);
}

simulated function InitializeScoreboard()
{
    //override base UTComp
}

/* settings */

defaultproperties
{
     bShowCombos=True
     bShowTeamInfo=True
     bExtendedInfo=True
     DamageIndicatorType=1
     bAnnounceOverkill=True
     SoundAlone=Sound'WS3SPN.Sounds.alone'
     SoundAloneVolume=1.000000
     SoundUnlock=Sound'NewWeaponSounds.Newclickgrenade'
     SoundSpawnProtection=Sound'WS3SPN.Sounds.Bleep'
     ShowInitialMenu=2
     Menu3SPNKey=IK_F7
     EndCeremonyAnimNames(0)="gesture_point"
     EndCeremonyAnimNames(1)="gesture_beckon"
     EndCeremonyAnimNames(2)="gesture_halt"
     EndCeremonyAnimNames(3)="gesture_cheer"
     EndCeremonyAnimNames(4)="PThrust"
     EndCeremonyAnimNames(5)="AssSmack"
     EndCeremonyAnimNames(6)="ThroatCut"
     EndCeremonyAnimNames(7)="Specific_1"
     EndCeremonyAnimNames(8)="Gesture_Taunt01"
     EndCeremonyWeaponNames(0)="XWeapons.ShockRifle"
     EndCeremonyWeaponNames(1)="XWeapons.LinkGun"
     EndCeremonyWeaponNames(2)="XWeapons.MiniGun"
     EndCeremonyWeaponNames(3)="XWeapons.FlakCannon"
     EndCeremonyWeaponNames(4)="XWeapons.RocketLauncher"
     EndCeremonyWeaponNames(5)="XWeapons.SniperRifle"
     EndCeremonyWeaponNames(6)="XWeapons.BioRifle"
     EndCeremonyWeaponNames(7)="UTClassic.ClassicSniperRifle"
     EndCeremonyWeaponClasses(0)=Class'XWeapons.ShockRifle'
     EndCeremonyWeaponClasses(1)=Class'XWeapons.LinkGun'
     EndCeremonyWeaponClasses(2)=Class'XWeapons.Minigun'
     EndCeremonyWeaponClasses(3)=Class'XWeapons.FlakCannon'
     EndCeremonyWeaponClasses(4)=Class'XWeapons.RocketLauncher'
     EndCeremonyWeaponClasses(5)=Class'XWeapons.SniperRifle'
     EndCeremonyWeaponClasses(6)=Class'XWeapons.BioRifle'
     EndCeremonyWeaponClasses(7)=Class'UTClassic.ClassicSniperRifle'
     WhiteMessageColor=(B=200,G=200,R=200,A=200)
     WhiteColor=(B=255,G=255,R=255,A=255)
     PlayerReplicationInfoClass=Class'WS3SPN.Misc_PRI'
     Adrenaline=0.100000
     AdrenalineMax=120.000000
     ReceiveAwardType=RAT_All
     bConfigureNetSpeed=false
     ConfigureNetSpeedValue=15000

     bShowSpectators=true
     bKillingSpreeCheers=true
     bUseEloScoreboard=true

     AbortNecroSoundType=ANS_Meow
}
