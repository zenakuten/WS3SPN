//================================================================================
// Misc_PlayerDataManager_ServerLink.
//================================================================================

class Misc_PlayerDataManager_ServerLink extends Info
  
  HideCategories(Movement,Collision,Lighting,LightColor,Karma,Force);

var const bool bUseOwnPlayerID;
var array<Misc_PlayerData> PlayerDataArray;
var string ServerLinkAddress;
var int ServerLinkPort;
var string ServerLinkAccount;
var string ServerLinkPassword;
var Misc_ServerLink ServerLink;

function ConfigureServerLink (string ServerLinkAddressIn, int ServerLinkPortIn, string ServerLinkAccountIn, string ServerLinkPasswordIn)
{
  ServerLinkAddress = ServerLinkAddressIn;
  ServerLinkPort = ServerLinkPortIn;
  ServerLinkAccount = ServerLinkAccountIn;
  ServerLinkPassword = ServerLinkPasswordIn;
}

function PostBeginPlay ()
{
  Super.PostBeginPlay();
  SetTimer(30.0,True);
}

function Destroyed ()
{
  if ( ServerLink != None )
  {
    ServerLink.Close();
    ServerLink = None;
  }
  Super.Destroyed();
}

function Misc_ServerLink GetServerLink ()
{
  if ( ServerLink != None )
  {
    return ServerLink;
  }
  ServerLink = Spawn(Class'Misc_ServerLink');
  if ( ServerLink != None )
  {
    ServerLink.OnReceivedStats = self.ReceiveStats;
    ServerLink.OnReceivedListName = self.ReceiveListName;
    ServerLink.OnReceivedListIdx = self.ReceiveListIdx;
    ServerLink.Connect(ServerLinkAddress,ServerLinkPort,ServerLinkAccount,ServerLinkPassword);
  }
  return ServerLink;
}

function ServerRequestStats (int PlayerIndex, string PlayerHash)
{
  local Misc_ServerLink SL;

  SL = GetServerLink();
  if ( SL != None )
  {
    SL.RequestStats(PlayerIndex,PlayerHash);
  }
}

function ServerRequestStatsList ()
{
  local Misc_ServerLink SL;

  SL = GetServerLink();
  if ( SL != None )
  {
    SL.RequestStatsList();
  }
}

function ServerRegisterGame (string GameTime, string MapName, string TeamScores)
{
  local Misc_ServerLink SL;

  SL = GetServerLink();
  if ( SL != None )
  {
    SL.RegisterGame(GameTime,MapName,TeamScores);
  }
}

function ServerRegisterStats (string GameTime, string PlayerName, string PlayerHash, int TeamIdx, int Rounds, float Score, int Kills, int Deaths, int thaws, int git, float Elo)
{
  local Misc_ServerLink SL;

  SL = GetServerLink();
  if ( SL != None )
  {
    SL.RegisterStats(GameTime,PlayerName,PlayerHash,TeamIdx,Rounds,Score,Kills,Deaths,thaws,git,Elo);
  }
}

function string GetPlayerID (Misc_Player P)
{
  return Class'Misc_Util'.static.GetStatsID(P);
}

function Misc_PlayerData PlayerJoined(Misc_Player P)
{
    local Misc_PlayerData PD;
    local string StatsID;
    local int i;

    Log("PlayerJoined: " $ P.PlayerReplicationInfo.PlayerName);
    StatsID = GetPlayerID(P);
    // End:0x77
    if(StatsID == "")
    {
        Log("No stats ID for " $ P.PlayerReplicationInfo.PlayerName);
        return none;
    }
    i = 0;
    J0x7E:
    // End:0x158 [Loop If]
    if(i < PlayerDataArray.Length)
    {
        PD = PlayerDataArray[i];
        // End:0xAD
        if(PD == none)
        {
            // [Explicit Continue]
            goto J0x14E;
        }
        // End:0x14E
        if(PD.StatsID == StatsID)
        {
            Log("Existing player record found for " $ P.PlayerReplicationInfo.PlayerName);
            class'Misc_PlayerData'.static.AttachPlayerRecord(P, PD);
            // End:0x139
            if(bUseOwnPlayerID)
            {
                PD.StatsID = StatsID;
            }
            P.LoadPlayerData();
            return PD;
        }
        J0x14E:
        ++ i;
        // [Loop Continue]
        goto J0x7E;
    }
    PD = new class'Misc_PlayerData';
    class'Misc_PlayerData'.static.ResetTrackedData(PD.Current);
    class'Misc_PlayerData'.static.ResetStats(PD);
    class'Misc_PlayerData'.static.AttachPlayerRecord(P, PD);
    // End:0x1CE
    if(bUseOwnPlayerID)
    {
        PD.StatsID = StatsID;
    }
    PD.StatsReceived = false;
    i = PlayerDataArray.Length;
    PlayerDataArray.Length = i + 1;
    PlayerDataArray[i] = PD;
    Log("Requesting stats for player " $ P.PlayerReplicationInfo.PlayerName);
    ServerRequestStats(i, PD.StatsID);

    return none;
    //return;    
}

function PlayerLeft (Misc_Player P)
{
  Log("PlayerLeft: " $ P.PlayerReplicationInfo.PlayerName);
  P.StorePlayerData();
  if ( P.PlayerData != None )
  {
    Class'Misc_PlayerData'.static.DetachPlayerRecord(P.PlayerData);
  }
}

function PlayerChangedName (Misc_Player P)
{
  local string PlayerName;

  Log("PlayerChangedName: " $ P.PlayerReplicationInfo.PlayerName);
  PlayerName = Class'Misc_Util'.static.StripColor(P.PlayerReplicationInfo.PlayerName);
  if ( P.PlayerData != None )
  {
    P.PlayerData.OwnerName = PlayerName;
  }
}

function ReceiveStats (int PlayerIndex, float Rank, float PointsToRankUp, float AvgPPR, array<float> PPRList, float currentElo)
{
  local Misc_PlayerData PD;

    log("ReceiveStats");
  if ( PlayerIndex >= PlayerDataArray.Length )
  {
    return;
  }
  PD = PlayerDataArray[PlayerIndex];
  PD.Rank = Rank;
  PD.AvgPPR = AvgPPR;
  PD.Elo = currentElo;
  PD.PointsToRankUp = int(PointsToRankUp);
  PD.PPRList = PPRList;
  PD.PPRListLength = PPRList.Length;
//  PD.Moneyreal = Moneyreal;
  PD.StatsReceived = True;
  if ( PD.Owner != None )
  {
    PD.Owner.LoadPlayerDataStats();
    if(Misc_PRI(PD.Owner.PlayerReplicationInfo) != None)
    {
        Misc_PRI(PD.Owner.PlayerReplicationInfo).Elo = currentElo;
    }
  }
}

function ReceiveListName (string ListName)
{
  if ( Team_GameBase(Level.Game) != None )
  {
    Team_GameBase(Level.Game).SendStatsListNameToPlayers(ListName);
  }
}

function ReceiveListIdx (int PlayerIndex, string PlayerName, string PlayerStat)
{
  if ( Team_GameBase(Level.Game) != None )
  {
    Team_GameBase(Level.Game).SendStatsListIdxToPlayers(PlayerIndex,PlayerName,PlayerStat);
  }
}

function FinishMatch ()
{
  local Misc_PlayerData PD;
  local int i;
  local int PlayerCnt;
  local string TimeString;
  local string TeamScoreStr;
  local string MapName;
  local Team_GameBase TGB;

  TGB = Team_GameBase(Level.Game);
  if ( (TGB != None) && (TGB.Teams[0] != None) && (TGB.Teams[1] != None) )
  {
    if ( (TGB.Teams[0].Score == 0) && (TGB.Teams[1].Score == 0) )
    {
      return;
    }
    TeamScoreStr = string(int(TGB.Teams[0].Score)) $ "," $ string(int(TGB.Teams[1].Score));
  }
  Log("Registering match stats...");
  TimeString = Class'Misc_Util'.static.GetTimeStringFromLevel(Level);
  if ( TimeString == "" )
  {
    Log("Error: Unable to get match time");
    return;
  }
  PlayerCnt = 0;
  i = 0;
  JL0158:
  if ( i < PlayerDataArray.Length )
  {
    PD = PlayerDataArray[i];
    if ( PD == None )
    {
      goto JL0244;
    }
    if ( PD.Owner != None )
    {
      PD.Owner.StorePlayerData();
    }
    if ( (PD.Current.Score == 0) && (PD.Current.Kills == 0) && (PD.Current.Deaths == 0) && (PD.Current.thaws == 0) && (PD.Current.git == 0) )
    {
      goto JL0244;
    }
    ++PlayerCnt;
	JL0244:
    ++i;
    goto JL0158;
  }
  if ( PlayerCnt == 0 )
  {
    Log("No active players in match");
    return;
  }
  MapName = Class'Misc_Util'.static.GetMapName(Level);
  Log("Registering match with time: " $ TimeString $ ", map: " $ MapName $ ", team scores: " $ TeamScoreStr);
  ServerRegisterGame(TimeString,MapName,TeamScoreStr);
  i = 0;
  JL0303:
  if ( i < PlayerDataArray.Length )
  {
    PD = PlayerDataArray[i];
    if ( PD == None )
    {
      goto JL04C5;
    }
    if ( (PD.Current.Score == 0) && (PD.Current.Kills == 0) && (PD.Current.Deaths == 0) && (PD.Current.thaws == 0) && (PD.Current.git == 0) )
    {
      goto JL04C5;
    }
    Log("Sending results for " $ PD.OwnerID $ " - " $ PD.OwnerName $ " (index:" $ string(PD.StatsIndex) $ ")");
    ServerRegisterStats(TimeString,PD.OwnerName,PD.StatsID,PD.TeamIdx,PD.Current.Rounds,PD.Current.Score,PD.Current.Kills,PD.Current.Deaths,PD.Current.thaws,PD.Current.git,PD.Elo);
    JL04C5:
	++i;
    goto JL0303;
  }
}

function GetRandomStats ()
{
  ServerRequestStatsList();
}

function Timer ()
{
  local Misc_PlayerData PD;
  local int i;

  i = 0;
  JL0007:
  if ( i < PlayerDataArray.Length )
  {
    PD = PlayerDataArray[i];
    if ( PD == None )
    {
      goto JL0064;
    }
    if ( PD.StatsReceived == False )
    {
      ServerRequestStats(i,PD.StatsID);
    }
JL0064:
    ++i;
    goto JL0007;
  }
}

defaultproperties
{
}
