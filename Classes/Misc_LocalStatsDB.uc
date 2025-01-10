//================================================================================
// Misc_LocalStatsDB.
//================================================================================

class Misc_LocalStatsDB extends Object
  PerObjectConfig
  Config(WS3SPN_Stats);

const MIN_ROUNDS_FOR_LIST= 10;
const PURGE_TIME= 86400;
const EXPIRE_TIME= 43200;
const MAX_RANK= 30;
const MIN_RANK= 0;
const SCORE_PER_RANK= 2500;
const AVG_PPR_BASE= 20;
struct PlayerRecord
{
  var string Time;
  var int Rounds;
  var float Score;
  var int Kills;
  var int Deaths;
  //var int Money;
};

var const string ConfigName;
var config private string PlayerName;
var config private int RankedScore;
var config private int TopScore;
var config private float Elo;
//var config private int Money;
//var config private int Moneyreal;
var config private array<PlayerRecord> Rec;


static function Misc_LocalStatsDB GetFor(string Id)
{
    local Misc_LocalStatsDB StatsDB;
	

    // End:0x0E
    if(Id == "")
    {
        return none;
    }
    StatsDB = Misc_LocalStatsDB(FindObject("Package." $ Id, default.Class));
    // End:0x53
    if(StatsDB == none)
    {
        StatsDB = new (none, Id) default.Class;
    }
    return StatsDB;
    //return;    
}

static function string GetCurrentTime (LevelInfo Level)
{
  return string(Level.Year) $ "-" $ Right("00" $ string(Level.Month),2) $ "-" $ Right("00" $ string(Level.Day),2) $ "T" $ Right("00" $ string(Level.Hour),2) $ ":" $ Right("00" $ string(Level.Minute),2);
}

static function int GetTimeStamp(int Year, int Month, int Day, int Hour, int Minute)
{
    local int stamp, YearRef, MonthRef, DayRef;

    YearRef = 2020;
    MonthRef = 1;
    DayRef = 1;
    // End:0x2E
    if(Year < YearRef)
    {
        return -1;
    }
    J0x2E:
    // End:0x94 [Loop If]
    if(Year > YearRef)
    {
        stamp += (365 + int((((float(YearRef) % float(4)) == float(0)) ^^ ((float(YearRef) % float(100)) == float(0))) ^^ ((float(YearRef) % float(400)) == float(0))));
        ++ YearRef;
        J0x94:
        // [Loop Continue]
        goto J0x2E;
    }
    // End:0x12F [Loop If]
    if(Month > MonthRef)
    {
        // End:0xFC
        if(MonthRef == 2)
        {
            stamp += (28 + int((((float(Year) % float(4)) == float(0)) ^^ ((float(Year) % float(100)) == float(0))) ^^ ((float(Year) % float(400)) == float(0))));
            // [Explicit Continue]
            goto J0x125;
        }
        stamp += (30 + int((float(MonthRef) % float(2)) == float(int(MonthRef < 8))));
        J0x125:
        ++ MonthRef;
        // [Loop Continue]
        goto J0x94;
    }
    return ((((stamp + (Day - DayRef)) * 24) + Hour) * 60) + Minute;
    //return;    
}
static function int TimeDiff (string Time1, string Time2)
{
  local int Stamp1;
  local int Stamp2;

  Stamp1 = GetTimeStamp(int(Left(Time1,4)),int(Mid(Time1,5,2)),int(Mid(Time1,8,2)),int(Mid(Time1,11,2)),int(Mid(Time1,14,2)));
  Stamp2 = GetTimeStamp(int(Left(Time2,4)),int(Mid(Time2,5,2)),int(Mid(Time2,8,2)),int(Mid(Time2,11,2)),int(Mid(Time2,14,2)));
  if ( (Stamp1 < 0) || (Stamp2 < 0) )
  {
    return 0;
  }
  return Stamp1 - Stamp2;
}

static function float Decimal (float Num)
{
  if ( Num > 0 )
  {
    return int((Num + 0.051) * 10) * 0.1;
  } else {
    return int((Num - 0.051) * 10) * 0.1;
  }
}

//function Readgeld (out int Moneyreal) {
//
//Moneyreal = Moneyreal;
//
//}
//
function ReadStats (out float Rank, out float PointsToRankUp, out float AvgPPR, out array<float> PPRList, out float currentElo)
{
  local int i;
  local int j;

  log("ReadStats");
  Rank = RankedScore / 2000 + 0.5;
  Rank = FMin(Rank / (30 - 0),1.0);
//  Moneyreal = Money;
  if ( Rank < 1 )
  {
    PointsToRankUp = 2000.0 - RankedScore % 2000;
  }
  i = Max(0,Rec.Length - 20);
  JL0073:
  if ( i < Rec.Length )
  {
    PPRList.Length = j + 1;
    PPRList[j] = Decimal(Rec[i].Score / Rec[i].Rounds);
    AvgPPR += PPRList[j++ ];
    i++;
    goto JL0073;
  }
  if ( j > 0 )
  {
    AvgPPR = Decimal(AvgPPR / j);
  }
  PPRList.Length = j + 1;
  PPRList[j] = 0.0;
  currentElo = Elo;
}

function WriteStats (string Time, string InPlayerName, int Rounds, float Score, int Kills, int Deaths, float currentElo)
{
  local int i;

  i = Rec.Length;
  Rec.Length = i + 1;
  PlayerName = InPlayerName;
  RankedScore += int(Score);
  Elo = currentElo;
  TopScore = Max(TopScore,int(Score));

  Rec[i].Time = Time;
  Rec[i].Rounds = Rounds;
  Rec[i].Score = Score;
  Rec[i].Kills = Kills;
  Rec[i].Deaths = Deaths;
 // Rec[i].Money = Money;
  SaveConfig();
}

function float CalculateStatData (string Time, int TimeRange, name StatType, name Aggregate)
{
  local int i;
  local float Data;
  local float Result;

  i = Rec.Length - 1;
  JL000F:
  if ( i >= 0 )
  {
    if ( TimeDiff(Time,Rec[i].Time) > TimeRange )
    {
      goto JL0171;
    }
    if ( Rec[i].Rounds < 10 )
    {
     
    }
    switch (StatType)
    {
      case 'PPR':
      Data = Decimal(Rec[i].Score / Rec[i].Rounds);
      break;
      case 'Score':
      Data = int(Rec[i].Score);
      break;
      case 'Kills':
      Data = Rec[i].Kills;
      break;
      case 'Deaths':
      Data = Rec[i].Deaths;
      break;
//	  case 'Money':
//      Data = Money;
//     break;
      default:
    }
    switch (Aggregate)
    {
      case 'sum':
      Result += Data;
      break;
      case 'Min':
      Result = Fmin(Result,Data);
      break;
      case 'Max':
      Result = Fmax(Result,Data);
      break;
      default:
    }
  
	JL0171:
	  i--;
    goto JL000F;
  }
  return Result;
}


function string GetPlayerName ()
{
  return PlayerName;
}

function int GetTopScore ()
{
  return TopScore;
}

//function int GetMoney ()
//{
//  return Money;
//}
//
function bool IsOutDated (string Time)
{
  local int i;

  if ( TimeDiff(Time,Rec[Rec.Length - 1].Time) > 86400 )
  {
    return True;
  }
  i = 0;
  JL0032:
  if ( i < Rec.Length - 20 )
  {
    if ( TimeDiff(Time,Rec[i].Time) < 43200 )
    {
     // goto JL0078;
    }
    i++;
	// JL0078:
    goto JL0032;
  }
  if ( i > 0 )
  {
    Rec.Remove (0,i);
    SaveConfig();
  }
  return False;
}

defaultproperties
{
     ConfigName="WS3SPN_Stats"
}
