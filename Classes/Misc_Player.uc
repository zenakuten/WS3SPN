class Misc_Player extends ModernPlayer dependson(Misc_PlayerSettings) dependson(TAM_Mutator);

#exec AUDIO IMPORT FILE=Sounds\alone.wav     	    GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\hitsound.wav         GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\Bleep.wav            GROUP=Sounds

/* Combo related */
var config bool bShowCombos;            // show combos on the HUD

var config bool bDisableSpeed;
var config bool bDisableInvis;
var config bool bDisableBooster;
var config bool bDisableBerserk;
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

var config bool bMatchHUDToSkins;       // sets HUD color to brightskins color
/* HUD related */

/* brightskins related */
var config bool bUseBrightSkins;        // self-explanatory
var config bool bUseTeamColors;         // use red and blue for brightkins
var config Color RedOrEnemy;            // brightskin color for the red or enemy team
var config Color BlueOrAlly;            // brightskin color for the blue or own team
var config Color Yellow;                // brightskin color for spawn protection
/* brightskins related */

/* model related */
var config bool bForceRedEnemyModel;    // force a model for the red/enemy team
var config bool bForceBlueAllyModel;    // force a model for the blue/ally team
var config bool bUseTeamModels;         // force models by team color (opposed to enemy/ally)
var config string RedEnemyModel;        // character name for the red team's model
var config string BlueAllyModel;        // character name for the blue team's model
/* model related */

/* misc related */
var bool bAdminVisionInSpec;
var bool bDrawTargetingLineInSpec;
var bool bReportNewNetStats;

var int  Spree;                         // kill count at new round
var bool bFirstOpen;                    // used by the stat screen

var float NewFriendlyDamage;            // friendly damage done
var float NewEnemyDamage;               // enemy damage done

var int LastDamage;

var int SumDamage;
var float SumDamageTime;

var config bool bDisableAnnouncement;
var config bool bAutoScreenShot;
var bool bShotTaken;

var bool bSeeInvis;

var Pawn OldPawn;
/* misc related */

/* sounds */
var config bool  bAnnounceOverkill;
var config bool  bUseHitsounds;

var config Sound SoundHit;
var config Sound SoundHitFriendly;
var config float SoundHitVolume;

var Sound ServerSoundAlone;
var config Sound SoundAlone;
var config float SoundAloneVolume;

var config Sound SoundTMDeath;

var config Sound SoundUnlock;

var Sound ServerSoundSpawnProtection;
var config Sound SoundSpawnProtection;
/* sounds */

/* newnet */
var config bool bEnableEnhancedNetCode;
/* newnet */

var config int ShowInitialMenu;
var config Interactions.EInputKey Menu3SPNKey;

var config bool bDisableEndCeremonySound;

var config bool bEnableWidescreenFix;

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

/* persistent stats */
var float LoginTime;
var Misc_PlayerData PlayerData;
var bool ActiveThisRound;
/* persistent stats */

var float NextRezTime;
var float LastRezTime;

/* colored names */
var bool PlayerInitialized;

var Color RedMessageColor;
var Color GreenMessageColor;
var Color BlueMessageColor;
var Color YellowMessageColor;
var Color WhiteMessageColor;
var Color WhiteColor;

var config bool bAllowColoredMessages;
var config bool bEnableColoredNamesInTalk;
var config bool bEnableColoredNamesOnEnemies;

var config int CurrentSelectedColoredName;
var config color ColorName[20];

struct ColoredNamePair
{
    var color SavedColor[20];
    var string SavedName;
};
var config array<ColoredNamePair> ColoredName;
/* colored names */

var config bool bUseNewEyeHeightAlgorithm;

/* persistent settings */
var config bool AutoSyncSettings;
var float LastSettingsLoadTimeSeconds;
var float LastSettingsSaveTimeSeconds;
/* persistent settings */

var config bool bConfigureNetSpeed;
var config int ConfigureNetSpeedValue;

//var config int DesiredNetUpdateRate;
//var transient PlayerInput PlayerInput2;
//var float TimeBetweenUpdates;

var config bool bTeamColorRockets;
var config bool bTeamColorBio;
var config bool bTeamColorFlak;
var config bool bTeamColorShock;
var config bool bTeamColorSniper;
var config Color TeamColorRed, TeamColorBlue;
var config bool bTeamColorUseTeam;

//var config bool bEnableDodgeFix;

var transient float PitchFraction, YawFraction;
var AudioSubsystem AudioSubsystem;
var int LastNetSpeed;

var float BufferedClickTimer; 
var Actor.eDoubleClickDir BufferedClickDir;

//used by hud menu
var EmoticonsReplicationInfo EmoteInfo;
var config bool bEnableEmoticons;

//used for challenge mode
var bool bWasBalanced;

/* persistent stats */
delegate OnPlayerDataReceivedCallback(string PlayerName, string OwnerID, int LastActiveTime, int Score, int Kills, int Thaws, int Deaths);
delegate OnPlayerDataRemovedCallback(string PlayerName);
/* persistent stats */


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
        ReceiveAwardMessage, AbortNecro, EmoteInfo;
        //TimeBetweenUpdates;

    reliable if(bNetDirty && Role == ROLE_Authority)
        bSeeInvis;

    reliable if( Role==ROLE_Authority && !bDemoRecording )
        PlayCustomRewardAnnouncement, PlayStatusAnnouncementReliable;
        
    reliable if(Role < ROLE_Authority)
        ServerSetMapString, ServerCallTimeout,
		SetNetCodeDisabled, SetTeamScore,
		ServerLoadSettings, ServerSaveSettings, ServerReportNewNetStats,ServerSetEyeHeightAlgorithm,
        ServerPlaySound, ServerPausePass;
        
        //ServerSetNetUpdateRate, ServerPlaySound;
  
    //unreliable if (Role < ROLE_Authority)
    //    UTComp_ServerMove, UTComp_DualServerMove, UTComp_ShortServerMove;		

	reliable if(Role == ROLE_Authority)
		ClientSettingsResult, ClientLoadSettings;
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
    local inventory inv;

	class'Misc_Player'.default.bEnableEnhancedNetCode = false;
	
    if(Pawn == none)
       return;

	for(inv = Pawn.Inventory; inv!=None; inv=inv.inventory)
	{
		if(Weapon(inv)!=None)
		{
			  if(NewNet_AssaultRifle(Inv)!=None)
				  NewNet_AssaultRifle(Inv).DisableNet();
			   else if( NewNet_BioRifle(Inv)!=None)
				  NewNet_BioRifle(Inv).DisableNet();
			   else if(NewNet_ShockRifle(Inv)!=None)
				  NewNet_ShockRifle(Inv).DisableNet();
			   else if(NewNet_MiniGun(Inv)!=None)
				  NewNet_MiniGun(Inv).DisableNet();
			   else if(NewNet_LinkGun(Inv)!=None)
				  NewNet_LinkGun(Inv).DisableNet();
			   else if(NewNet_RocketLauncher(Inv)!=None)
				  NewNet_RocketLauncher(inv).DisableNet();
			   else if(NewNet_FlakCannon(inv)!=None)
				  NewNet_FlakCannon(inv).DisableNet();
			   else if(NewNet_SniperRifle(inv)!=None)
				  NewNet_SniperRifle(inv).DisableNet();
			   else if(NewNet_ClassicSniperRifle(inv)!=None)
				  NewNet_ClassicSniperRifle(inv).DisableNet();
		}
	}
}

simulated static function bool UseNewNet()
{
    return class'Misc_Player'.default.bEnableEnhancedNetCode;
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

function CheckInitialMenu()
{
	if(Level.NetMode!=NM_DedicatedServer && class'Misc_Player'.default.ShowInitialMenu==0)
	{
		if(PlayerReplicationInfo==None || PlayerReplicationInfo.PlayerName==class'GameInfo'.Default.DefaultPlayerName)
			return;
	
		class'Misc_Player'.default.ShowInitialMenu=1;
		LoadSettings();
		class'Misc_Player'.static.StaticSaveConfig();
	}
}

function PlayerTick(float DeltaTime)
{
    local int Damage;
    local Misc_Pawn MPawn;
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
	    SetEyeHeightAlgorithm(class'Misc_Player'.default.bUseNewEyeHeightAlgorithm);
        SetInitialColoredName();
        SetInitialNetSpeed();
        //ServerSetNetUpdateRate(Class'Misc_Player'.Default.DesiredNetUpdateRate,Player.CurrentNetSpeed);
		PlayerInitialized = true;
	}

    //enforce netspeed
    if (Level.NetMode == NM_Client && Misc_BaseGRI(Level.GRI) != none) 
    {
        if (Player.CurrentNetSpeed > Misc_BaseGRI(Level.GRI).MaxNetSpeed)
        {
            SetNetSpeed(Misc_BaseGRI(Level.GRI).MaxNetSpeed);
        }
        else if (Player.CurrentNetSpeed < Misc_BaseGRI(Level.GRI).MinNetSpeed)
        {
            SetNetSpeed(Misc_BaseGRI(Level.GRI).MinNetSpeed);
        }
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

    // update timeBetweenUpdates if netspeed changes
    /*
    if(LastNetSpeed != Player.CurrentNetSpeed)
    {
        ServerSetNetUpdateRate(DesiredNetUpdateRate,Player.CurrentNetSpeed);
        LastNetSpeed = Player.CurrentNetSpeed;
    }
    */
	
	if(EndCeremonyStarted)
	{
		UpdateEndCeremony(DeltaTime);
		return;
	}

    // begin hitsounds/damage indicators
    MPawn = Misc_Pawn(Pawn);
    if(MPawn == None)
    {
        MPawn = Misc_Pawn(ViewTarget);
    }

    if(MPawn == None)
    {
        LastDamage = 0;
        return;
    }

    if(MPawn.HitDamage != LastDamage)
    {
        Damage = MPawn.HitDamage - LastDamage;

        if(MPawn.bHitContact && bUseHitsounds)
        {
            if(MPawn.HitDamage < LastDamage)
                MPawn.PlaySound(soundHitFriendly,, soundHitVolume,,,(48 / (-Damage)), false);
            else
                MPawn.PlaySound(soundHit,, soundHitVolume,,,(48 / Damage), false);
        }
            
        if(MPawn.HitPawn != None && Misc_BaseGRI(GameReplicationInfo).bDamageIndicator)
        {
            if (DamageIndicatorType == 2)
            {
                if ( (Level.TimeSeconds - SumDamageTime > 1) || (SumDamage > 0 ^^ Damage > 0) )
                    SumDamage = 0;
                SumDamage += Damage;
                SumDamageTime = Level.TimeSeconds;
            }
            
            if(DamageIndicatorType == 3)
                class'Emitter_Damage'.static.ShowDamage(MPawn.HitPawn, MPawn.HitPawn.Location, Damage);        
        }        

        LastDamage = MPawn.HitDamage;
    }
    // end hitsounds/damage indicators
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
			
			Misc_Pawn(P).Setup(class'xUtil'.static.FindPlayerRecord(EndCeremonyInfo[i].CharacterName), true);
			i2 = Rand(EndCeremonyWeaponNames.Length); 
			Misc_Pawn(P).GiveWeapon(EndCeremonyWeaponNames[i2]);
			Misc_Pawn(P).PendingWeapon = Weapon(Misc_Pawn(P).FindInventoryType(EndCeremonyWeaponClasses[i2]));
			Misc_Pawn(P).ChangedWeapon();			
			Misc_Pawn(P).SetBrightSkin(EndCeremonyInfo[i].PlayerTeam);
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

    Misc_Pawn(Pawn).GiveWeaponClass(WeaponClass);

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

    // enforce max value from server for saved moves
    if(Misc_BaseGRI(Level.GRI) != None)
        MaxSavedMoves = Min(Misc_BaseGRI(Level.GRI).MaxSavedMoves, MaxSavedMoves);
}

simulated function InitInputSystem()
{
	local PlayerController C;

	Super.InitInputSystem();
	
	C = Level.GetLocalPlayerController();
	if(C != None)
	{
		C.Player.InteractionMaster.AddInteraction("3SPNvSoL.Menu_Interaction", C.Player);
	}

    /*
    if ((Level.GRI != None) && (Misc_BaseGRI(Level.GRI).UseNetUpdateRate))
	{
        // UTCOMP movement
        FindPlayerInput();
	}
    */

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
        else if(ComboName ~= "3SPNvSoL.NecroCombo")
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

event ClientSetViewTarget(Actor a)
{
    super.ClientSetViewTarget(a);
    if(Misc_Pawn(A) != None)
    {
        LastDamage = Misc_Pawn(A).HitDamage;
    }
}

state Dead
{
ignores SeePlayer, HearNoise, KilledBy, SwitchWeapon;

Begin:
    if(Misc_BaseGRI(GameReplicationInfo).bForceDeadToSpectate)
    {
        Sleep(Misc_BaseGRI(GameReplicationInfo).ForceDeadSpectateDelay);
        ServerViewNextPlayer();
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
	Adrenaline = 0;
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

    if(Role == Role_Authority)
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
        ComboClass = class<Combo>(DynamicLoadObject("3SPNvSoL.Misc_ComboBerserk", class'Class'));
    else if(class<ComboSpeed>(ComboClass) != None && class<Misc_ComboSpeed>(ComboClass) == None)
        ComboClass = class<Combo>(DynamicLoadObject("3SPNvSoL.Misc_ComboSpeed", class'Class'));

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
        P.FlawlessCount, P.OverkillCount, P.DarkHorseCount, P.HatTrickCount, P.SGDamage, P.LinkCount, P.RoxCount, P.ShieldCount, P.GrenCount, P.MinigunCount);
}

function ClientSendMiscStats(Misc_PRI P, int HS, int ED, float RFF, float AP, int FC, int OC, int DHC, int HTC, int SGD, int LinkCount, int RoxCount, int ShieldCount, int GrenCount, int MinigunCount)
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

exec function SetSkins(byte r1, byte g1, byte b1, byte r2, byte g2, byte b2, byte r3, byte g3, byte b3)
{
    class'Misc_Player'.default.RedOrEnemy.R = Clamp(r1, 0, 100);
    class'Misc_Player'.default.RedOrEnemy.G = Clamp(g1, 0, 100);
    class'Misc_Player'.default.RedOrEnemy.B = Clamp(b1, 0, 100);

    class'Misc_Player'.default.BlueOrAlly.R = Clamp(r2, 0, 100);
    class'Misc_Player'.default.BlueOrAlly.G = Clamp(g2, 0, 100);
    class'Misc_Player'.default.BlueOrAlly.B = Clamp(b2, 0, 100);

    class'Misc_Player'.default.Yellow.R = Clamp(r3, 0, 100);
    class'Misc_Player'.default.Yellow.G = Clamp(g3, 0, 100);
    class'Misc_Player'.default.Yellow.B = Clamp(b3, 0, 100);

    class'Misc_Player'.static.StaticSaveConfig();
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

	ClientOpenMenu("3SPNvSoL.Menu_Menu3SPN");
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
    class'Misc_Player'.default.bDisableSpeed = s;
    class'Misc_Player'.default.bDisableBooster = b;
    class'Misc_Player'.default.bDisableBerserk = be;
    class'Misc_Player'.default.bDisableInvis = i;
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

event TeamMessage( PlayerReplicationInfo PRI, coerce string S, name Type  )
{
	local string c;
    local int k;
	
	// Wait for player to be up to date with replication when joining a server, before stacking up messages
	if ( Level.NetMode == NM_DedicatedServer || GameReplicationInfo == None )
		return;

	if( AllowTextToSpeech(PRI, Type) )
		TextToSpeech( S, TextToSpeechVoiceVolume );
	if ( Type == 'TeamSayQuiet' )
		Type = 'TeamSay';

    //replace the color codes
    if(class'Misc_Player'.default.bAllowColoredMessages)
    {
       for(k=7; k>=0; k--)
       {
          S=Repl(S, "^"$k, class'Misc_Util'.static.ColorReplace(k));
       }
       S=Repl(S, "^r", class'Misc_Util'.static.RandomColor());
    }
    else
    {
       for(k=7; k>=0; k--)
       {
          S=Repl(S, "^"$k, "");
       }
       S=Repl(S, "^r", "");
    }
    if ( myHUD != None )
	{   if (class'Misc_Player'.default.bEnableColoredNamesInTalk)
    	   Message( PRI, c$S, Type );
    	else 
			myHud.Message( PRI, c$S, Type );
    }
	if ( (Player != None) && (Player.Console != None) )
	{
		if ( PRI!=None )
		{
			if ( PRI.Team!=None && GameReplicationInfo.bTeamGame)
			{
    			if (PRI.Team.TeamIndex==0)
					c = chr(27)$chr(200)$chr(1)$chr(1);
    			else if (PRI.Team.TeamIndex==1)
        			c = chr(27)$chr(125)$chr(200)$chr(253);
			}
            S = PRI.PlayerName$": "$S;
		}
		Player.Console.Chat( c$s, 6.0, PRI );
	}
}

simulated function SetColoredNameOldStyle(optional string S2, optional bool bShouldSave)
{
    local string S;
    local byte k;
    local byte numdoatonce;
    local byte m;

    if(Level.NetMode==NM_DedicatedServer || PlayerReplicationInfo==None)
        return;

    if(S2=="")
       S2=PlayerReplicationInfo.PlayerName;
	
    for(k=1; k<=Len(S2); k++)
    {
        numdoatonce=1;
        for(m=k;m<Len(S2)&& class'Misc_Player'.default.ColorName[k-1] == class'Misc_Player'.default.ColorName[m] ;m++)
        {
             numdoatonce++;
             k++;
        }
		if(numdoatonce!=Len(S2) || class'Misc_Player'.default.ColorName[k-1]!=WhiteColor)
			S=S$class'Misc_Util'.Static.MakeColorCode(class'Misc_Player'.default.ColorName[k-1])$Right(Left(S2, k), numdoatonce);
    }	
	
    if(Misc_PRI(PlayerReplicationInfo)!=None)
        Misc_PRI(PlayerReplicationInfo).SetColoredName(S);
}

simulated function SetColoredNameOldStyleCustom(optional string S2, optional int CustomColors)
{
    local string S;
    local byte k;
    local byte numdoatonce;
    local byte m;

    if(Level.NetMode==NM_DedicatedServer || PlayerReplicationInfo==None)
        return;

    if(S2=="")
		S2=class'Misc_Player'.default.ColoredName[CustomColors].SavedName;

    SetNameNoReset(S2);
  //  Log(class'Misc_Player'.default.ColoredName[CustomColors].SavedName);
 //   Log(class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[0].R@class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[0].G@class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[0].B);
    for(k=0; k<20; k++)
        class'Misc_Player'.default.ColorName[k]=class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[k];
    for(k=1; k<=Len(S2); k++)
    {
        numdoatonce=1;
        for(m=k;m<Len(S2)&& class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[k-1] == class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[m] ;m++)
        {
             numdoatonce++;
             k++;
        }
        S=S$class'Misc_Util'.Static.MakeColorCode(class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[k-1])$Right(Left(S2, k), numdoatonce);
    }
	
    if(Misc_PRI(PlayerReplicationInfo)!=None)
        Misc_PRI(PlayerReplicationInfo).SetColoredName(S);
}

exec function SetName(coerce string S)
{
	S=class'Misc_Util'.static.StripColorCodes(S);
	ReplaceText(S, " ", "_");
	ReplaceText(S, "\"", ""); // "
	SetColoredNameOldStyle(Left(S, 20));
	class'Misc_Player'.default.CurrentSelectedColoredName=255;
	CurrentSelectedColoredName=255;
	StaticSaveConfig();
	Super.SetName(S);
}

exec function SetNameNoReset(coerce string S)
{
	S=class'Misc_Util'.static.StripColorCodes(S);
	ReplaceText(S, " ", "_");
	ReplaceText(S, "\"", ""); // "
	SetColoredNameOldStyle(S);
	Super.SetName(S);
}

simulated function string FindColoredName(int CustomColors)
{
    local string S;
    local byte k;
    local byte numdoatonce;
    local byte m;
    local string S2;

    if(Level.NetMode==NM_DedicatedServer || PlayerReplicationInfo==None)
        return "";

    if(S2=="")
    {
       S2=class'Misc_Player'.default.ColoredName[CustomColors].SavedName;
    }
    //SetNameNoReset(S2);
 //   Log(class'Misc_Player'.default.ColoredName[CustomColors].SavedName);
 //   Log(class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[0].R@class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[0].G@class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[0].B);
    //for(k=0; k<20; k++)
        //class'Misc_Player'.default.ColorName[k]=class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[k];
    for(k=1; k<=Len(S2); k++)
    {
        numdoatonce=1;
        for(m=k;m<Len(S2)&& class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[k-1] == class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[m] ;m++)
        {
             numdoatonce++;
             k++;
        }
        S=S$class'Misc_Util'.static.MakeColorCode(class'Misc_Player'.default.ColoredName[CustomColors].SavedColor[k-1])$Right(Left(S2, k), numdoatonce);
    }
    return S;
}

simulated function SaveNewColoredName()
{
    local int i;
    local int n;
    local int l;

    n=class'Misc_Player'.default.ColoredName.Length+1;
    class'Misc_Player'.default.ColoredName.Length=n;

 //   Log(class'Misc_Player'.default.ColoredName.Length);

    class'Misc_Player'.default.ColoredName[n-1].SavedName=PlayerReplicationInfo.PlayerName;

    for(l=0; l<20; l++)
         class'Misc_Player'.default.ColoredName[n-1].SavedColor[l]=class'Misc_Player'.default.ColorName[l];

    ColoredName.Length=class'Misc_Player'.default.ColoredName.Length;
    for(i=0; i<class'Misc_Player'.default.ColoredName.Length; i++)
        ColoredName[i]=class'Misc_Player'.default.ColoredName[i];
    for(i=0; i<ArrayCount(ColorName); i++)
        ColorName[i]=class'Misc_Player'.default.ColorName[i];
}

simulated function SetInitialColoredName()
{
    if(class'Misc_Player'.default.CurrentSelectedColoredName!=255 && class'Misc_Player'.default.CurrentSelectedColoredName<class'Misc_Player'.default.ColoredName.Length)
        SetColoredNameOldStyleCustom(,class'Misc_Player'.default.CurrentSelectedColoredName);
    else
        SetColoredNameOldStyle();
}

/* server travel */

event PreClientTravel()
{
	//local int i;	
	/*(i=0; i<10; ++i)
	{
		if(EndCeremonyPawns[i]!=None)
			EndCeremonyPawns[i].Destroy();
	}*/
	
	Super.PreClientTravel();
}

/* server travel */

/* colored names */

simulated function ReloadDefaults()
{
	local int i;
	
	bShowCombos = class'Misc_Player'.default.bShowCombos;
	bDisableSpeed = class'Misc_Player'.default.bDisableSpeed;
	bDisableInvis = class'Misc_Player'.default.bDisableInvis;
	bDisableBooster = class'Misc_Player'.default.bDisableBooster;
	bDisableBerserk = class'Misc_Player'.default.bDisableBerserk;
	bDisableRadar = class'Misc_Player'.default.bDisableRadar;
	bDisableAmmoRegen = class'Misc_Player'.default.bDisableAmmoRegen;
	
	bShowTeamInfo = class'Misc_Player'.default.bShowTeamInfo;
	bExtendedInfo = class'Misc_Player'.default.bExtendedInfo;	
	bMatchHUDToSkins = class'Misc_Player'.default.bMatchHUDToSkins;
	//DesiredNetUpdateRate = Class'Misc_Player'.default.DesiredNetUpdateRate;	
	bUseBrightSkins = class'Misc_Player'.default.bUseBrightSkins;
	bUseTeamColors = class'Misc_Player'.default.bUseTeamColors;
	RedOrEnemy = class'Misc_Player'.default.RedOrEnemy;
	BlueOrAlly = class'Misc_Player'.default.BlueOrAlly;
	Yellow = class'Misc_Player'.default.Yellow;
	
	bForceRedEnemyModel = class'Misc_Player'.default.bForceRedEnemyModel;
	bForceBlueAllyModel = class'Misc_Player'.default.bForceBlueAllyModel;
	bUseTeamModels = class'Misc_Player'.default.bUseTeamModels;
	RedEnemyModel = class'Misc_Player'.default.RedEnemyModel;
	BlueAllyModel = class'Misc_Player'.default.BlueAllyModel;
    DamageIndicatorType = class'Misc_Player'.default.DamageIndicatorType;
    ReceiveAwardType = class'Misc_Player'.default.ReceiveAwardType;
	bDisableAnnouncement = class'Misc_Player'.default.bDisableAnnouncement;
	bAutoScreenShot = class'Misc_Player'.default.bAutoScreenShot;
	
	bAnnounceOverkill = class'Misc_Player'.default.bAnnounceOverkill;
	bUseHitsounds = class'Misc_Player'.default.bUseHitsounds;
	SoundHit = class'Misc_Player'.default.SoundHit;
	SoundHitFriendly = class'Misc_Player'.default.SoundHitFriendly;
	SoundHitVolume = class'Misc_Player'.default.SoundHitVolume;
	SoundAlone = class'Misc_Player'.default.SoundAlone; 
	SoundAloneVolume = class'Misc_Player'.default.SoundAloneVolume;
    SoundSpawnProtection = class'Misc_Player'.default.SoundSpawnProtection;
	SoundTMDeath = class'Misc_Player'.default.SoundTMDeath;
	SoundUnlock = class'Misc_Player'.default.SoundUnlock;
	
	bEnableEnhancedNetCode = class'Misc_Player'.default.bEnableEnhancedNetCode;
	ShowInitialMenu = class'Misc_Player'.default.ShowInitialMenu;
	Menu3SPNKey = class'Misc_Player'.default.Menu3SPNKey;
	bDisableEndCeremonySound = class'Misc_Player'.default.bDisableEndCeremonySound;
	
	bAllowColoredMessages = class'Misc_Player'.default.bAllowColoredMessages;
	bEnableColoredNamesInTalk = class'Misc_Player'.default.bEnableColoredNamesInTalk;
	bEnableColoredNamesOnEnemies = class'Misc_Player'.default.bEnableColoredNamesOnEnemies;

	bUseNewEyeHeightAlgorithm = class'Misc_Player'.default.bUseNewEyeHeightAlgorithm;

	CurrentSelectedColoredName = class'Misc_Player'.default.CurrentSelectedColoredName;
	for(i=0; i<ArrayCount(ColorName); ++i)
		ColorName[i] = class'Misc_Player'.default.ColorName[i];
	ColoredName =  class'Misc_Player'.default.ColoredName;
	
	AutoSyncSettings = class'Misc_Player'.default.AutoSyncSettings;
    bEnableWidescreenFix = class'Misc_Player'.default.bEnableWidescreenFix;
    bConfigureNetSpeed = class'Misc_Player'.default.bConfigureNetSpeed;
    ConfigureNetSpeedValue = class'Misc_Player'.default.ConfigureNetSpeedValue;

    TeamColorRed = class'Misc_Player'.default.TeamColorRed;
    TeamColorBlue = class'Misc_Player'.default.TeamColorBlue;

    AbortNecroSoundType = class'Misc_Player'.default.AbortNecroSoundType;
    //bEnableDodgeFix = class'Misc_Player'.default.bEnableDodgeFix;
    bEnableEmoticons = class'Misc_Player'.default.bEnableEmoticons;
}

/* settings */

function ClientSettingsResult(int result, string PlayerName)
{
	class'Message_PlayerSettingsResult'.default.PlayerName = PlayerName;
	class'Message_PlayerSettingsResult'.static.ClientReceive(self, result);

	if(Level.NetMode!=NM_DedicatedServer && class'Misc_Player'.default.ShowInitialMenu==1)
	{
		class'Menu_Menu3SPN'.default.DefaultToInfoTab=True;
		Menu3SPN();
		class'Menu_Menu3SPN'.default.DefaultToInfoTab=False;
		class'Misc_Player'.default.ShowInitialMenu = 2;
		class'Misc_Player'.static.StaticSaveConfig();
	}
}

function ClientLoadSettings(string PlayerName, Misc_PlayerSettings.BrightSkinsSettings BrightSkins, Misc_PlayerSettings.ColoredNamesSettings ColoredNames, Misc_PlayerSettings.MiscSettings Misc, Misc_PlayerSettings.WeaponSettings Weapons)
{
	local int i;
	
	class'Misc_Player'.default.bUseBrightSkins = BrightSkins.bUseBrightSkins;
	class'Misc_Player'.default.bUseTeamColors = BrightSkins.bUseTeamColors;
	class'Misc_Player'.default.RedOrEnemy = BrightSkins.RedOrEnemy;
	class'Misc_Player'.default.BlueOrAlly = BrightSkins.BlueOrAlly;
	class'Misc_Player'.default.Yellow = BrightSkins.Yellow;
	class'Misc_Player'.default.bUseTeamModels = BrightSkins.bUseTeamModels;
	class'Misc_Player'.default.bForceRedEnemyModel = BrightSkins.bForceRedEnemyModel;
	class'Misc_Player'.default.bForceBlueAllyModel = BrightSkins.bForceBlueAllyModel;
	class'Misc_Player'.default.RedEnemyModel = BrightSkins.RedEnemyModel;
	class'Misc_Player'.default.BlueAllyModel = BrightSkins.BlueAllyModel;

	class'Misc_Player'.default.bAllowColoredMessages = ColoredNames.bAllowColoredMessages;
	class'Misc_Player'.default.bEnableColoredNamesInTalk = ColoredNames.bEnableColoredNamesInTalk;
	class'Misc_Player'.default.bEnableColoredNamesOnEnemies = ColoredNames.bEnableColoredNamesOnEnemies;
	for(i=0; i<20; ++i)
		class'Misc_Player'.default.ColorName[i] = ColoredNames.ColorName[i];
	class'Misc_DeathMessage'.default.bEnableTeamColoredDeaths = ColoredNames.bEnableTeamColoredDeaths;
	class'Misc_DeathMessage'.default.bDrawColoredNamesInDeathMessages = ColoredNames.bDrawColoredNamesInDeathMessages;
	class'TAM_ScoreBoard'.default.bEnableColoredNamesOnHUD = ColoredNames.bEnableColoredNamesOnHUD;
	class'TAM_ScoreBoard'.default.bEnableColoredNamesOnScoreboard = ColoredNames.bEnableColoredNamesOnScoreboard;
	class'Misc_Player'.default.ColoredName.Length = 1;
	for(i=0; i<20; ++i)
		class'Misc_Player'.default.ColoredName[0].SavedColor[i] = ColoredNames.ColorName[i];
	class'Misc_Player'.default.ColoredName[0].SavedName = PlayerReplicationInfo.PlayerName;
	class'Misc_Player'.default.CurrentSelectedColoredName = 0;
	
	class'Misc_Player'.default.bDisableSpeed = Misc.bDisableSpeed;
	class'Misc_Player'.default.bDisableBooster = Misc.bDisableBooster;
	class'Misc_Player'.default.bDisableBerserk = Misc.bDisableBerserk;
	class'Misc_Player'.default.bDisableInvis = Misc.bDisableInvis;
	class'Misc_Player'.default.bMatchHUDToSkins = Misc.bMatchHUDToSkins;
	class'Misc_Player'.default.bShowTeamInfo = Misc.bShowTeamInfo;
	class'Misc_Player'.default.bShowCombos = Misc.bShowCombos;
	class'Misc_Player'.default.bExtendedInfo = Misc.bExtendedInfo;
	class'Misc_Pawn'.default.bPlayOwnFootsteps = Misc.bPlayOwnFootsteps;
	class'Misc_Pawn'.default.bPlayOwnLandings = Misc.bPlayOwnLandings;
	class'Misc_Player'.default.bAutoScreenShot = Misc.bAutoScreenShot;
	class'Misc_Player'.default.bUseHitSounds = Misc.bUseHitSounds;
	class'Misc_Player'.default.bEnableEnhancedNetCode = Misc.bEnableEnhancedNetCode;
	class'Misc_Player'.default.bDisableEndCeremonySound = Misc.bDisableEndCeremonySound;
	class'Misc_Player'.default.SoundHitVolume = Misc.SoundHitVolume;
	class'Misc_Player'.default.SoundAloneVolume = Misc.SoundAloneVolume;

	class'Misc_Player'.default.bUseNewEyeHeightAlgorithm = Weapons.bUseNewEyeHeightAlgorithm;

	class'Misc_Player'.default.AutoSyncSettings = Misc.AutoSyncSettings;
    class'Misc_Player'.default.DamageIndicatorType = Misc.DamageIndicatorType;
    class'Misc_Player'.default.ReceiveAwardType = ReceiveAwardTypes(Misc.ReceiveAwardType);
    class'Misc_Player'.default.bConfigureNetSpeed = Misc.bConfigureNetSpeed;
    class'Misc_Player'.default.ConfigureNetSpeedValue = Misc.ConfigureNetSpeedValue;
    class'Misc_Player'.default.bEnableWidescreenFix = Misc.bEnableWidescreenFix;
	//Class'Misc_Player'.default.DesiredNetUpdateRate = Misc.DesiredNetUpdateRate;
	//Class'Misc_Player'.default.bEnableDodgeFix = Misc.bEnableDodgeFix;
    class'Misc_Player'.default.bEnableEmoticons = Misc.bEnableEmoticons;
	
	ReloadDefaults();
	SetupCombos();
	SetColoredNameOldStyleCustom(,0);
    //SetNetUpdateRate(Misc.DesiredNetUpdateRate);
	class'Misc_Player'.static.StaticSaveConfig();
	class'TAM_ScoreBoard'.static.StaticSaveConfig();
	class'Misc_DeathMessage'.static.StaticSaveConfig();

	ClientSettingsResult(2, PlayerName);
}

function ServerLoadSettings()
{
	local Misc_PlayerSettings PlayerSettings;  
    local Team_GameBase TeamGame;
  
	foreach DynamicActors(class'Team_GameBase', TeamGame)
        break;

    PlayerSettings = class'Misc_PlayerSettings'.static.LoadPlayerSettings(self);
	if(PlayerSettings != None && PlayerSettings.Existing == True)
	{
		Log("Loading settings for player "$PlayerReplicationInfo.PlayerName);		
		ClientLoadSettings(PlayerReplicationInfo.PlayerName, PlayerSettings.BrightSkins, PlayerSettings.ColoredNames, PlayerSettings.Misc, PlayerSettings.Weapons);
	}
	else
	{
		Log("Unable to load settings for player "$PlayerReplicationInfo.PlayerName);
		ClientSettingsResult(0, PlayerReplicationInfo.PlayerName);
	}
}

function ServerSaveSettings(Misc_PlayerSettings.BrightSkinsSettings BrightSkins, Misc_PlayerSettings.ColoredNamesSettings ColoredNames, Misc_PlayerSettings.MiscSettings Misc, Misc_PlayerSettings.WeaponSettings Weapons)
{
	local Misc_PlayerSettings PlayerSettings;
    local Team_GameBase TeamGame;
  
	foreach DynamicActors(class'Team_GameBase', TeamGame)
		break;     

    PlayerSettings = class'Misc_PlayerSettings'.static.LoadPlayerSettings(self);   
	if(PlayerSettings != None)
	{
		Log("Saving settings for player "$PlayerReplicationInfo.PlayerName);		
		PlayerSettings.BrightSkins = BrightSkins;
		PlayerSettings.ColoredNames = ColoredNames;
		PlayerSettings.Misc = Misc;
        PlayerSettings.Weapons = Weapons;
		class'Misc_PlayerSettings'.static.SavePlayerSettings(PlayerSettings);
		ClientSettingsResult(3, PlayerReplicationInfo.PlayerName);
	}
	else
	{
		Log("Unable to save settings for player "$PlayerReplicationInfo.PlayerName);
		ClientSettingsResult(1, PlayerReplicationInfo.PlayerName);
	}
}

function LoadSettings()
{
	local float TimeStampSeconds;
	
	TimeStampSeconds = Level.TimeSeconds;
	if(TimeStampSeconds-LastSettingsLoadTimeSeconds < 5)
	{
		class'Message_PlayerSettingsResult'.static.ClientReceive(self, 4);
		return;
	}	
	LastSettingsLoadTimeSeconds = TimeStampSeconds;

	ServerLoadSettings();
}

function SaveSettings()
{
	local Misc_PlayerSettings.BrightSkinsSettings BrightSkins;
	local Misc_PlayerSettings.ColoredNamesSettings ColoredNames;
	local Misc_PlayerSettings.MiscSettings Misc;
	local Misc_PlayerSettings.WeaponSettings Weapons;
	local int i;
	local float TimeStampSeconds;
	
	TimeStampSeconds = Level.TimeSeconds;
	if(TimeStampSeconds-LastSettingsSaveTimeSeconds < 5)
	{
		class'Message_PlayerSettingsResult'.static.ClientReceive(self, 5);
		return;
	}
	LastSettingsSaveTimeSeconds = TimeStampSeconds;
			
	BrightSkins.bUseBrightSkins = class'Misc_Player'.default.bUseBrightSkins;
	BrightSkins.bUseTeamColors = class'Misc_Player'.default.bUseTeamColors;
	BrightSkins.RedOrEnemy = class'Misc_Player'.default.RedOrEnemy;
	BrightSkins.BlueOrAlly = class'Misc_Player'.default.BlueOrAlly;
	BrightSkins.Yellow = class'Misc_Player'.default.Yellow;
	BrightSkins.bUseTeamModels = class'Misc_Player'.default.bUseTeamModels;
	BrightSkins.bForceRedEnemyModel = class'Misc_Player'.default.bForceRedEnemyModel;
	BrightSkins.bForceBlueAllyModel = class'Misc_Player'.default.bForceBlueAllyModel;
	BrightSkins.RedEnemyModel = class'Misc_Player'.default.RedEnemyModel;
	BrightSkins.BlueAllyModel = class'Misc_Player'.default.BlueAllyModel;

	ColoredNames.bAllowColoredMessages = class'Misc_Player'.default.bAllowColoredMessages;
	ColoredNames.bEnableColoredNamesInTalk = class'Misc_Player'.default.bEnableColoredNamesInTalk;
	ColoredNames.bEnableColoredNamesOnEnemies = class'Misc_Player'.default.bEnableColoredNamesOnEnemies;
	for(i=0; i<20; ++i)
		ColoredNames.ColorName[i] = class'Misc_Player'.default.ColorName[i];
	ColoredNames.bEnableTeamColoredDeaths = class'Misc_DeathMessage'.default.bEnableTeamColoredDeaths;
	ColoredNames.bDrawColoredNamesInDeathMessages = class'Misc_DeathMessage'.default.bDrawColoredNamesInDeathMessages;
	ColoredNames.bEnableColoredNamesOnHUD = class'TAM_ScoreBoard'.default.bEnableColoredNamesOnHUD;
	ColoredNames.bEnableColoredNamesOnScoreboard = class'TAM_ScoreBoard'.default.bEnableColoredNamesOnScoreboard;
	
	Misc.bDisableSpeed = class'Misc_Player'.default.bDisableSpeed;
	Misc.bDisableBooster = class'Misc_Player'.default.bDisableBooster;
	Misc.bDisableBerserk = class'Misc_Player'.default.bDisableBerserk;
	Misc.bDisableInvis = class'Misc_Player'.default.bDisableInvis;
	Misc.bMatchHUDToSkins = class'Misc_Player'.default.bMatchHUDToSkins;
	Misc.bShowTeamInfo = class'Misc_Player'.default.bShowTeamInfo;
	Misc.bShowCombos = class'Misc_Player'.default.bShowCombos;
	Misc.bExtendedInfo = class'Misc_Player'.default.bExtendedInfo;
	Misc.bPlayOwnFootsteps = class'Misc_Pawn'.default.bPlayOwnFootsteps;
	Misc.bPlayOwnLandings = class'Misc_Pawn'.default.bPlayOwnLandings;
	Misc.bAutoScreenShot = class'Misc_Player'.default.bAutoScreenShot;
	Misc.bUseHitSounds = class'Misc_Player'.default.bUseHitSounds;
	Misc.bEnableEnhancedNetCode = class'Misc_Player'.default.bEnableEnhancedNetCode;
	Misc.bDisableEndCeremonySound = class'Misc_Player'.default.bDisableEndCeremonySound;
    Misc.bEnableWidescreenFix = class'Misc_Player'.default.bEnableWidescreenFix;
	Misc.SoundHitVolume = class'Misc_Player'.default.SoundHitVolume;
	Misc.SoundAloneVolume = class'Misc_Player'.default.SoundAloneVolume;
	Misc.AutoSyncSettings = class'Misc_Player'.default.AutoSyncSettings;
    Misc.DamageIndicatorType = class'Misc_Player'.default.DamageIndicatorType;
    Misc.ReceiveAwardType = class'Misc_Player'.default.ReceiveAwardType;
    Misc.bConfigureNetSpeed = class'Misc_Player'.default.bConfigureNetSpeed;
    Misc.ConfigureNetSpeedValue = class'Misc_Player'.default.ConfigureNetSpeedValue;
	//Misc.DesiredNetUpdateRate = class'Misc_Player'.default.DesiredNetUpdateRate;
    //Misc.bEnableDodgeFix = class'Misc_Player'.default.bEnableDodgeFix;

    Weapons.bUseNewEyeHeightAlgorithm = class'Misc_Player'.default.bUseNewEyeHeightAlgorithm;

	ServerSaveSettings(BrightSkins, ColoredNames, Misc, Weapons);
}

function ServerReportNewNetStats(bool enable)
{
  bReportNewNetStats = enable;
}

function ServerSetEyeHeightAlgorithm(bool B) {
    bUseNewEyeHeightAlgorithm = B;
}

function SetEyeHeightAlgorithm(bool B) {
    bUseNewEyeHeightAlgorithm = B;
    ServerSetEyeHeightAlgorithm(B);
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

// UTCOMP movement
/*
function FindPlayerInput() {
    local PlayerInput PIn;
    local PlayerInput PInAlt;

    // so that we can now capture it
    foreach AllObjects(class'PlayerInput', PIn)
        if (PIn.Outer == self) {
            PInAlt = PIn;
            if (InStr(PIn, ".PlayerInput") < 0)
                PlayerInput2 = PIn;
        }
    if (PlayerInput2 == none)
        PlayerInput2 = PInAlt;
}
*/

/*
event ClientTravel (string URL, ETravelType TravelType, bool bItems)
{
  Super.ClientTravel(URL,TravelType,bItems);
  if ( Misc_BaseGRI(GameReplicationInfo).UseNetUpdateRate == False )
  {
    return;
  }
  PlayerInput2 = None;
}
*/

/*
function ServerSetNetUpdateRate (float Rate, int Netspeed)
{
    local float MaxRate;
    local float MinRate;

    if ( Misc_BaseGRI(GameReplicationInfo).UseNetUpdateRate == False )
    {
        return;
    }

    MaxRate = Misc_BaseGRI(GameReplicationInfo).MaxNetUpdateRate;

    if ( Netspeed != 0 )
    {
        MaxRate = FMin(MaxRate,Netspeed / 100.0);
    }

    MinRate = Misc_BaseGRI(GameReplicationInfo).MinNetUpdateRate;
    TimeBetweenUpdates = 1.0 / FClamp(Rate,MinRate,MaxRate);
}

exec function SetNetUpdateRate (float Rate)
{
  if ( Misc_BaseGRI(GameReplicationInfo).UseNetUpdateRate)
  {
    Class'Misc_Player'.Default.DesiredNetUpdateRate = Rate;
    ServerSetNetUpdateRate(Rate,Player.CurrentNetSpeed);
    Class'Misc_Player'.static.StaticSaveConfig();
  }
}
*/

state PlayerWalking
{
    function bool NotifyLanded(vector HitNormal)
    {
        if(Misc_BaseGRI(Level.GRI) == None || Misc_BaseGRI(Level.GRI) != None && !Misc_BaseGRI(Level.GRI).bKeepMomentumOnLanding)
            return super.NotifyLanded(HitNormal);

        if (DoubleClickDir == DCLICK_Active)
        {
            DoubleClickDir = DCLICK_Done;
            ClearDoubleClick();
            Pawn.Velocity *= Vect(0.8,0.8,1.0);
        }
        else
            DoubleClickDir = DCLICK_None;

        if ( Global.NotifyLanded(HitNormal) )
            return true;

        return false;
    }

    /*
    function PlayerMove( float DeltaTime )
    {
        local vector X,Y,Z, NewAccel;
        local eDoubleClickDir DoubleClickMove;
        local rotator OldRotation, ViewRotation;
        local bool  bSaveJump;

        if(Misc_BaseGRI(Level.GRI).UseNetUpdateRate == false)
        {
            super.PlayerMove(DeltaTime);
            return;
        }

        if( Pawn == None )
        {
            GotoState('Dead'); // this was causing instant respawns in mp games
            return;
        }
        GetAxes(Pawn.Rotation,X,Y,Z);
        // Update acceleration.
        NewAccel = aForward*X + aStrafe*Y;
        NewAccel.Z = 0;
        if ( VSize(NewAccel) < 1.0 )
            NewAccel = vect(0,0,0);

        if (PlayerInput2 == none || PlayerInput2.Outer != self) {
            FindPlayerInput();
        }

        if(class'Misc_Player'.default.bEnableDodgeFix)
            DoubleClickMove = CheckForDoubleClickMove(PlayerInput2, 1.1*DeltaTime/Level.TimeDilation);
        else
            DoubleClickMove = PlayerInput2.CheckForDoubleClickMove(1.1*DeltaTime/Level.TimeDilation);

        GroundPitch = 0;
        ViewRotation = Rotation;
        if ( Pawn.Physics == PHYS_Walking )
        {
            // tell pawn about any direction changes to give it a chance to play appropriate animation
            //if walking, look up/down stairs - unless player is rotating view
             if ( (bLook == 0)
                && (((Pawn.Acceleration != Vect(0,0,0)) && bSnapToLevel) || !bKeyboardLook) )
            {
                if ( bLookUpStairs || bSnapToLevel )
                {
                    GroundPitch = FindStairRotation(deltaTime);
                    ViewRotation.Pitch = GroundPitch;
                }
                else if ( bCenterView )
                {
                    ViewRotation.Pitch = ViewRotation.Pitch & 65535;
                    if (ViewRotation.Pitch > 32768)
                        ViewRotation.Pitch -= 65536;
                    ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
                    if ( (Abs(ViewRotation.Pitch) < 250) && (ViewRotation.Pitch < 100) )
                        ViewRotation.Pitch = -249;
                }
            }
        }
        else
        {
            if ( !bKeyboardLook && (bLook == 0) && bCenterView )
            {
                ViewRotation.Pitch = ViewRotation.Pitch & 65535;
                if (ViewRotation.Pitch > 32768)
                    ViewRotation.Pitch -= 65536;
                ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
                if ( (Abs(ViewRotation.Pitch) < 250) && (ViewRotation.Pitch < 100) )
                    ViewRotation.Pitch = -249;
            }
        }
        Pawn.CheckBob(DeltaTime, Y);
        // Update rotation.
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime, 1);
        bDoubleJump = false;
        if ( bPressedJump && Pawn.CannotJumpNow() )
        {
            bSaveJump = true;
            bPressedJump = false;
        }
        else
            bSaveJump = false;
        
        if ( Role < ROLE_Authority ) // then save this move and replicate it
            UTComp_ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        else
            ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        
        if ( Role < ROLE_Authority ) // then save this move and replicate it
            ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        else
            ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        bPressedJump = bSaveJump;
    }
    */
}

/*
function UTComp_ReplicateMove(
    float DeltaTime,
    vector NewAccel,
    eDoubleClickDir DoubleClickMove,
    rotator DeltaRot
) {
    local SavedMove NewMove, OldMove, AlmostLastMove, LastMove;
    local byte ClientRoll;
    local float OldTimeDelta;
    local int OldAccel;
    local vector BuildAccel, AccelNorm, MoveLoc, CompareAccel;
    local bool bPendingJumpStatus;
    MaxResponseTime = Default.MaxResponseTime * Level.TimeDilation;
    DeltaTime = FMin(DeltaTime, MaxResponseTime);
    // find the most recent move, and the most recent interesting move
    if ( SavedMoves != None )
    {
        LastMove = SavedMoves;
        AlmostLastMove = LastMove;
        AccelNorm = Normal(NewAccel);
        while ( LastMove.NextMove != None )
        {
            // find most recent interesting move to send redundantly
            if ( LastMove.IsJumpMove() )
            {
                OldMove = LastMove;
            }
            else if ( (Pawn != None) && ((OldMove == None) || !OldMove.IsJumpMove()) )
            {
                // see if acceleration direction changed
                if ( OldMove != None )
                    CompareAccel = Normal(OldMove.Acceleration);
                else
                    CompareAccel = AccelNorm;
                if ( (LastMove.Acceleration != CompareAccel) && ((normal(LastMove.Acceleration) Dot CompareAccel) < 0.95) )
                    OldMove = LastMove;
            }
            AlmostLastMove = LastMove;
            LastMove = LastMove.NextMove;
        }
        if ( LastMove.IsJumpMove() )
        {
            OldMove = LastMove;
        }
        else if ( (Pawn != None) && ((OldMove == None) || !OldMove.IsJumpMove()) )
        {
            // see if acceleration direction changed
            if ( OldMove != None )
                CompareAccel = Normal(OldMove.Acceleration);
            else
                CompareAccel = AccelNorm;
            if ( (LastMove.Acceleration != CompareAccel) && ((normal(LastMove.Acceleration) Dot CompareAccel) < 0.95) )
                OldMove = LastMove;
        }
    }
    // Get a SavedMove actor to store the movement in.
    NewMove = GetFreeMoveEx();
    if ( NewMove == None )
        return;
    NewMove.SetMoveFor(self, DeltaTime, NewAccel, DoubleClickMove);
    NewMove.RemoteRole = ROLE_None;
    // Simulate the movement locally.
    bDoubleJump = false;
    ProcessMove(NewMove.Delta, NewMove.Acceleration, NewMove.DoubleClickMove, DeltaRot);
    // see if the two moves could be combined
    if ((PendingMove != None) &&
        (Pawn != None) &&
        (Pawn.Physics == PHYS_Walking) &&
        (NewMove.Delta + PendingMove.Delta < MaxResponseTime) &&
        (NewAccel != vect(0,0,0)) &&
        (PendingMove.SavedPhysics == PHYS_Walking) &&
        !PendingMove.bPressedJump &&
        !NewMove.bPressedJump &&
        (PendingMove.bRun == NewMove.bRun) &&
        (PendingMove.bDuck == NewMove.bDuck) &&
        (PendingMove.bDoubleJump == NewMove.bDoubleJump) &&
        (PendingMove.DoubleClickMove == DCLICK_None) &&
        (NewMove.DoubleClickMove == DCLICK_None) &&
        ((Normal(PendingMove.Acceleration) Dot Normal(NewAccel)) > 0.99) &&
        (Level.TimeDilation >= 0.9)
    ) {
        Pawn.SetLocation(PendingMove.GetStartLocation());
        Pawn.Velocity = PendingMove.StartVelocity;
        if ( PendingMove.StartBase != Pawn.Base);
            Pawn.SetBase(PendingMove.StartBase);
        Pawn.Floor = PendingMove.StartFloor;
        NewMove.Delta += PendingMove.Delta;
        NewMove.SetInitialPosition(Pawn);
        // remove pending move from move list
        if (LastMove == PendingMove) {
            if (SavedMoves == PendingMove) {
                SavedMoves.NextMove = FreeMoves;
                FreeMoves = SavedMoves;
                SavedMoves = None;
            } else {
                PendingMove.NextMove = FreeMoves;
                FreeMoves = PendingMove;
                if (AlmostLastMove != None) {
                    AlmostLastMove.NextMove = None;
                    LastMove = AlmostLastMove;
                }
            }
            FreeMoves.Clear();
        }
        PendingMove = None;
    }
    if (Pawn != None)
        Pawn.AutonomousPhysics(NewMove.Delta);
    else
        AutonomousPhysics(DeltaTime);
    NewMove.PostUpdate(self);
    if (SavedMoves == None)
        SavedMoves = NewMove;
    else
        LastMove.NextMove = NewMove;
    if (PendingMove == None) 
    {
        // Decide whether to hold off on move
        if ((Level.TimeSeconds - ClientUpdateTime) * Level.TimeDilation * 0.91 < TimeBetweenUpdates) {
            PendingMove = NewMove;
            return;
        }
    }
    ClientUpdateTime = Level.TimeSeconds;
    // check if need to redundantly send previous move
    if ( OldMove != None )
    {
        // old move important to replicate redundantly
        OldTimeDelta = FMin(255, (Level.TimeSeconds - OldMove.TimeStamp) * 500);
        BuildAccel = 0.05 * OldMove.Acceleration + vect(0.5, 0.5, 0.5);
        OldAccel = (CompressAccel(BuildAccel.X) << 23)
                    + (CompressAccel(BuildAccel.Y) << 15)
                    + (CompressAccel(BuildAccel.Z) << 7);
        if (OldMove.bRun)
            OldAccel += 64;
        if (OldMove.bDoubleJump)
            OldAccel += 32;
        if (OldMove.bPressedJump)
            OldAccel += 16;
        OldAccel += OldMove.DoubleClickMove;
    }
    // Send to the server
    ClientRoll = (Rotation.Roll >> 8) & 255;
    if (PendingMove != None) {
        if ( PendingMove.bPressedJump )
            bJumpStatus = !bJumpStatus;
        bPendingJumpStatus = bJumpStatus;
    }
    if (NewMove.bPressedJump)
        bJumpStatus = !bJumpStatus;
    if (Pawn == None)
        MoveLoc = Location;
    else
        MoveLoc = Pawn.Location;
    UTComp_CallServerMove(
        NewMove.TimeStamp,
        NewMove.Acceleration * 10,
        MoveLoc,
        NewMove.bRun,
        NewMove.bDuck,
        bPendingJumpStatus,
        bJumpStatus,
        NewMove.bDoubleJump,
        NewMove.DoubleClickMove,
        ClientRoll,
        ((0xFFFF & Rotation.Pitch) << 16) | (0xFFFF & Rotation.Yaw),
        OldTimeDelta,
        OldAccel
    );
    PendingMove = None;
}
function UTComp_CallServerMove(
    float TimeStamp,
    vector InAccel,
    vector ClientLoc,
    bool NewbRun,
    bool NewbDuck,
    bool NewbPendingJumpStatus,
    bool NewbJumpStatus,
    bool NewbDoubleJump,
    eDoubleClickDir DoubleClickMove,
    byte ClientRoll,
    int View,
    optional byte OldTimeDelta,
    optional int OldAccel
) {
    local byte PendingCompress;
    local bool bCombine;
    if ( PendingMove != None ) {
        PendingCompress = PendingCompress | int(PendingMove.bRun);
        PendingCompress = PendingCompress | int(PendingMove.bDuck) << 1;
        PendingCompress = PendingCompress | int(NewbPendingJumpStatus) << 2;
        PendingCompress = PendingCompress | int(PendingMove.bDoubleJump) << 3;
        PendingCompress = PendingCompress | int(NewbRun) << 4;
        PendingCompress = PendingCompress | int(NewbDuck) << 5;
        PendingCompress = PendingCompress | int(NewbJumpStatus) << 6;
        PendingCompress = PendingCompress | int(NewbDoubleJump) << 7;
        // send two moves simultaneously
        if ((InAccel == vect(0,0,0)) &&
            (PendingMove.StartVelocity == vect(0,0,0)) &&
            (DoubleClickMove == DCLICK_None) &&
            (PendingMove.Acceleration == vect(0,0,0)) &&
            (PendingMove.DoubleClickMove == DCLICK_None) &&
            !PendingMove.bDoubleJump
        ) {
            if ( Pawn == None )
                bCombine = (Velocity == vect(0,0,0));
            else
                bCombine = (Pawn.Velocity == vect(0,0,0));
            if (bCombine) {
                if (OldTimeDelta == 0) {
                    UTComp_ShortServerMove(
                        TimeStamp,
                        ClientLoc,
                        NewbRun,
                        NewbDuck,
                        NewbJumpStatus,
                        ClientRoll,
                        View
                    );
                } else {
                    UTComp_ServerMove(
                        TimeStamp,
                        InAccel,
                        ClientLoc,
                        NewbRun,
                        NewbDuck,
                        NewbJumpStatus,
                        NewbDoubleJump,
                        DoubleClickMove,
                        ClientRoll,
                        View,
                        OldTimeDelta,
                        OldAccel
                    );
                }
                return;
            }
        }
        if ( OldTimeDelta == 0 )
            UTComp_DualServerMove(
                PendingMove.TimeStamp,
                PendingMove.Acceleration * 10,
                PendingCompress,
                PendingMove.DoubleClickMove,
                ((0xFFFF & PendingMove.Rotation.Pitch) << 16) | (0xFFFF & PendingMove.Rotation.Yaw),
                TimeStamp,
                InAccel,
                ClientLoc,
                DoubleClickMove,
                ClientRoll,
                View
            );
        else
            UTComp_DualServerMove(
                PendingMove.TimeStamp,
                PendingMove.Acceleration * 10,
                PendingCompress,
                PendingMove.DoubleClickMove,
                ((0xFFFF & PendingMove.Rotation.Pitch) << 16) | (0xFFFF & PendingMove.Rotation.Yaw),
                TimeStamp,
                InAccel,
                ClientLoc,
                DoubleClickMove,
                ClientRoll,
                View,
                OldTimeDelta,
                OldAccel
            );
    } else if ( OldTimeDelta != 0 ) {
        UTComp_ServerMove(
            TimeStamp,
            InAccel,
            ClientLoc,
            NewbRun,
            NewbDuck,
            NewbJumpStatus,
            NewbDoubleJump,
            DoubleClickMove,
            ClientRoll,
            View,
            OldTimeDelta,
            OldAccel
        );
    } else if ((InAccel == vect(0,0,0)) && (DoubleClickMove == DCLICK_None) && !NewbDoubleJump) {
        UTComp_ShortServerMove(
            TimeStamp,
            ClientLoc,
            NewbRun,
            NewbDuck,
            NewbJumpStatus,
            ClientRoll,
            View
        );
    } else {
        UTComp_ServerMove(
            TimeStamp,
            InAccel,
            ClientLoc,
            NewbRun,
            NewbDuck,
            NewbJumpStatus,
            NewbDoubleJump,
            DoubleClickMove,
            ClientRoll,
            View
        );
    }
}
// ShortServerMove()
// compressed version of server move for bandwidth saving
//
function UTComp_ShortServerMove(
    float TimeStamp,
    vector ClientLoc,
    bool NewbRun,
    bool NewbDuck,
    bool NewbJumpStatus,
    byte ClientRoll,
    int View
) {
    UTComp_ServerMove(TimeStamp,vect(0,0,0),ClientLoc,NewbRun,NewbDuck,NewbJumpStatus,false,DCLICK_None,ClientRoll,View);
}

// DualServerMove()
// replicated function sent by client to server - contains client movement and firing info for two moves
//
function UTComp_DualServerMove(
    float TimeStamp0,
    vector InAccel0,
    byte PendingCompress,
    eDoubleClickDir DoubleClickMove0,
    int View0,
    float TimeStamp,
    vector InAccel,
    vector ClientLoc,
    eDoubleClickDir DoubleClickMove,
    byte ClientRoll,
    int View,
    optional byte OldTimeDelta,
    optional int OldAccel
) {
    local bool NewbRun0,NewbDuck0,NewbJumpStatus0,NewbDoubleJump0,
                NewbRun,NewbDuck,NewbJumpStatus,NewbDoubleJump;
    NewbRun0 =        (PendingCompress & 0x01) != 0;
    NewbDuck0 =       (PendingCompress & 0x02) != 0;
    NewbJumpStatus0 = (PendingCompress & 0x04) != 0;
    NewbDoubleJump0 = (PendingCompress & 0x08) != 0;
    NewbRun =         (PendingCompress & 0x10) != 0;
    NewbDuck =        (PendingCompress & 0x20) != 0;
    NewbJumpStatus =  (PendingCompress & 0x40) != 0;
    NewbDoubleJump =  (PendingCompress & 0x80) != 0;
    UTComp_ServerMove(TimeStamp0,InAccel0,vect(0,0,0),NewbRun0,NewbDuck0,NewbJumpStatus0,NewbDoubleJump0,DoubleClickMove0,
            ClientRoll,View0);
    if ( ClientLoc == vect(0,0,0) )
        ClientLoc = vect(0.1,0,0);
    UTComp_ServerMove(TimeStamp,InAccel,ClientLoc,NewbRun,NewbDuck,NewbJumpStatus,NewbDoubleJump,DoubleClickMove,ClientRoll,View,OldTimeDelta,OldAccel);
}
// ServerMove()
// replicated function sent by client to server - contains client movement and firing info.
//
function UTComp_ServerMove(
    float TimeStamp,
    vector InAccel,
    vector ClientLoc,
    bool NewbRun,
    bool NewbDuck,
    bool NewbJumpStatus,
    bool NewbDoubleJump,
    eDoubleClickDir DoubleClickMove,
    byte ClientRoll,
    int View,
    optional byte OldTimeDelta,
    optional int OldAccel
) {
    local float DeltaTime, clientErr, OldTimeStamp;
    local rotator DeltaRot, Rot, ViewRot;
    local vector Accel, LocDiff;
    local int maxPitch, ViewPitch, ViewYaw;
    local bool NewbPressedJump, OldbRun, OldbDoubleJump;
    local eDoubleClickDir OldDoubleClickMove;
    // If this move is outdated, discard it.
    if ( CurrentTimeStamp >= TimeStamp )
        return;
    if ( AcknowledgedPawn != Pawn )
    {
        OldTimeDelta = 0;
        InAccel = vect(0,0,0);
        GivePawn(Pawn);
    }
    // if OldTimeDelta corresponds to a lost packet, process it first
    if (  OldTimeDelta != 0 )
    {
        OldTimeStamp = TimeStamp - float(OldTimeDelta)/500 - 0.001;
        if ( CurrentTimeStamp < OldTimeStamp - 0.001 )
        {
            // split out components of lost move (approx)
            Accel.X = OldAccel >>> 23;
            if ( Accel.X > 127 )
                Accel.X = -1 * (Accel.X - 128);
            Accel.Y = (OldAccel >>> 15) & 255;
            if ( Accel.Y > 127 )
                Accel.Y = -1 * (Accel.Y - 128);
            Accel.Z = (OldAccel >>> 7) & 255;
            if ( Accel.Z > 127 )
                Accel.Z = -1 * (Accel.Z - 128);
            Accel *= 20;
            OldbRun = ( (OldAccel & 64) != 0 );
            OldbDoubleJump = ( (OldAccel & 32) != 0 );
            NewbPressedJump = ( (OldAccel & 16) != 0 );
            if ( NewbPressedJump )
                bJumpStatus = NewbJumpStatus;
            switch (OldAccel & 7)
            {
                case 0:
                    OldDoubleClickMove = DCLICK_None;
                    break;
                case 1:
                    OldDoubleClickMove = DCLICK_Left;
                    break;
                case 2:
                    OldDoubleClickMove = DCLICK_Right;
                    break;
                case 3:
                    OldDoubleClickMove = DCLICK_Forward;
                    break;
                case 4:
                    OldDoubleClickMove = DCLICK_Back;
                    break;
            }
            //log("Recovered move from "$OldTimeStamp$" acceleration "$Accel$" from "$OldAccel);
            OldTimeStamp = FMin(OldTimeStamp, CurrentTimeStamp + MaxResponseTime);
            MoveAutonomous(OldTimeStamp - CurrentTimeStamp, OldbRun, (bDuck == 1), NewbPressedJump, OldbDoubleJump, OldDoubleClickMove, Accel, rot(0,0,0));
            CurrentTimeStamp = OldTimeStamp;
        }
    }
    // View components
    ViewPitch = View >>> 16;
    ViewYaw = View & 0xFFFF;
    // Make acceleration.
    Accel = InAccel * 0.1;
    NewbPressedJump = (bJumpStatus != NewbJumpStatus);
    bJumpStatus = NewbJumpStatus;
    // Save move parameters.
    DeltaTime = FMin(MaxResponseTime,TimeStamp - CurrentTimeStamp);
    if ( Pawn == None )
    {
        ResetTimeMargin();
    }
    else if ( !CheckSpeedHack(DeltaTime) )
    {
        bWasSpeedHack = true;
        DeltaTime = 0;
        Pawn.Velocity = vect(0,0,0);
    }
    else if ( bWasSpeedHack )
    {
        // if have had a speedhack detection, then modify deltatime if getting too far ahead again
        if ( (TimeMargin > 0.5 * Level.MaxTimeMargin) && (Level.MaxTimeMargin > 0) )
            DeltaTime *= 0.8;
    }
    CurrentTimeStamp = TimeStamp;
    ServerTimeStamp = Level.TimeSeconds;
    ViewRot.Pitch = ViewPitch;
    ViewRot.Yaw = ViewYaw;
    ViewRot.Roll = 0;
    if ( NewbPressedJump || (InAccel != vect(0,0,0)) )
        LastActiveTime = Level.TimeSeconds;
    if ( Pawn == None || Pawn.bServerMoveSetPawnRot )
        SetRotation(ViewRot);
    if ( AcknowledgedPawn != Pawn )
        return;
    if ( (Pawn != None) && Pawn.bServerMoveSetPawnRot )
    {
        Rot.Roll = 256 * ClientRoll;
        Rot.Yaw = ViewYaw;
        if ( (Pawn.Physics == PHYS_Swimming) || (Pawn.Physics == PHYS_Flying) )
            maxPitch = 2;
        else
            maxPitch = 0;
        if ( (ViewPitch > maxPitch * RotationRate.Pitch) && (ViewPitch < 65536 - maxPitch * RotationRate.Pitch) )
        {
            If (ViewPitch < 32768)
                Rot.Pitch = maxPitch * RotationRate.Pitch;
            else
                Rot.Pitch = 65536 - maxPitch * RotationRate.Pitch;
        }
        else
            Rot.Pitch = ViewPitch;
        DeltaRot = (Rotation - Rot);
        Pawn.SetRotation(Rot);
    }
    // Perform actual movement
    if ( (Level.Pauser == None) && (DeltaTime > 0) )
        MoveAutonomous(DeltaTime, NewbRun, NewbDuck, NewbPressedJump, NewbDoubleJump, DoubleClickMove, Accel, DeltaRot);
    // Accumulate movement error.
    if ( ClientLoc == vect(0,0,0) )
        return;     // first part of double servermove
    else if ( Level.TimeSeconds - LastUpdateTime > 0.3 )
        ClientErr = 10000;
    else if ( Level.TimeSeconds - LastUpdateTime > 180.0/Player.CurrentNetSpeed )
    {
        if ( Pawn == None )
            LocDiff = Location - ClientLoc;
        else
            LocDiff = Pawn.Location - ClientLoc;
        ClientErr = LocDiff Dot LocDiff;
    }
    // If client has accumulated a noticeable positional error, correct him.
    if ( ClientErr > 3 )
    {
        if ( Pawn == None )
        {
            PendingAdjustment.newPhysics = Physics;
            PendingAdjustment.NewLoc = Location;
            PendingAdjustment.NewVel = Velocity;
        }
        else
        {
            PendingAdjustment.newPhysics = Pawn.Physics;
            PendingAdjustment.NewVel = Pawn.Velocity;
            PendingAdjustment.NewBase = Pawn.Base;
            if ( (Mover(Pawn.Base) != None) || (Vehicle(Pawn.Base) != None) )
                PendingAdjustment.NewLoc = Pawn.Location - Pawn.Base.Location;
            else
                PendingAdjustment.NewLoc = Pawn.Location;
            PendingAdjustment.NewFloor = Pawn.Floor;
        }
        //if ( (ClientErr != 10000) && (Pawn != None) )
            //Log(" Client Error at "$TimeStamp$" is "$ClientErr$" with acceleration "$Accel$" LocDiff "$LocDiff$" Physics "$Pawn.Physics);
        LastUpdateTime = Level.TimeSeconds;

        PendingAdjustment.TimeStamp = TimeStamp;
        PendingAdjustment.newState = GetStateName();
    }
    //log("Server moved stamp "$TimeStamp$" location "$Pawn.Location$" Acceleration "$Pawn.Acceleration$" Velocity "$Pawn.Velocity);
}
// END UTCOMP movement 
*/

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

function int FractionCorrection(float in, out float fraction) {
    local int result;
    local float tmp;

    tmp = in + fraction;
    result = int(tmp);
    fraction = tmp - result;

    return result;
}

function UpdateRotation(float DeltaTime, float maxPitch)
{
    local rotator newRotation, ViewRotation;

    if ( bInterpolating || ((Pawn != None) && Pawn.bInterpolating) )
    {
        ViewShake(deltaTime);
        return;
    }

    // Added FreeCam control for better view control
    if (bFreeCam == True)
    {
        if (bFreeCamZoom == True)
        {
            CameraDeltaRad += FractionCorrection(DeltaTime * 0.25 * aLookUp, PitchFraction);
        }
        else if (bFreeCamSwivel == True)
        {
            CameraSwivel.Yaw += FractionCorrection(16.0 * DeltaTime * aTurn, YawFraction);
            CameraSwivel.Pitch += FractionCorrection(16.0 * DeltaTime * aLookUp, PitchFraction);
        }
        else
        {
            CameraDeltaRotation.Yaw += FractionCorrection(32.0 * DeltaTime * aTurn, YawFraction);
            CameraDeltaRotation.Pitch += FractionCorrection(32.0 * DeltaTime * aLookUp, PitchFraction);
        }
    }
    else
    {
        ViewRotation = Rotation;

        if(Pawn != None && Pawn.Physics != PHYS_Flying) // mmmmm
        {
            // Ensure we are not setting the pawn to a rotation beyond its desired
            if( Pawn.DesiredRotation.Roll < 65535 &&
                (ViewRotation.Roll < Pawn.DesiredRotation.Roll || ViewRotation.Roll > 0))
                ViewRotation.Roll = 0;
            else if( Pawn.DesiredRotation.Roll > 0 &&
                (ViewRotation.Roll > Pawn.DesiredRotation.Roll || ViewRotation.Roll < 65535))
                ViewRotation.Roll = 0;
        }

        DesiredRotation = ViewRotation; //save old rotation

        if ( bTurnToNearest != 0 )
            TurnTowardNearestEnemy();
        else if ( bTurn180 != 0 )
            TurnAround();
        else
        {
            TurnTarget = None;
            bRotateToDesired = false;
            bSetTurnRot = false;
            ViewRotation.Yaw += FractionCorrection(32.0 * DeltaTime * aTurn, YawFraction);
            ViewRotation.Pitch += FractionCorrection(32.0 * DeltaTime * aLookUp, PitchFraction);
        }
        if (Pawn != None)
            ViewRotation.Pitch = Pawn.LimitPitch(ViewRotation.Pitch);

        SetRotation(ViewRotation);

        ViewShake(deltaTime);
        ViewFlash(deltaTime);

        NewRotation = ViewRotation;
        //NewRotation.Roll = Rotation.Roll;

        if ( !bRotateToDesired && (Pawn != None) && (!bFreeCamera || !bBehindView) )
            Pawn.FaceRotation(NewRotation, deltatime);
    }

}

// from  https://github.com/EliteTrials/ElitePatch
// refactored to work with UTComp style movement override
function Actor.eDoubleClickDir CheckForDoubleClickMove(PlayerInput PI, float DeltaTime)
{
	local Actor.eDoubleClickDir DoubleClickMove, OldDoubleClickDir;

    if (!PI.bEnableDodging)
    {
        DoubleClickMove = DCLICK_None;
        return DoubleClickMove;
    }

    if ( PI.DoubleClickDir == DCLICK_Active )
		DoubleClickMove = DCLICK_Active;
	else
		DoubleClickMove = DCLICK_None;
	if (PI.DoubleClickTime > 0.0)
	{
		if ( PI.DoubleClickDir == DCLICK_Active )
		{
			if ( (PI.Pawn != None) && (PI.Pawn.Physics == PHYS_Walking) )
			{
				PI.DoubleClickTimer = 0.0 - DeltaTime;
				PI.DoubleClickDir = DCLICK_Done;
			}
		}
        // @PATCH check for buffered click
		else if ( PI.DoubleClickDir != DCLICK_Done )
		{
            OldDoubleClickDir = PI.DoubleClickDir;
			PI.DoubleClickDir = DCLICK_None;

			if (PI.bEdgeForward && (PI.bWasForward || BufferedClickDir == DCLICK_Forward))
				PI.DoubleClickDir = DCLICK_Forward;
			else if (PI.bEdgeBack && (PI.bWasBack || BufferedClickDir == DCLICK_Back))
				PI.DoubleClickDir = DCLICK_Back;
			else if (PI.bEdgeLeft && (PI.bWasLeft || BufferedClickDir == DCLICK_Left))
				PI.DoubleClickDir = DCLICK_Left;
			else if (PI.bEdgeRight && (PI.bWasRight || BufferedClickDir == DCLICK_Right))
				PI.DoubleClickDir = DCLICK_Right;

			if ( PI.DoubleClickDir == DCLICK_None)
				PI.DoubleClickDir = OldDoubleClickDir;
			else if ( PI.DoubleClickDir != OldDoubleClickDir )
            {
				// DoubleClickTimer = DoubleClickTime + 0.5 * DeltaTime;
				PI.DoubleClickTimer = PI.DoubleClickTime; // @PATCH
            }
			else 
            {
                DoubleClickMove = PI.DoubleClickDir;
            }
		}

        // @PATCH
        BufferedClickTimer -= DeltaTime;
        if (BufferedClickTimer <= -0.5 && BufferedClickDir != DCLICK_None) {
            BufferedClickDir = DCLICK_None;
            // ClientMessage("Reseting buffered click");
        }

		if (PI.DoubleClickDir == DCLICK_Done)
		{
            OldDoubleClickDir = BufferedClickDir;
            // @PATCH let's buffer double clicks as soon as the interval timer has occurred (i.e. after landing from a dodge)
            if (PI.bEdgeForward)
                BufferedClickDir = DCLICK_Forward;
            else if (PI.bEdgeBack)
                BufferedClickDir = DCLICK_Back;
            else if (PI.bEdgeLeft)
                BufferedClickDir = DCLICK_Left;
            else if (PI.bEdgeRight)
                BufferedClickDir = DCLICK_Right;

            if (OldDoubleClickDir != BufferedClickDir) {
                BufferedClickTimer = 0.0;
                // ClientMessage("Buffering click" @ OldDoubleClickDir);
            }

			PI.DoubleClickTimer = FMin(PI.DoubleClickTimer-DeltaTime,0.0);
			if (PI.DoubleClickTimer <= -0.35)
			{
				PI.DoubleClickDir = DCLICK_None;
				PI.DoubleClickTimer = PI.DoubleClickTime;
			}
		}
		else if ((PI.DoubleClickDir != DCLICK_None) && (PI.DoubleClickDir != DCLICK_Active))
		{
			PI.DoubleClickTimer -= DeltaTime;
			if (PI.DoubleClickTimer <= 0.0)
			{
				PI.DoubleClickDir = DCLICK_None;
				PI.DoubleClickTimer = PI.DoubleClickTime;
			}
		}
	}
	return DoubleClickMove;
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

/* settings */

defaultproperties
{
     bShowCombos=True
     bShowTeamInfo=True
     bExtendedInfo=True
     DamageIndicatorType=1
     bUseBrightSkins=True
     bUseTeamColors=True
     RedOrEnemy=(R=100,A=128)
     BlueOrAlly=(B=100,G=25,A=128)
     Yellow=(G=100,A=128)
     bUseTeamModels=True
     RedEnemyModel="Gorge"
     BlueAllyModel="Jakob"
     bAnnounceOverkill=True
     bUseHitSounds=True
     SoundHit=Sound'3SPNvSoL.Sounds.HitSound'
     SoundHitFriendly=Sound'MenuSounds.denied1'
     SoundHitVolume=0.600000
     SoundAlone=Sound'3SPNvSoL.Sounds.alone'
     SoundAloneVolume=1.000000
     SoundUnlock=Sound'NewWeaponSounds.Newclickgrenade'
     SoundSpawnProtection=Sound'3SPNvSoL.Sounds.Bleep'
     bEnableEnhancedNetCode=True
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
     EndCeremonyWeaponNames(0)="xWeapons.ShockRifle"
     EndCeremonyWeaponNames(1)="xWeapons.LinkGun"
     EndCeremonyWeaponNames(2)="xWeapons.MiniGun"
     EndCeremonyWeaponNames(3)="xWeapons.FlakCannon"
     EndCeremonyWeaponNames(4)="xWeapons.RocketLauncher"
     EndCeremonyWeaponNames(5)="xWeapons.SniperRifle"
     EndCeremonyWeaponNames(6)="xWeapons.BioRifle"
     EndCeremonyWeaponNames(7)="UTClassic.ClassicSniperRifle"
     EndCeremonyWeaponClasses(0)=Class'XWeapons.ShockRifle'
     EndCeremonyWeaponClasses(1)=Class'XWeapons.LinkGun'
     EndCeremonyWeaponClasses(2)=Class'XWeapons.Minigun'
     EndCeremonyWeaponClasses(3)=Class'XWeapons.FlakCannon'
     EndCeremonyWeaponClasses(4)=Class'XWeapons.RocketLauncher'
     EndCeremonyWeaponClasses(5)=Class'XWeapons.SniperRifle'
     EndCeremonyWeaponClasses(6)=Class'XWeapons.BioRifle'
     EndCeremonyWeaponClasses(7)=Class'UTClassic.ClassicSniperRifle'
     RedMessageColor=(B=64,G=64,R=255,A=200)
     GreenMessageColor=(B=128,G=200,R=128,A=200)
     BlueMessageColor=(B=253,G=200,R=125,A=200)
     YellowMessageColor=(B=1,G=200,R=200,A=200)
     WhiteMessageColor=(B=200,G=200,R=200,A=200)
     WhiteColor=(B=255,G=255,R=255,A=255)
     bAllowColoredMessages=True
     bEnableColoredNamesInTalk=True
     CurrentSelectedColoredName=255
     colorname(0)=(B=255,G=255,R=255,A=255)
     colorname(1)=(B=255,G=255,R=255,A=255)
     colorname(2)=(B=255,G=255,R=255,A=255)
     colorname(3)=(B=255,G=255,R=255,A=255)
     colorname(4)=(B=255,G=255,R=255,A=255)
     colorname(5)=(B=255,G=255,R=255,A=255)
     colorname(6)=(B=255,G=255,R=255,A=255)
     colorname(7)=(B=255,G=255,R=255,A=255)
     colorname(8)=(B=255,G=255,R=255,A=255)
     colorname(9)=(B=255,G=255,R=255,A=255)
     colorname(10)=(B=255,G=255,R=255,A=255)
     colorname(11)=(B=255,G=255,R=255,A=255)
     colorname(12)=(B=255,G=255,R=255,A=255)
     colorname(13)=(B=255,G=255,R=255,A=255)
     colorname(14)=(B=255,G=255,R=255,A=255)
     colorname(15)=(B=255,G=255,R=255,A=255)
     colorname(16)=(B=255,G=255,R=255,A=255)
     colorname(17)=(B=255,G=255,R=255,A=255)
     colorname(18)=(B=255,G=255,R=255,A=255)
     colorname(19)=(B=255,G=255,R=255,A=255)
     AutoSyncSettings=True
     LastSettingsLoadTimeSeconds=-100.000000
     LastSettingsSaveTimeSeconds=-100.000000
     PlayerReplicationInfoClass=Class'3SPNvSoL.Misc_PRI'
     Adrenaline=0.100000
     AdrenalineMax=120.000000
     ReceiveAwardType=RAT_All
     bConfigureNetSpeed=false
     ConfigureNetSpeedValue=15000
     bEnableWidescreenFix=false
     //bEnableDodgeFix=false

     //DesiredNetUpdateRate=90.0
     //TimeBetweenUpdates=0.011111
 
     bTeamColorRockets=false
     bTeamColorBio=false
     bTeamColorFlak=false
     bTeamColorShock=false
     bTeamColorSniper=false
     TeamColorRed=(R=255,G=80,B=80,A=255)
     TeamColorBlue=(R=80,G=80,B=255,A=255)
     bTeamColorUseTeam=true
     bEnableEmoticons=true

     AbortNecroSoundType=ANS_Meow
}
