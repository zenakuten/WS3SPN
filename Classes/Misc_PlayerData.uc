//================================================================================
// Misc_PlayerData.
//================================================================================

class Misc_PlayerData extends Object;

struct TrackedData
{
  var int Rounds;
  var float Score;
  var int Kills;
  var int Deaths;
  var int thaws;
  var int git;
};

var Misc_Player Owner;
var string OwnerName;
var string OwnerID;
var int LastActiveTime;
var string StatsID;
var int StatsIndex;
var int TeamIdx;
var bool StatsReceived;
var float Rank;
var float AvgPPR;
var float Elo;
var int KillCount;
var int FraggedCount;
var int PointsToRankUp;
var int PPRListLength;
//var int Moneyreal;
var array<float> PPRList;
var config TrackedData Current;

static function AttachPlayerRecord (Misc_Player P, Misc_PlayerData PD)
{
  local string PlayerName;

  PlayerName = Class'Misc_Util'.static.StripColor(P.PlayerReplicationInfo.PlayerName);
  if ( P.PlayerReplicationInfo.Team != None )
  {
    PD.TeamIdx = P.PlayerReplicationInfo.Team.TeamIndex;
  }
  PD.OwnerName = PlayerName;
  PD.OwnerID = P.GetPlayerIDHash();
  PD.StatsID = Class'Misc_Util'.static.GetStatsID(P);
  PD.Owner = P;
  P.PlayerData = PD;
}

static function DetachPlayerRecord (Misc_PlayerData PD)
{
  if ( PD.Owner != None )
  {
    PD.Owner.PlayerData = None;
  }
  PD.Owner = None;
}

static function PlayerChangeName (Misc_Player P)
{
  local string PlayerName;

  if ( (P.PlayerData == None) || (P.PlayerReplicationInfo == None) )
  {
    return;
  }
  PlayerName = Class'Misc_Util'.static.StripColor(P.PlayerReplicationInfo.PlayerName);
  ReplaceText(PlayerName," ","_");
  ReplaceText(PlayerName,"]","_");
  P.PlayerData.OwnerName = PlayerName;
}

static function ResetStats (Misc_PlayerData PD)
{
  PD.Rank = 0.0;
  PD.AvgPPR = 0.0;
  PD.PointsToRankUp = 0;
  PD.PPRListLength = 0;
}

static function ResetTrackedData (out TrackedData D)
{
  D.Rounds = 0;
  D.Score = 0.0;
  D.Kills = 0;
  D.Deaths = 0;
  D.thaws = 0;
  D.git = 0;
}


defaultproperties
{
}
