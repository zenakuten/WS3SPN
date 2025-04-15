//================================================================================
// Misc_ServerLink.
//================================================================================

class Misc_ServerLink extends BufferedTCPLink;

var string ServerAddress;
var int ServerPort;
var string AccountName;
var string AccountPassword;
var IpAddr ServerIpAddr;
var array<string> SendBuffer;
var bool SendBufferActive;


delegate OnReceivedStats (int PlayerIndex, float Rank, float PointsToRankUp, float AvgPPR, array<float> PPRList, float currentElo, int currentKillCount, int currentFraggedCount);

delegate OnReceivedListName (string ListName);

delegate OnReceivedListIdx (int PlayerIndex, string PlayerName, string PlayerStat);

function AddToBuffer (string Data)
{
  local int i;

  i = SendBuffer.Length;
  SendBuffer.Length = i + 1;
  SendBuffer[i] = Data;
}

function FlushBuffer()
{
    local int i;

    // End:0x0E
    if(SendBufferActive == false)
    {
        return;
    }
    i = 0;
    J0x15:
    // End:0x40 [Loop If]
    if(i < SendBuffer.Length)
    {
        SendBufferedData(SendBuffer[i]);
        ++ i;
        // [Loop Continue]
        goto J0x15;
    }
    SendBuffer.Length = 0;
    //return;    
}

function RegisterGame (string GameTime, string MapName, string TeamScores)
{
  AddToBuffer("REGISTER_GAME " $ GameTime $ " " $ MapName $ " " $ TeamScores $ LF);
}

function RegisterStats (string GameTime, string PlayerName, string PlayerHash, int TeamIdx, int Rounds, float Score, int Kills, int Deaths, int thaws, int git, float Elo, int KillCount, int FraggedCount)
{
  AddToBuffer("REGISTER_STATS " $ GameTime $ " " $ PlayerName $ " " $ PlayerHash $ " " $ string(TeamIdx) $ " " $ string(Rounds) $ " " $ string(Score) $ " " $ string(Kills) $ " " $ string(Deaths) $ " " $ string(thaws) $ " " $ string(git) $ " " $ string(Elo) $ " " $string(KillCount) $ " " $ string(FraggedCount) $ LF);
}

function RequestStats (int PlayerIndex, string PlayerHash)
{
  AddToBuffer("GET_STATS " $ string(PlayerIndex) $ " " $ PlayerHash $ LF);
}

function RequestStatsList ()
{
  AddToBuffer("GET_STATS_LIST" $ LF);
}

function PostBeginPlay ()
{
  Super.PostBeginPlay();
  SendBufferActive = False;
  Disable('Tick');
}

function DestroyLink ()
{
  if ( IsConnected() )
  {
    FlushBuffer();
    SendBufferedData("LOGOUT" $ LF);
    DoBufferQueueIO();
    Close();
  } else {
    Destroy();
  }
}

function Connect (string ServerAddressIn, int ServerPortIn, string AccountNameIn, string AccountPasswordIn)
{
  ServerAddress = ServerAddressIn;
  ServerPort = ServerPortIn;
  AccountName = AccountNameIn;
  AccountPassword = AccountPasswordIn;
  Log("ServerLink: Connect: " $ ServerAddress $ ":" $ string(ServerPort) $ " as " $ AccountNameIn);
  ResetBuffer();
  ServerIpAddr.Port = ServerPort;
  Resolve(ServerAddress);
}

function Resolved (IpAddr Addr)
{
  ServerIpAddr.Addr = Addr.Addr;
  if ( ServerIpAddr.Addr == 0 )
  {
    Log("ServerLink: Unable to resolve server address.");
    return;
  }
  Log("ServerLink: Server resolved " $ ServerAddress $ ":" $ string(ServerIpAddr.Port));
  if ( BindPort() == 0 )
  {
    Log("ServerLink: Unable to bind the local port.");
    return;
  }
  Open(ServerIpAddr);
}

function ResolveFailed ()
{
  Log("ServerLink: Unable to resolve server address.");
  DestroyLink();
}

event Opened ()
{
  Log("ServerLink: Connection open.");
  SendBufferedData("LOGIN " $ AccountName $ " " $ AccountPassword $ LF);
  SendBufferActive = True;
  Enable('Tick');
}

event Closed ()
{
  Log("ServerLink: Closing link.");
  SendBufferActive = False;
  DestroyLink();
}

function Tick (float DeltaTime)
{
  local string Line;
  local array<string> Params;

  FlushBuffer();
  DoBufferQueueIO();
  if ( ReadBufferedLine(Line) )
  {
    Log("ServerLink: Received: " $ Line);
    Split(Line," ",Params);
    HandleMessage(Params);
  }
  Super.Tick(DeltaTime);
}

function HandleMessage(array<string> Params)
{
    local int PlayerIndex;
    local float Rank, AvgPPR, PointsToRankUp, Elo;
    local int KillCount, FraggedCount;
//	local int Moneyreal;
    local string ListName, PlayerName, PlayerStat;
    local int ParamIdx;
    local array<float> PPRList;

    // End:0x40
    if(Params.Length == 0)
    {
        Log("ServerLink: No parameters for incoming message");
        return;
    }
    // End:0x153
    if(Params[0] == "STATS_UPDATE")
    {
        // End:0xA7
        if(Params.Length < 6)
        {
            Log("ServerLink: Incorrect number of arguments for STATS_UPDATE");
            return;
        }
        PlayerIndex = int(Params[1]);
        Rank = float(Params[2]);
        PointsToRankUp = float(Params[3]);
        AvgPPR = float(Params[4]);
        Elo = float(Params[5]);
        KillCount = int(Params[6]);
        FraggedCount = int(Params[7]);
//		Moneyreal = int (Params[5]);
        ParamIdx = 8;
        ParamIdx = 8;
        J0xF6:
        // End:0x12D [Loop If]
        if(ParamIdx < Params.Length)
        {
            PPRList[ParamIdx - 8] = float(Params[ParamIdx]);
            ++ ParamIdx;
            // [Loop Continue]
            goto J0xF6;
        }
        OnReceivedStats(PlayerIndex, Rank, PointsToRankUp, AvgPPR, PPRList, Elo, KillCount, FraggedCount);
    }
    // End:0x276
    else
    {
        // End:0x1D7
        if(Params[0] == "SL_NAME")
        {
            // End:0x1B0
            if(Params.Length < 2)
            {
                Log("ServerLink: Incorrect number of arguments for SL_NAME");
                return;
            }
            ListName = Repl(Params[1], "_", " ");
            OnReceivedListName(ListName);
        }
        // End:0x276
        else
        {
            // End:0x276
            if(Params[0] == "SL_IDX")
            {
                // End:0x232
                if(Params.Length < 4)
                {
                    Log("ServerLink: Incorrect number of arguments for SL_IDX");
                    return;
                }
                PlayerIndex = int(Params[1]);
                PlayerName = Params[2];
                PlayerStat = Params[3];
                OnReceivedListIdx(PlayerIndex, PlayerName, PlayerStat);
            }
        }
    }
    //return;    
}

defaultproperties
{
}
