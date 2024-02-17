//================================================================================
// NecroCombo.
//================================================================================

class NecroCombo extends Combo
  
  HideCategories(Movement,Collision,Lighting,LightColor,Karma,Force);
#exec SOUND IMPORT NAME=Thaw FILE=Sounds\thaw.wav GROUP=Sounds 
var() config float NecroScoreAward;
var() config float ShieldOnResurrect;
var() config float SacrificePercentage;
var() config int HealthOnResurrect;
var() config bool bSacrificeHealth;
var() config bool bShareHealth;
var() config bool bUseBuzzSound;
var() config bool bOnlyPlayerHearsSound;
var()  string PropsDisplayText[8];
var()  string PropsDescText[8];
var Controller Resurrectee;
var bool            endgame;  


static function float GetResRating (Controller C)
{
  if ( C.PlayerReplicationInfo == None )
  {
    return 0.0;
  }
  if ( C.PlayerReplicationInfo.bBot )
  {
    return 0.01 + C.Adrenaline * 0.05;
  }
  if ( C.Adrenaline < 100 )
  {
    return 1.0 + C.Adrenaline;
  }
  return 1000.0 - C.PlayerReplicationInfo.Score;
}

static function Controller PickWhoToRes (TeamInfo Team, optional Controller NecroMancer)
{
  local Controller C;
  local float curr;
  local float BestR;
  local Controller TheLucky;

  C = Team.Level.ControllerList;
    J0x1D:
    
    if(C != none)
    {
        
        if(C == NecroMancer)
        {
        }
        
        else
        {
           
            if(C.PlayerReplicationInfo == none)
            {
            }
          
            else
            {
                
                if(C.PlayerReplicationInfo.bOnlySpectator || !C.PlayerReplicationInfo.bOutOfLives)
                {
                }
             
                else
                {
                    
                    if((!C.IsA('PlayerController') && !C.PlayerReplicationInfo.bBot) || C.Pawn != none)
                    {
                    }
                    
                    else
                    {
                        
                        if(C.PlayerReplicationInfo.Team != Team)
                        {
                        }
						
						
                       
                        else
                        {
                           
                            if(C.PlayerReplicationInfo.bBot || PlayerController(C) != none)
                            {
                                curr = GetResRating(C);
                                
                                if(BestR < curr)
                                {
                                    BestR = curr;
                                    TheLucky = C;
                                }
                            }
                        }
                    }
                }
            }
        }
        C = C.nextController;
        
        goto J0x1D;
    }
    return TheLucky;
     
}

function StopEffect (xPawn P)
{
}

function StartEffect (xPawn P)
{
  if ( (P.Controller == None) || (P.PlayerReplicationInfo == None) )
  {
    Destroy();
    return;
  }
  Resurrectee = PickWhoToRes(P.PlayerReplicationInfo.Team,P.Controller);
  DoResurrection();
}

function Abort (bool bEndOfRoundError)
{
  local Controller NecroMancer;
  local Pawn P;
  local float rnd;
  local Sound soundToPlay;
	
  P = Pawn(Owner);
  if ( P != None )
  {
    NecroMancer = Pawn(Owner).Controller;
  }
  if ( NecroMancer != None )
  {
    TeamPlayerReplicationInfo(NecroMancer.PlayerReplicationInfo).Combos[4]--;
  }
  if ( PlayerController(NecroMancer) != None )
  {
      if(bUseBuzzSound)
      {
          soundToPlay = Sound'ShortCircuit';
      }
      else
      {
        rnd = FRand();
        if(rnd < 0.33)
            soundToPlay = Sound'Meow1';
        else if(rnd < 0.66)
            soundToPlay = Sound'Meow2';
        else
            soundToPlay = Sound'Meow3';
      }

      if(bOnlyPlayerHearsSound)
      {
        if(Misc_Player(NecroMancer) != None)
        {
            Misc_Player(NecroMancer).AbortNecro();
        }
        else  
        {
            PlayerController(NecroMancer).ClientPlaySound(soundToPlay,false,300.0, SLOT_None);
        }
      }
      else
      {
        PlaySound(soundToPlay, SLOT_None, 300.0);
      }
  }
  
  if(bEndOfRoundError)
    {
        // End:0xBA
        if(P != none)
        {
            Pawn(Owner).ReceiveLocalizedMessage(class'NecroMessages', 4, none, none);
        }
    }
 else 
  { 
  
  if ( Level.Game.IsA('Freon') ) 
  
  {
    if ( P != None )
    {
      Pawn(Owner).ReceiveLocalizedMessage(Class'NecroMessages',3,None,None);
    }
  } 
  
  else 
  {
    if ( P != None )
    {
      Pawn(Owner).ReceiveLocalizedMessage(Class'NecroMessages',1,None,None);
    }  
  } 
  }
 
  Destroy();
} 



function DoResurrection ()
{
  local int ResurrecteeHealth;
  local float ResurrecteeShield;
  local float SacrificedHealth;
  local float SacrificedShield;
  local Inventory LeechInv;
  local Controller NecroMancer;
  local Pawn P;
  local NavigationPoint StartSpot;
  local int TeamNum;
  local Team_GameBase t;
  local Freon_Pawn xPawn;

  
	
  
  
  if ( Resurrectee == None)
  {
    Abort(false);
    return;
  }
  P = Pawn(Owner);
  if ( P == None )
  {
    Abort(false);
    return;
  }
  NecroMancer = P.Controller;
  if ( NecroMancer == None )
  {
    Abort(false);
    return;
  }
  
  t = Team_GameBase(Level.Game);
    // End:0x14B
    if((((t != none) && (t.Teams[1].Score + float(1)) != float(t.GoalScore)) && (t.Teams[0].Score + float(1)) != float(t.GoalScore)) && ((t.bRespawning || t.bEndOfRound) || t.EndOfRoundTime > 0) || t.NextRoundTime > 0)
    {
        Abort(true);
        return;
    }
	
  if ( Freon_Player(Resurrectee) != None )
  {
    xPawn = Freon_Player(Resurrectee).FrozenPawn;
  } else {
    if ( Freon_Bot(Resurrectee) != None )
    {
      xPawn = Freon_Bot(Resurrectee).FrozenPawn;
    }
  }
  if ( xPawn != None )
  {
    if ( (Freon(Level.Game) == None) || (Freon(Level.Game).TeleportOnThaw == False) )
    {
      if ( (Resurrectee.PlayerReplicationInfo == None) || (Resurrectee.PlayerReplicationInfo.Team == None) )
      {
        TeamNum = 255;
      } else {
        TeamNum = Resurrectee.PlayerReplicationInfo.Team.TeamIndex;
      }
      StartSpot = Level.Game.FindPlayerStart(Resurrectee,TeamNum);
      if ( StartSpot != None )
      {
        xPawn.SetLocation(StartSpot.Location);
        xPawn.SetRotation(StartSpot.Rotation);
        xPawn.Velocity = vect(0.00,0.00,0.00);
      }
    }
    xPawn.Thaw();
    PlaySound(Sound'Thaw', SLOT_None, 300.0);
    BroadcastLocalizedMessage(Class'NecroMessages',2,NecroMancer.PlayerReplicationInfo,Resurrectee.PlayerReplicationInfo);
  } else {
    Resurrectee.PlayerReplicationInfo.bOutOfLives = False;
    Resurrectee.PlayerReplicationInfo.NumLives = 1;
    Level.Game.RestartPlayer(Resurrectee);
    if ( Resurrectee.Pawn == None )
    {
      Abort(false);
      return;
    }
    if ( PlayerController(Resurrectee) != None )
    {
      PlayerController(Resurrectee).ClientReset();
    }
    if ( (Team_GameBase(Level.Game) != None) && (Team_GameBase(Level.Game).bSpawnProtectionOnRez == False) && (Misc_Pawn(Resurrectee.Pawn) != None) )
    {
      Misc_Pawn(Resurrectee.Pawn).DeactivateSpawnProtection();
    }
    if ( Misc_Pawn(Resurrectee.Pawn) != None )
    {
      Misc_Pawn(Resurrectee.Pawn).SpawnedIconTimer = Level.TimeSeconds + 0.2;
    }
    PlaySound(Sound'Resurrection',SLOT_None,300);
    BroadcastLocalizedMessage(Class'NecroMessages',0,NecroMancer.PlayerReplicationInfo,Resurrectee.PlayerReplicationInfo);
  }
  ResurrecteeHealth = HealthOnResurrect;
  ResurrecteeShield = ShieldOnResurrect;
  if ( bSacrificeHealth )
  {
    SacrificePercentage = FClamp(SacrificePercentage,0.0,1.0);
    SacrificedHealth = P.Health / 100.0;
    SacrificedHealth *= SacrificePercentage * 100;
    SacrificedHealth = Clamp(int(SacrificedHealth),int(SacrificedHealth),P.Health);
    SacrificedShield = P.ShieldStrength / 100 * SacrificePercentage * 100;
    if ( bShareHealth )
    {
      ResurrecteeHealth = int(SacrificedHealth);
      ResurrecteeShield = SacrificedShield;
    }
    if ( P.FindInventoryType(Class'NecroLeech') == None )
    {
      LeechInv = Spawn(Class'NecroLeech',P,,);
      if ( LeechInv != None )
      {
        LeechInv.GiveTo(P);
        NecroLeech(LeechInv).LeechAmount = int(SacrificedHealth);
        NecroLeech(LeechInv).ShieldLeechAmount = SacrificedShield;
      }
    }
  }
  Resurrectee.Pawn.Health = ResurrecteeHealth;
  Resurrectee.Pawn.ShieldStrength = ResurrecteeShield;
  if ( Misc_Player(Resurrectee) != None )
  {
    Misc_Player(Resurrectee).LastRezTime = Level.TimeSeconds;
  }
  NecroMancer.Adrenaline -= AdrenalineCost;
  NecroMancer.PlayerReplicationInfo.Score += NecroScoreAward;
  if ( (Team_GameBase(Level.Game) != None) && (Team_GameBase(Level.Game).DarkHorse == NecroMancer) )
  {
    Team_GameBase(Level.Game).DarkHorse = None;
  }
  if(Misc_PRI(NecroMancer.PlayerReplicationInfo) != None)
  {
     Misc_PRI(NecroMancer.PlayerReplicationInfo).ResCount++;
  }
  Destroy();
}

static function FillPlayInfo (PlayInfo PlayInfo)
{
  local int i;

  Super.FillPlayInfo(PlayInfo);
  PlayInfo.AddSetting("Necro Combo v3","NecroScoreAward",Default.PropsDisplayText[i++ ],0,10,"Text");
  PlayInfo.AddSetting("Necro Combo v3","HealthOnResurrect",Default.PropsDisplayText[i++ ],0,10,"Text");
  PlayInfo.AddSetting("Necro Combo v3","ShieldOnResurrect",Default.PropsDisplayText[i++ ],0,10,"Text");
  PlayInfo.AddSetting("Necro Combo v3","bSacrificeHealth",Default.PropsDisplayText[i++ ],0,10,"Check");
  PlayInfo.AddSetting("Necro Combo v3","SacrificePercentage",Default.PropsDisplayText[i++ ],0,10,"Text");
  PlayInfo.AddSetting("Necro Combo v3","bShareHealth",Default.PropsDisplayText[i++ ],0,10,"Check");
  PlayInfo.AddSetting("Necro Combo v3","bUseBuzzSound",Default.PropsDisplayText[i++ ],0,10,"Check");
  PlayInfo.AddSetting("Necro Combo v3","bOnlyPlayerHearsSound",Default.PropsDisplayText[i++ ],0,10,"Check");
}

static function string GetDescriptionText (string PropName)
{
  switch (PropName)
  {
    case "NecroScoreAward":
    return Default.PropsDescText[0];
    case "HealthOnResurrect":
    return Default.PropsDescText[1];
    case "ShieldOnResurrect":
    return Default.PropsDescText[2];
    case "bSacrificeHealth":
    return Default.PropsDescText[3];
    case "SacrificePercentage":
    return Default.PropsDescText[4];
    case "bShareHealth":
    return Default.PropsDescText[5];
    case "bUseBuzzSound":
    return Default.PropsDescText[6];
    case "bOnlyPlayerHearsSound":
    return Default.PropsDescText[7];
    default:
  }
  return Super.GetDescriptionText(PropName);
}

function Tick (float DeltaTime);

defaultproperties
{
    bUseBuzzSound=false
    bOnlyPlayerHearsSound=false
     NecroScoreAward=5.000000
     ShieldOnResurrect=70.000000
     HealthOnResurrect=70
     PropsDisplayText(0)="Necro Score Award"
     PropsDisplayText(1)="Health When Resurrected"
     PropsDisplayText(2)="Shield When Resurrected"
     PropsDisplayText(3)="bSacrificeHealth"
     PropsDisplayText(4)="SacrificePercentage"
     PropsDisplayText(5)="bShareHealth"
     PropsDisplayText(6)="bUseBuzzSound"
     PropsDisplayText(7)="bOnlyPlayerHearsSound"
     PropsDescText(0)="How many points should the player receive for performing the necro combo"
     PropsDescText(1)="How much health the resurrectee should spawn with."
     PropsDescText(2)="How much shield the resurrectee should spawn with."
     PropsDescText(3)="Should the Necromancer Sacrifice their Health and Shield? (A percentage of health is taken away from the necromancer and given to the player ressed, as their starting health)."
     PropsDescText(4)="The percentage of health to be sacrificed from the necromancer and given to the player being ressed as starting health."
     PropsDescText(5)="If true, the health lost by the necromancer will be given to the ressed player instead of the health specified in HealthOnResurrect and ShieldOnResurrect (bSacrificeHalth needs to be true for this setting to work)."
     PropsDescText(6)="If true, use buzz sound when there is nobody to res (abort).  False is kitty meow"
     PropsDescText(7)="If true, only the player that tried to res hears the abort sound"
     Duration=1.000000
     keys(0)=1
     keys(1)=1
     keys(2)=2
     keys(3)=2
}
