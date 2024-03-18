class TeamArenaMaster extends Team_GameBase
    config;

/* general and misc */
var config bool     bDisableTeamCombos;
var config bool     bChallengeMode;

var config bool        bRandomPickups;  // Obsolete, replaced by PickupMode
var config int         PickupMode;
var string             PickupModeText;
var Misc_PickupSpawner PickupSpawner;

var config bool     bPureRFF;
/* general and misc */

function InitGameReplicationInfo()
{
    Super.InitGameReplicationInfo();

    if(TAM_GRI(GameReplicationInfo) == None)
        return;

    TAM_GRI(GameReplicationInfo).bChallengeMode = bChallengeMode;
    TAM_GRI(GameReplicationInfo).bDisableTeamCombos = bDisableTeamCombos;
    TAM_GRI(GameReplicationInfo).PickupMode = PickupMode;
}

function GetServerDetails(out ServerResponseLine ServerState)
{
    Super.GetServerDetails(ServerState);

    AddServerDetail(ServerState, "Team Combos", !bDisableTeamCombos);
    AddServerDetail(ServerState, "Challenge Mode", bChallengeMode);
    AddServerDetail(ServerState, "Pickup Mode", PickupModeDescription(PickupMode));
}

static function FillPlayInfo(PlayInfo PI)
{
    Super.FillPlayInfo(PI);

    // weight is a byte value (max 127?)
    PI.AddSetting("3SPN", "bChallengeMode", "Challenge Mode", 0, 110, "Check");
    PI.AddSetting("3SPN", "PickupMode", "Spawn Pickup Mode", 0, 111, "Select", default.PickupModeText);
    PI.AddSetting("3SPN", "bDisableTeamCombos", "No Team Combos", 0, 112, "Check");
    PI.AddSetting("3SPN", "bPureRFF", "2.57 style RFF", 0, 113, "Check");
}

static event string GetDescriptionText(string PropName)
{ 
    switch(PropName)
    {
        case "bChallengeMode":      return "Round winners take a health/armor penalty.";
        case "bDisableTeamCombos":  return "Turns off team combos. Only the user gets the combo.";
        case "PickupMode":          return "Pickup mode to spawn three pickups which give random effect when picked up: Health +10/20, Shield +10/20 or Adren +10";
        case "bPureRFF":            return "All teammate damage is reflected back.";
    }

    return Super.GetDescriptionText(PropName);
}

function UnrealTeamInfo GetBlueTeam(int TeamBots)
{
    if(BlueTeamName != "")
        BlueTeamName = "WS3SPN.TAM_TeamInfoBlue";
    return Super.GetBlueTeam(TeamBots);
}

function UnrealTeamInfo GetRedTeam(int TeamBots)
{
    if(RedTeamName != "")
        RedTeamName = "WS3SPN.TAM_TeamInfoRed";
    return Super.GetRedTeam(TeamBots);
}

function ParseOptions(string Options)
{
    local string InOpt;

    Super.ParseOptions(Options);

    InOpt = ParseOption(Options, "ChallengeMode");
    if(InOpt != "")
        bChallengeMode = bool(InOpt);

    InOpt = ParseOption(Options, "DisableTeamCombos");
    if(InOpt != "")
        bDisableTeamCombos = bool(InOpt);

    InOpt = ParseOption(Options, "PickupMode");
    if(InOpt != "")
        PickupMode = ParsePickupMode(InOpt);

    InOpt = ParseOption(Options, "PureRFF");
    if(InOpt != "")
        bPureRFF = bool(InOpt);
}

function int ParsePickupMode(coerce string Opt)
{
    if (Opt ~= "Random")
        return 1;

    if (Opt ~= "Optimal")
        return 2;

    return 0;
}

function string PickupModeDescription(int Mode)
{
    if (Mode == 1)
        return "Random";

    if (Mode == 2)
        return "Optimal";

    return "Off";
}

function SpawnRandomPickupBases()
{
    local class<Misc_PickupSpawner> PickupSpawnerClass;

    if (PickupMode == 1)
        PickupSpawnerClass = class'Misc_RandomPickupSpawner';

    if (PickupMode == 2)
        PickupSpawnerClass = class'Misc_OptimalPickupSpawner';

    if (PickupSpawnerClass == None)
        return;

    if (PickupSpawner == None)
        PickupSpawner = Spawn(PickupSpawnerClass);

    PickupSpawner.SpawnPickups();
}

event InitGame(string Options, out string Error)
{
    local Mutator mut;
    local bool bNoAdren;

    bAllowBehindView = true;

    Super.InitGame(Options, Error);

    if (bRandomPickups && PickupMode == 0)
    {
        // Migrate old configurations to use PickupMode instead
        bRandomPickups = false;
        PickupMode = 1;
        // SaveConfig();
    }

    if(PickupMode != 0)
    {
        for(mut = BaseMutator; mut != None; mut = mut.NextMutator)
        {
            if(mut.IsA('MutNoAdrenaline'))
            {
                bNoAdren = true;   
                break;
            }
        }

        if(bNoAdren)
            class'Misc_PickupBase'.default.PickupClasses[4] = None;
        else
            class'Misc_PickupBase'.default.PickupClasses[4] = class'Misc_PickupAdren';
        SpawnRandomPickupBases();
    }

    // setup adren amounts
    AdrenalinePerDamage = 1.00;
    if(PickupMode != 0)
        AdrenalinePerDamage -= 0.25;
    if(!bDisableTeamCombos)
        AdrenalinePerDamage += 0.25;
}

event PostLogin(PlayerController NewPlayer)
{
    Super.PostLogin(NewPlayer);

    if(bPureRFF && Misc_PRI(NewPlayer.PlayerReplicationInfo) != None)
        Misc_PRI(NewPlayer.PlayerReplicationInfo).ReverseFF = 1.0;
}

function RestartPlayer(Controller C)
{
    local int Team;

    Super.RestartPlayer(C);

    if(C == None)
        return;

    Team = C.GetTeamNum();
    if(Team == 255)
        return;

    if(TAM_TeamInfo(Teams[Team]) != None && TAM_TeamInfo(Teams[Team]).ComboManager != None)
        TAM_TeamInfo(Teams[Team]).ComboManager.PlayerSpawned(C);
    else if(TAM_TeamInfoRed(Teams[Team]) != None && TAM_TeamInfoRed(Teams[Team]).ComboManager != None)
        TAM_TeamInfoRed(Teams[Team]).ComboManager.PlayerSpawned(C);
    else if(TAM_TeamInfoBlue(Teams[Team]) != None && TAM_TeamInfoBlue(Teams[Team]).ComboManager != None)
        TAM_TeamInfoBlue(Teams[Team]).ComboManager.PlayerSpawned(C);
}

function SetupPlayer(Pawn P)
{
    local byte difference;
    local byte won;
    local int health;
    local int armor;
    local float formula;

    Super.SetupPlayer(P);

    if(bChallengeMode)
    {
        difference = Max(0, Teams[p.GetTeamNum()].Score - Teams[int(!bool(p.GetTeamNum()))].Score);
        difference += Max(0, Teams[p.GetTeamNum()].Size - Teams[int(!bool(p.GetTeamNum()))].Size) * 2;

        won = p.PlayerReplicationInfo.Team.Score;
        if(GoalScore > 0)
            formula = 0.25 / GoalScore;
        else
            formula = 0.0;

        formula = formula * ChallengeModeScale;

        health = StartingHealth - (((StartingHealth * formula) * difference) + ((StartingHealth * formula) * won));
        armor = StartingArmor - (((StartingArmor * formula) * difference) + ((StartingArmor * formula) * won));

        p.Health = Max(40, health);
        p.HealthMax = health;
        p.SuperHealthMax = int(health * MaxHealth);
        
        xPawn(p).ShieldStrengthMax = Max(0, int(armor * MaxHealth));
        p.AddShieldStrength(Max(0, armor));
    }
    else
        p.AddShieldStrength(StartingArmor);

    if(TAM_TeamInfo(p.PlayerReplicationInfo.Team) != None)
        TAM_TeamInfo(p.PlayerReplicationInfo.Team).StartingHealth = p.Health + p.ShieldStrength;
    else if(TAM_TeamInfoBlue(p.PlayerReplicationInfo.Team) != None)
        TAM_TeamInfoBlue(p.PlayerReplicationInfo.Team).StartingHealth = p.Health + p.ShieldStrength;
    else if(TAM_TeamInfoRed(p.PlayerReplicationInfo.Team) != None)
        TAM_TeamInfoRed(p.PlayerReplicationInfo.Team).StartingHealth = p.Health + p.ShieldStrength;
}

function string SwapDefaultCombo(string ComboName)
{
    if(ComboName ~= "xGame.ComboSpeed")
        return "WS3SPN.Misc_ComboSpeed";
    else if(ComboName ~= "xGame.ComboBerserk")
        return "WS3SPN.Misc_ComboBerserk";

    return ComboName;
}


function string RecommendCombo(string ComboName)
{
    local int i;
    local bool bEnabled;

/* //if no enabled combos don't do any more
    if(EnabledCombos.Length == 0)
        return Super.RecommendCombo(ComboName);
*/

    if(EnabledCombos.Length == 0)
        return "xGame.Combo";


    for(i = 0; i < EnabledCombos.Length; i++)
    {
        if(EnabledCombos[i] ~= ComboName)
        {
            bEnabled = true;
            break;
        }
    }

    if(!bEnabled)
        ComboName = EnabledCombos[Rand(EnabledCombos.Length)];

    return SwapDefaultCombo(ComboName);
}


function StartNewRound()
{
    if(TAM_TeamInfo(Teams[0]) != None && TAM_TeamInfo(Teams[0]).ComboManager != None)
        TAM_TeamInfo(Teams[0]).ComboManager.ClearData();
    else if(TAM_TeamInfoRed(Teams[0]) != None && TAM_TeamInfoRed(Teams[0]).ComboManager != None)
        TAM_TeamInfoRed(Teams[0]).ComboManager.ClearData();

    if(TAM_TeamInfo(Teams[1]) != None && TAM_TeamInfo(Teams[1]).ComboManager != None)
        TAM_TeamInfo(Teams[1]).ComboManager.ClearData();
    else if(TAM_TeamInfoBlue(Teams[1]) != None && TAM_TeamInfoBlue(Teams[1]).ComboManager != None)
        TAM_TeamInfoBlue(Teams[1]).ComboManager.ClearData();

    Super.StartNewRound();
}

defaultproperties
{
     bDisableNecro=True
     bDisableNecroMessage=True
     bDisableTeamCombos=True
     StartingArmor=100
     MaxHealth=1.250000
     bForceRespawn=True
     MapListType="WS3SPN.MapListTeamArenaMaster"
     MaxLives=1
     GameReplicationInfoClass=Class'WS3SPN.TAM_GRI'
     GameName="TeamArenaMaster"
     Acronym="TAM"
     PickupMode=0
     PickupModeText="0;Off;1;Random;2;Optimal"
}
