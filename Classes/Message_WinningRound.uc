//================================================================================
// Message_WinningRound.
//================================================================================

class Message_WinningRound extends LocalMessage;
#exec AUDIO IMPORT FILE=Sounds\MatchPoint.wav GROUP=Sounds
#exec AUDIO IMPORT FILE=Sounds\sudden_death.wav GROUP=Sounds

var Sound SuddenDeathSound;
var Sound MatchPointSound;
var(Message) localized string RedTeamScores;
var(Message) localized string BlueTeamScores;
var(Message) localized string MatchPoint;
var(Message) localized string SuddenDeath;
var(Message) Color RedTeamColor;
var(Message) Color BlueTeamColor;

static function string GetString (optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( SwitchNum == 0 )
  {
    return Misc_BaseGRI(OptionalObject).ScoreboardRedTeamName @ Default.RedTeamScores;
  } else {
    if ( SwitchNum == 1 )
    {
      return Misc_BaseGRI(OptionalObject).ScoreboardBlueTeamName @ Default.BlueTeamScores;
    } else {
      if ( SwitchNum == 2 )
      {
        return Default.MatchPoint;
      } else {
        if ( SwitchNum == 3 )
        {
          return Default.SuddenDeath;
        }
      }
    }
  }
}

static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
  if ( SwitchNum == 2 )
  {
    P.ClientPlaySound(Default.MatchPointSound);
  }
  if ( SwitchNum == 3 )
  {
    P.ClientPlaySound(Default.SuddenDeathSound);
  }
}

static function Color GetColor (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
  if ( Switch == 0 )
  {
    return Default.RedTeamColor;
  } else {
    if ( Switch == 1 )
    {
      return Default.BlueTeamColor;
    } else {
      return Default.DrawColor;
    }
  }
}

defaultproperties
{
     SuddenDeathSound=Sound'3SPNvSoL.Sounds.sudden_death'
     MatchPointSound=Sound'3SPNvSoL.Sounds.MatchPoint'
     RedTeamScores="Red Team Scores"
     BlueTeamScores="Blue Team Scores"
     MatchPoint="THIS IS A MATCH POINT ROUND!"
     SuddenDeath="-- FINAL ROUND & Teams are Tied! -- "
     RedTeamColor=(R=255,A=255)
     BlueTeamColor=(B=255,A=255)
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=243,G=246,R=165)
     PosY=0.450000
}
