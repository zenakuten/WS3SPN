class Misc_PRI extends xPlayerReplicationInfo;

// NR = not automatically replicated


var bool bWarned;               // has been warned for camping (next time will receive penalty) - NR
var int CampCount;              // the number of times penalized for camping - NR
var int ConsecutiveCampCount;   // the number of times penalized for camping consecutively - NR

var int EnemyDamage;            // damage done to enemies - NR
var int AllyDamage;             // damage done to allies and self - NR
var float ReverseFF;            // percentage of friendly fire that is returned - NR
var int MinigunCount;	
var int FlawlessCount;          // number of flawless victories - NR
var int OverkillCount;          // number of overkills - NR
var int DarkHorseCount;         // number of darkhorses - NR
var int HatTrickCount;          // number of hat tricks - NR
var int LinkCount;
var int RoxCount;				// number of rocket kills
var int rocketsuicide;
var int PlayedRounds;           // the number of rounds that the player has played
var int PPRListLength;
var float Rank;
var float AvgPPR;
var float DamageTime;
var byte CurrentWeaponNum;
var float PPRList[30];
var float PointsToRankUp;
var int ShieldCount;
var int GrenCount;
var int BioCount;
var int ShockCount;
var float Elo;
var int KillCount;
var int FraggedCount;

const M_LN10 = 2.30258509299404568402;
var float ELO_BaseCoeff;
var float ELO_KFactor;

var int CurrentDamage;
var int CurrentDamage2;

var localized string StringDeadNoRez;

/* hitstats */
struct HitStat
{
    var int Fired;
    var int Hit;
    var int Damage;
};

struct HitStats
{
    var HitStat Primary;
    var HitStat Secondary;
};

var HitStats    Assault;
var HitStat     Bio;
var HitStats    Shock;
var HitStat     Combo;
var HitStats    Link;
var HitStats    Mini;
var HitStats    Flak;
var HitStat     Rockets;
var HitStat     Sniper;
var HitStat     ClassicSniper;

var int         SGDamage;
var int         HeadShots;
var float       AveragePercent;
/* hitstats */

var class<Misc_PawnReplicationInfo> PawnInfoClass;
var Misc_PawnReplicationInfo PawnReplicationInfo;
var UTComp_PRI UTCompPRI;

var int ResCount;

struct VsStats
{
    var string OpponentName;
    var int    PlayerID;
    var int    Wins;
    var int    Losses;
};

var array<VsStats> VsStatsList;


replication
{
    reliable if ( Role == ROLE_Authority )
        RegisterDamage, UpdateVsStats;
    unreliable if ( bNetDirty && (Role == ROLE_Authority) )
        PlayedRounds,Rank,AvgPPR,PointsToRankUp,PPRListLength,PPRList,PawnReplicationInfo, UTCompPRI,Elo;

    //debug
    reliable if (ROLE == ROLE_Authority)
        ClientEloChange;
}

event PostBeginPlay()
{
    Super.PostBeginPlay();

    if(!bDeleteMe && Level.NetMode != NM_Client)
    {
        PawnReplicationInfo = Spawn(PawnInfoClass, self,, vect(0,0,0), rot(0,0,0));
    }
    UTCompPRI = class'UTComp_Util'.static.GetUTCompPRI(self);
}

simulated function string GetColoredName()
{
    if(UTCompPRI == None || UTCompPRI.ColoredName == "")
        return PlayerName;

    return UTCompPRI.ColoredName;
}

simulated function RegisterDamage (int Damage, byte WeaponNum)
{
  if ( (Level.TimeSeconds - DamageTime > 1) || (CurrentDamage > 0) ^^ (Damage > 0) )
  {
    CurrentDamage = 0;
  }
  if ( (Level.TimeSeconds - DamageTime > 0.34999999) || (CurrentDamage2 > 0) ^^ (Damage > 0) || (WeaponNum != CurrentWeaponNum) )
  {
    CurrentDamage2 = 0;
  }
  DamageTime = Level.TimeSeconds;
  CurrentWeaponNum = WeaponNum;
  CurrentDamage += Damage;
  CurrentDamage2 += Damage;
}

simulated function string GetColoredName2(Color OrigColor)
{
    // End:0x12
    if(UTCompPRI == None || UTCompPRI.ColoredName == "")
    {
        return PlayerName;
    }
    return UTCompPRI.ColoredName $ class'DMStatsScreen'.static.MakeColorCode(OrigColor);
    //return;    
}

simulated function string GetLocationName()
{
    if(bOutOfLives && !bOnlySpectator)
        return default.StringDead;
    return Super.GetLocationName();
}

static function string GetFormattedPPR(float val)
{
	local string ret;
	
	if(int((val - int(val)) * 10) < 0)
	{
		if(int(val) == 0)
			ret = "-"$string(int(val));
		else
			ret = string(int(val));
		ret = ret$"."$-int((val - int(val)) * 10);
	}
	else
	{
		ret = string(int(val));
		ret = ret$"."$int((val - int(val)) * 10);
	}
	
	return ret;
}

function Reset()
{
//	Super.Reset();
//	Score = 0;
//	Deaths = 0;
	HasFlag = None;
	bReadyToPlay = false;
	NumLives = 0;
	bOutOfLives = false;
}

function ProcessHitStats()
{
    local int count;

    AveragePercent = 0.0;

    if(Assault.Primary.Fired > 9)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Assault.Primary.Fired, Assault.Primary.Hit);
        count++;
    }

    if(Assault.Secondary.Fired > 2)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Assault.Secondary.Fired, Assault.Secondary.Hit);
        count++;
    }

    if(Bio.Fired > 0)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Bio.Fired, Bio.Hit);
        count++;
    }

    if(Shock.Primary.Fired > 4)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Shock.Primary.Fired, Shock.Primary.Hit);
        count++;
    }

    if(Shock.Secondary.Fired > 4)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Shock.Secondary.Fired, Shock.Secondary.Hit);
        count++;
    }

    if(Combo.Fired > 2)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Combo.Fired, Combo.Hit);
        count++;
    }

    if(Link.Primary.Fired > 9)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Link.Primary.Fired, Link.Primary.Hit);
        count++;
    }

    if(Link.Secondary.Fired > 14)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Link.Secondary.Fired, Link.Secondary.Hit);
        count++;
    }

    if(Mini.Primary.Fired > 19)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Mini.Primary.Fired, Mini.Primary.Hit);
        count++;
    }

    if(Mini.Secondary.Fired > 14)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Mini.Secondary.Fired, Mini.Secondary.Hit);
        count++;
    }

    if(Flak.Primary.Fired > 19)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Flak.Primary.Fired / 9, Flak.Primary.Hit / 9);
        count++;
    }

    if(Flak.Secondary.Fired > 2)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Flak.Secondary.Fired, Flak.Secondary.Hit);
        count++;
    }

    if(Rockets.Fired > 2)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Rockets.Fired, Rockets.Hit);
        count++;
    }

    if(Sniper.Fired > 2)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(Sniper.Fired, Sniper.Hit);
        count++;
    }

    if(ClassicSniper.Fired > 2)
    {
        AveragePercent += class'Misc_StatBoard'.static.GetPercentage(ClassicSniper.Fired, ClassicSniper.Hit);
        count++;
    }
    

    if(count > 0)
        AveragePercent /= count;
}

simulated function UpdateVsStats( string OpponentName, int PlayerID, bool bWin )
{
    local int i;
    local VsStats NewVsStats;

    for ( i = 0; i < VsStatsList.Length; i++ )
    {
        if (VsStatsList[i].PlayerID == PlayerID ) {

            // in case name change
            VsStatsList[i].OpponentName = OpponentName;

            if ( bWin ) {
                VsStatsList[i].Wins++;
            } else {
                VsStatsList[i].Losses++;
            }

            return;
        }
    }

    NewVsStats.OpponentName = OpponentName;
    NewVsStats.PlayerID = PlayerID;

    if ( bWin ) {
        NewVsStats.Wins++;
    } else {
        NewVsStats.Losses++;
    }

    VsStatsList[VsStatsList.Length] = NewVsStats;
}

simulated function ResetStats()
{
    Assault.Primary.Fired = 0;
    Assault.Primary.Hit = 0;
    Assault.Primary.Damage = 0;

    Assault.Secondary.Fired = 0;
    Assault.Secondary.Hit = 0;
    Assault.Secondary.Damage = 0;

    Bio.Fired = 0;
    Bio.Hit = 0;
    Bio.Damage = 0;

    Shock.Primary.Fired = 0;
    Shock.Primary.Hit = 0;
    Shock.Primary.Damage = 0;

    Shock.Secondary.Fired = 0;
    Shock.Secondary.Hit = 0;
    Shock.Secondary.Damage = 0;

    Combo.Fired = 0;
    Combo.Hit = 0;
    Combo.Damage = 0;

    Link.Primary.Fired = 0;
    Link.Primary.Hit = 0;
    Link.Primary.Damage = 0;

    Link.Secondary.Fired = 0;
    Link.Secondary.Hit = 0;
    Link.Secondary.Damage = 0;

    Mini.Primary.Fired = 0;
    Mini.Primary.Hit = 0;
    Mini.Primary.Damage = 0;

    Mini.Secondary.Fired = 0;
    Mini.Secondary.Hit = 0;
    Mini.Secondary.Damage = 0;

    Flak.Primary.Fired = 0;
    Flak.Primary.Hit = 0;
    Flak.Primary.Damage = 0;

    Flak.Secondary.Fired = 0;
    Flak.Secondary.Hit = 0;
    Flak.Secondary.Damage = 0;

    Rockets.Fired = 0;
    Rockets.Hit = 0;
    Rockets.Damage = 0;

    Sniper.Fired = 0;
    Sniper.Hit = 0;
    Sniper.Damage = 0;

    ClassicSniper.Fired = 0;
    ClassicSniper.Hit = 0;
    ClassicSniper.Damage = 0;

    SGDamage = 0;
    HeadShots = 0;
    AveragePercent = 0.0;

    VsStatsList.Length = 0;

    bWarned = false;
    EnemyDamage = 0;
    AllyDamage = 0;
    ReverseFF = 0;
    MinigunCount = 0;
    FlawlessCount = 0;
    OverkillCount = 0;
    DarkHorseCount = 0;
    HatTrickCount = 0;
    LinkCount = 0;
    RoxCount = 0;
    ShockCount = 0;
    rocketsuicide = 0;
    ShieldCount = 0;
    GrenCount = 0;
    BioCount = 0;
    CurrentDamage = 0;
    CurrentDamage2 = 0;
    CampCount = 0;
    ConsecutiveCampCount = 0;
}

static function float CalcElo(float elo1, float elo2, float kfactor)
{
    local float expected;

    expected = 1 / (exp(M_LN10 * (abs(elo1 - elo2) / default.ELO_BaseCoeff)) + 1);
    return kfactor * (1 - expected);
}

function ScoreElo(Misc_PRI killed)
{
    local float newElo;

    newElo = static.CalcElo(Elo, killed.Elo, GetKFactor(killed));

    Elo = Max(0, Elo + newElo);
    killed.Elo = Max(0, killed.Elo - newElo);

    KillCount++;
    killed.FraggedCount++;

    //debug
    //ClientEloChange(newElo);
    //killed.ClientEloChange(-newElo);
}

// scale kfactor based on elo delta
function float GetKFactor(Misc_PRI killed)
{
    local float kfactor;

    if(Elo >= killed.Elo)
    {
        // get less points for fragging a noob
        if(Abs(Elo - killed.Elo) > 20000)
            kfactor = 20.0;
        else if(Abs(Elo - Killed.Elo) > 10000)
            kfactor = 30.0;
        else if(Abs(Elo - Killed.Elo) > 5000)
            kfactor = 40.0;
        else 
            kfactor = 50.0;
    }
    else
    {
        // get more points for fragging a pro
        if(Abs(Elo - killed.Elo) > 20000)
            kfactor = 50.0;
        else if(Abs(Elo - Killed.Elo) > 10000)
            kfactor = 40.0;
        else if(Abs(Elo - Killed.Elo) > 5000)
            kfactor = 30.0;
        else 
            kfactor = 20.0;
    }

    return kfactor;
}

simulated function ClientEloChange(float eloChange)
{
    local PlayerController PC;
    PC = Level.GetLocalPlayerController();
    if(PC != None)
    {
        PC.ClientMessage("Elo change for "$PlayerName$" ("$Elo$") : "$eloChange);
    }
}

defaultproperties
{
     StringDeadNoRez="Dead [Inactive]"
     PawnInfoClass=Class'WS3SPN.Misc_PawnReplicationInfo'
     ELO_BaseCoeff=400
     ELO_KFactor=21
}
