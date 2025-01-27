class Team_HUDBase extends UTComp_HudCTeamDeathmatch
    abstract;

#exec TEXTURE IMPORT NAME=CHair FILE=Textures\chair.dds     GROUP=Textures MIPS=On ALPHA=1 DXT=5
#exec TEXTURE IMPORT NAME=Hudzaxis FILE=Textures\Hudzaxis.dds GROUP=Textures MIPS=On ALPHA=1 DXT=5

var Texture TeamTex;
var Texture Hudzaxis;
//var(Announce) bool bHadFlakhug;
//var(Announce) bool bHadAirRox;
var(Announce) bool bHadTerminator;
var Material TrackedPlayer;
var int OldRoundTime;
var Misc_Player myOwner;
var bool bSpawning;
var Color FullHealthColor;
var Color NameColor;
var Color LocationColor;
var Color AdrenColor;
var Color FullAdrenColor;
var(SpawnFX) Color RedSpawnEffectColor;
var(SpawnFX) Color BlueSpawnEffectColor;
var(SpawnFX) float SpawnEffectTime;
struct StatsListStruct
{
    var string ListName;
    var array<string> RowNames;
    var array<string> RowValues;
	var float RecvTime;
    var float RecvTimeRow;
};
var StatsListStruct StatsLists[4];
var int CurrentStatsList;

var array<vector> TargetingLines;
var Actor TargetingActor;

exec function ShowStats()
{
    bShowLocalStats = !bShowLocalStats;
    Misc_Player(PlayerOwner).bFirstOpen = bShowLocalStats;
}

static function Color StaticGetHealthRampColor(Misc_PRI PRI)
{
    local int StartHealth;
    local int CurrentHealth;
    local Color HealthColor;

    HealthColor = default.FullHealthColor;

    if(PRI == None)
        return HealthColor;

    CurrentHealth = Max(0,PRI.PawnReplicationInfo.Health + PRI.PawnReplicationInfo.Shield);

    if(TAM_TeamInfo(PRI.Team) != None)
        StartHealth = TAM_TeamInfo(PRI.Team).StartingHealth;
    else if(TAM_TeamInfoRed(PRI.Team) != None)
        StartHealth = TAM_TeamInfoRed(PRI.Team).StartingHealth;
    else if(TAM_TeamInfoBlue(PRI.Team) != None)
        StartHealth = TAM_TeamInfoBlue(PRI.Team).StartingHealth;
    else
        StartHealth = 200;


    if(CurrentHealth < StartHealth)
    {
        HealthColor.A = 255; //visible
        HealthColor.B = 0;
        HealthColor.R = Min(200, (400 * (float(StartHealth - CurrentHealth) / float(StartHealth))));

        if(HealthColor.R == 200)
            HealthColor.G = Min(200, (400 * (float(CurrentHealth) / float(StartHealth))));
        else
            HealthColor.G = 200;
    }

    return HealthColor;
}


function Color GetHealthRampColor(PlayerReplicationInfo PRI)
{
    return StaticGetHealthRampColor(Misc_PRI(PRI));
}

function Draw2DLocationDot(Canvas C, vector Loc, float OffsetX, float OffsetY, float ScaleX, float ScaleY)
{
    local rotator Dir;
    local float Angle, Scaling;
    local Actor Start;

    if(PlayerOwner.Pawn == None)
    {
        if(PlayerOwner.ViewTarget != None)
            Start = PlayerOwner.ViewTarget;
        else
            Start = PlayerOwner;
    }
    else
        Start = PlayerOwner.Pawn;

    Dir = rotator(Loc - Start.Location);
    Angle = ((Dir.Yaw - Start.Rotation.Yaw) & 65535) * 6.2832 / 65536;
    C.Style = ERenderStyle.STY_Alpha;
    C.SetPos(OffsetX * C.ClipX + ScaleX * C.ClipX * sin(Angle),
            OffsetY * C.ClipY - ScaleY * C.ClipY * cos(Angle));

    Scaling = 24 * C.ClipX * (0.45 * HUDScale) / 1600;

    C.DrawTile(LocationDot, Scaling, Scaling, 340, 432, 78, 78);
}

simulated function DrawWeaponBar(Canvas C)
{
	if (BS_xPlayer(PlayerOwner).HUDSettings.bEnableWidescreenFix)
		WideDrawWeaponBar(C);
	else
		Super.DrawWeaponBar(C);
}

simulated function DrawHudPassA(Canvas C)
{

	if (BS_xPlayer(PlayerOwner).HUDSettings.bEnableWidescreenFix)
		TeamWideDrawHudPassA(C);
	else
		Super.DrawHudPassA(C);
}

simulated function bool ShouldDrawPlayer(Misc_PRI PRI)
{
    if(PRI == None || PRI.PawnReplicationInfo == None || PRI.bOutOfLives || PRI.Team == None || PRI == PlayerOwner.PlayerReplicationInfo)
        return false;

    return true;
}

simulated function DrawPlayers(Canvas C)
{
    local int i;
    local int Team;
    local float xl;
    local float yl;
    local float MaxNamePos;
    local int posx;
    local int posy;
    local float scale;
    local string name;
    local int listy;
    local int space;
    local int namey;
    local int namex;
    local int height;
    local int width;

    local int allies;
    local int enemies;

    local Misc_PRI PRI;

    if(myOwner == None)
        return;

    if(PlayerOwner.PlayerReplicationInfo.Team != None)
        Team = PlayerOwner.GetTeamNum();
    else
    {
        if(Pawn(PlayerOwner.ViewTarget) == None || Pawn(PlayerOwner.ViewTarget).GetTeamNum() == 255)
            return;
        Team = Pawn(PlayerOwner.ViewTarget).GetTeamNum();
    }

    listy = 0.08 * HUDScale * C.ClipY;
    space = 0.005 * HUDScale * C.ClipY;
    scale = FMax(HUDScale, 0.75);
    height = C.ClipY * 0.0255 * Scale;
    width = C.ClipX * 0.13 * Scale;
    namex = C.ClipX * 0.025 * Scale;
    MaxNamePos = 0.99 * (width - namex);
    C.Font = GetFontSizeIndex(C, -3 + int(Scale * 1.25));
    C.StrLen("Test", xl, yl);
    namey = (height * 0.6) - (yl * 0.5);

    for(i = 0; i < MyOwner.GameReplicationInfo.PRIArray.Length; i++)
    {
        PRI = Misc_PRI(myOwner.GameReplicationInfo.PRIArray[i]);

        if(!ShouldDrawPlayer(PRI))
            continue;

        if(!class'Misc_Player'.default.bShowTeamInfo)
            continue;

        if(PRI.Team.TeamIndex == Team)
        {
            if(allies > 9)
                continue;

            posy = listy + ((height + space) * allies);
            posx = C.ClipX * 0.01;

            // draw background
            C.SetPos(posx, posy);
            C.DrawColor = default.BlackColor;
            C.DrawColor.A = 100;
            C.DrawTile(TeamTex, width, height, 168, 211, 166, 44);

            // draw disc
            C.SetPos(posx, posy);
            C.DrawColor = default.WhiteColor;
            C.DrawTile(TeamTex, C.ClipX * 0.0195 * Scale, C.ClipY * 0.026 * Scale, 119, 258, 54, 55);

            // draw name
            if(Misc_Player(PlayerOwner).Settings.bEnableColoredNamesOnHUD)
                name = PRI.GetColoredName();
            else
                name = PRI.PlayerName;
            C.DrawColor = NameColor;
            C.SetPos(posx + namex, posy + namey);
            class'Misc_Util'.static.DrawTextClipped(C, name, MaxNamePos);

            // draw health dot
            C.DrawColor = GetHealthRampColor(PRI);
            C.SetPos(posx + (0.0022 * Scale * C.ClipX), posy + (0.0035 * Scale * C.ClipY));
            C.DrawTile(TeamTex, C.ClipX * 0.0165 * Scale, C.ClipY * 0.0185 * Scale, 340, 432, 78, 78);

            // draw location dot
            C.DrawColor = WhiteColor;
            Draw2DLocationDot(C, PRI.PawnReplicationInfo.Position, (posx / C.ClipX) + (0.006 * Scale), (posy / C.ClipY) + (0.008 * Scale), 0.008 * Scale, 0.01 * Scale);

            // friends shown
            allies++;
        }
        else
        {
            if(enemies > 9)
                continue;

            posy = listy + ((height + space) * enemies);
            posx = C.ClipX * 0.99;

            // draw background
            C.SetPos(posx - width, posy);
            C.DrawColor = default.BlackColor;
            C.DrawColor.A = 100;
            C.DrawTile(TeamTex, width, height, 168, 211, 166, 44);

            // draw disc
            C.SetPos(posx - (C.ClipX * 0.0195 * Scale), posy);
            C.DrawColor = default.WhiteColor;
            C.DrawTile(TeamTex, C.ClipX * 0.0195 * Scale, C.ClipY * 0.026 * Scale, 119, 258, 54, 55);

            // draw name
            if(Misc_Player(PlayerOwner).Settings.bEnableColoredNamesOnHUD)
                name = PRI.GetColoredName();
            else
                name = PRI.PlayerName;

            C.TextSize(name, xl, yl);
            xl = Min(xl, MaxNamePos);
            C.DrawColor = NameColor;
            C.SetPos(posx - xl - namex, posy + namey);
            class'Misc_Util'.static.DrawTextClipped(C, name, MaxNamePos);

            // draw health dot
            C.DrawColor = HudColorTeam[PRI.Team.TeamIndex];
            C.SetPos(posx - (0.0165 * Scale * C.ClipX), posy + (0.0035 * Scale * C.ClipY));
            C.DrawTile(TeamTex, C.ClipX * 0.0165 * Scale, C.ClipY * 0.0185 * Scale, 340, 432, 78, 78);

            // enemies shown
            enemies++;
        }
    }
}

simulated function DrawColoredText (Canvas C, string Text)
{
  local int i;
  local float cX;
  local float cY;
  local float XL;
  local float YL;
  local string S;

  cX = C.CurX;
  cY = C.CurY;
  
  if ( Text != "" )
  {
    i = InStr(Text,"");
    if ( i >= 0 )
    {
      if ( i > 0 )
      {
        S = Left(Text,i);
        C.DrawTextClipped(S,False);
        C.StrLen(S,XL,YL);
        cX += XL;
        C.SetPos(cX,cY);
      }
      C.DrawColor.R = Asc(Mid(Text,i + 1));
      C.DrawColor.G = Asc(Mid(Text,i + 2));
      C.DrawColor.B = Asc(Mid(Text,i + 3));
      Text = Mid(Text,i + 4);
    } else {
      C.DrawTextClipped(Text,False);
     
    }
	
   
  }
}

simulated function DrawPlayersZAxis(Canvas C)
{
    local int i;
    local int HUDOwnerTeam; //team for the HUDOwner
    local float xl;
    local float yl;
    local float MaxNamePos;
    local int posx;
    local int posy;
    local float scale;
    local string name;
    local int StartListY;
    local int space;
    local int namey;
    local int namex;
    local int height;
    local int width;
    local Misc_PRI pri;

    //hagis
    local int radarSizeAllies;
    local int radarCenterX;
    local int radarCenterY;
    local float CU; // spacing unit 1 char width

    local int allies;
    local int enemies;

    if(myOwner == None)
        return;

    if(!class'Misc_Player'.default.bShowTeamInfo)
        return;

    if(PlayerOwner.PlayerReplicationInfo.Team != None)
    {
        HUDOwnerTeam = PlayerOwner.GetTeamNum();
    }
    else
    {
        if(Pawn(PlayerOwner.ViewTarget) == None || Pawn(PlayerOwner.ViewTarget).GetTeamNum() == 255)
            return;

        HUDOwnerTeam = Pawn(PlayerOwner.ViewTarget).GetTeamNum();
    }

    //
    // draw own team / allies
    //

    StartListY = 0.08 * HUDScale * C.ClipY; // Y axis start player entries
    height = C.ClipY * 0.02;

    C.Font = GetFontSizeIndex(C, -3);
    C.StrLen("X", CU, yl);
    namey = (height * 0.6) - (yl * 0.5);

    // loop this twice, once for each team, allies first
    for(i = 0; i < MyOwner.GameReplicationInfo.PRIArray.Length; i++)
    {
        if(allies > 9)
            break;

        PRI = Misc_PRI(myOwner.GameReplicationInfo.PRIArray[i]);

        if(!ShouldDrawPlayer(PRI))
            continue;

        if(PRI.Team.TeamIndex != HUDOwnerTeam)
            continue; // allies first

        //space = height + (0.0075 * C.ClipY);
        space = height + (0.0045 * C.ClipY);

        //calc the size of the radar and use this to space out the name and location bars
        radarSizeAllies = (height + space) * 0.85; // fill 85% of player entry height with radar

        posx = int(CU*0.5); //set posx to left side

        //start of text area background
        namex = radarSizeAllies + CU;
        width = C.ClipX * 0.11;
        MaxNamePos = width; //width for text

        //
        // draw text area background
        //
        C.DrawColor = default.BlackColor;
        posy = StartListY + ((height + space) * allies);
        C.SetPos(namex, posy);
        C.DrawColor.A = 100;
        C.DrawTile(TeamTex, width, height, 168, 211, 166, 44);

        //
        // draw outer radar disc
        //
        C.SetPos(posx, posy);
        C.DrawColor = default.WhiteColor;
        //C.DrawTile(TeamTex, C.ClipX * 0.0195 * Scale, C.ClipY * 0.026 * Scale, 119, 258, 54, 55); //original crops
        C.DrawTile(TeamTex, radarSizeAllies, radarSizeAllies, 121, 260, 51, 51); //hagis crops

        //calc radar circle center
        radarCenterX = posx + ((radarSizeAllies+1) / 2);
        radarCenterY = posy + ((radarSizeAllies+1) / 2);

        //
        // draw player name
        //
        if(Misc_Player(PlayerOwner).Settings.bEnableColoredNamesOnHUD)
            name = PRI.GetColoredName();
        else
            name = PRI.PlayerName;

        C.DrawColor = NameColor;
        C.SetPos(namex, posy + namey);
        class'Misc_Util'.static.DrawTextClipped(C, name, MaxNamePos);

        //
        // draw health dot
        //
        // use circle center to calc the position (need to find top left corner)
        // health dot size is 80% of radarSizeAllies 
        C.DrawColor = GetHealthRampColor(PRI);
        C.SetPos(radarCenterX - ((radarSizeAllies * 0.80)/2.0), radarCenterY - ((radarSizeAllies * 0.80)/2.0));
        C.DrawTile(Hudzaxis, radarSizeAllies * 0.80, radarSizeAllies * 0.80, 1, 1, 78, 78);

        //z axis overlay
        if(PlayerOwner.ViewTarget != None)
        {
            //same position as the dot
            C.SetPos(radarCenterX - ((radarSizeAllies * 0.80)/2.0), radarCenterY - ((radarSizeAllies * 0.80)/2.0));

            // player height is 88 use two player heights 176
            if(PRI.PawnReplicationInfo.Position.Z > (PlayerOwner.ViewTarget.Location.Z + 176))
                C.DrawTile(Hudzaxis, radarSizeAllies * 0.80, radarSizeAllies * 0.80, 80, 1, 78, 78); //plus
            else if (PRI.PawnReplicationInfo.Position.Z < (PlayerOwner.ViewTarget.Location.Z - 176))
                C.DrawTile(Hudzaxis, radarSizeAllies * 0.80, radarSizeAllies * 0.80, 160, 1, 78, 78); //minus
        }

        //
        // draw location dot
        //
        // don't draw location dot when viewing spec players own HUD entry
        if(PlayerOwner.ViewTarget == None ||
           PRI != Misc_PRI(Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo))
        {
            C.DrawColor = WhiteColor;
            NewDraw2DLocationDot(C, PRI.PawnReplicationInfo.Position, radarCenterX, radarCenterY, radarSizeAllies);
        }

        // friends shown
        allies++;
    }


    //
    // enemies
    //
    for(i = 0; i < MyOwner.GameReplicationInfo.PRIArray.Length; i++)
    {
        if(enemies > 9)
            break;

        PRI = Misc_PRI(myOwner.GameReplicationInfo.PRIArray[i]);

        if(!ShouldDrawPlayer(PRI))
            continue;

        if(PRI.Team.TeamIndex == HUDOwnerTeam)
            continue;

        scale = 0.75; // radar size old method
        space = (0.005 * C.ClipY);
        namex = C.ClipX * 0.02;
        width = C.ClipX * 0.11;
        MaxNamePos = 0.99 * (width - namex);

        posy = StartListY + ((height + space) * enemies);
        posx = C.ClipX * 0.99;

        // draw background
        C.SetPos(posx - width, posy);
        C.DrawColor = default.BlackColor;
        C.DrawColor.A = 100;
        C.DrawTile(TeamTex, width, height, 168, 211, 166, 44);

        // draw disc
        C.SetPos(posx - (C.ClipX * 0.0195 * Scale), posy);
        C.DrawColor = default.WhiteColor;
        C.DrawTile(TeamTex, C.ClipX * 0.0195 * Scale, C.ClipY * 0.026 * Scale, 119, 258, 54, 55);

        // draw name
        if(Misc_Player(PlayerOwner).Settings.bEnableColoredNamesOnHUD)
            name = PRI.GetColoredName();
        else
            name = PRI.PlayerName;

        C.TextSize(name, xl, yl);
        xl = Min(xl, MaxNamePos);
        C.DrawColor = NameColor;
        C.SetPos(posx - xl - namex, posy + namey);
        class'Misc_Util'.static.DrawTextClipped(C, name, MaxNamePos);

        // draw health dot
        C.DrawColor = HudColorTeam[PRI.Team.TeamIndex];

        C.SetPos(posx - (0.016 * Scale * C.ClipX), posy + (0.0035 * Scale * C.ClipY));
        C.DrawTile(TeamTex, C.ClipX * 0.0165 * Scale, C.ClipY * 0.0185 * Scale, 340, 432, 78, 78);

        // enemies shown
        enemies++;
    }
}

simulated function DrawSpawnEffect (Canvas C)
{
  if ( (Pawn(PlayerOwner.ViewTarget) != None) && (Pawn(PlayerOwner.ViewTarget).SpawnTime + SpawnEffectTime > Level.TimeSeconds) )
  {
    if ( Pawn(PlayerOwner.ViewTarget).GetTeamNum() == 0 )
    {
      C.DrawColor = RedSpawnEffectColor;
    } else {
      C.DrawColor = BlueSpawnEffectColor;
    }
    C.DrawColor.A = int((Pawn(PlayerOwner.ViewTarget).SpawnTime + SpawnEffectTime - Level.TimeSeconds) / SpawnEffectTime * 255);
    C.SetPos(0.0,0.0);
    C.Style = 5;
    C.DrawTile(Texture'WhiteSquareTexture',C.ClipX,C.ClipY,0.0,0.0,8.0,8.0);
  }
}

simulated function DrawResWarningIcon (Canvas C)
{
  local float XL;
  local float YL;
  local Misc_BaseGRI GRI;

  if ( (PlayerOwner.PlayerReplicationInfo == None) || (PlayerOwner.PlayerReplicationInfo.Team == None) ||  !PlayerOwner.PlayerReplicationInfo.bOutOfLives )
  {
    return;
  }
  GRI = Misc_BaseGRI(PlayerOwner.GameReplicationInfo);
  if ( GRI == None )
  {
    return;
  }

  if(GRI.bDisableNecroMessage)
  {
      return;
  }

  if ( (GRI.NextWhoToRes[0] == PlayerOwner.PlayerReplicationInfo) || (GRI.NextWhoToRes[1] == PlayerOwner.PlayerReplicationInfo) )
  {
    Class'Message_Grave'.static.RenderComplexMessage(C,XL,YL,,0,PlayerOwner.PlayerReplicationInfo);
  }
}

simulated function CullDeathMessages ()
{
  local int i;

  if ( (Pawn(PlayerOwner.ViewTarget) != None) && (Pawn(PlayerOwner.ViewTarget).SpawnTime + SpawnEffectTime > Level.TimeSeconds) )
  {
    if (  !bSpawning )
    {
      for ( i = 0; i<8; i++) {
	  
        if ( (Class<Message_PlayerIsOut>(LocalMessages[i].Message) != None) || (Class<xVictimMessage>(LocalMessages[i].Message) != None) )
        {
          LocalMessages[i].EndOfLife = Level.TimeSeconds;
        }
        i++;
        
      }
      bSpawning = True;
    }
  } else {
    if ( bSpawning )
    {
      bSpawning = False;
    }
  }
}

simulated function DrawPlayersExtended(Canvas C)
{
    local int i;
    local int Team;
    local float xl;
    local float yl;
    local float MaxNamePos;
    local int posx;
    local int posy;
    local float scale;
    local string name;
    local int listy;
    local int space;
    local int namey;
    local int namex;
    local int height;
    local int width;
    local Misc_PRI pri;
    local int health;

    local int allies;
    local int enemies;

    if(myOwner == None)
        return;

    if(PlayerOwner.PlayerReplicationInfo.Team != None)
        Team = PlayerOwner.GetTeamNum();
    else
    {
        if(Pawn(PlayerOwner.ViewTarget) == None || Pawn(PlayerOwner.ViewTarget).GetTeamNum() == 255)
            return;
        Team = Pawn(PlayerOwner.ViewTarget).GetTeamNum();
    }

    listy = 0.08 * HUDScale * C.ClipY;
    scale = 0.75;
    height = C.ClipY * 0.02;
    space = height + (0.0075 * C.ClipY);
    namex = C.ClipX * 0.02;

    C.Font = GetFontSizeIndex(C, -3);
    C.StrLen("Test", xl, yl);
    namey = (height * 0.6) - (yl * 0.5);

    for(i = 0; i < MyOwner.GameReplicationInfo.PRIArray.Length; i++)
    {
        PRI = Misc_PRI(myOwner.GameReplicationInfo.PRIArray[i]);

        if(!ShouldDrawPlayer(PRI))
            continue;

        if(!class'Misc_Player'.default.bShowTeamInfo)
            continue;

        if(PRI.Team.TeamIndex == Team)
        {
            if(allies > 9)
                continue;

            space = height + (0.0075 * C.ClipY);
            width = C.ClipX * 0.14;
            MaxNamePos = 0.78 * (width - namex);

            posy = listy + ((height + space) * allies);
            posx = C.ClipX * 0.01;

            // draw backgrounds
            C.SetPos(posx, posy);
            C.DrawColor = default.BlackColor;
            C.DrawColor.A = 100;
            C.DrawTile(TeamTex, width + posx, height, 168, 211, 166, 44);
            C.SetPos(posx * 2, posy + height * 1.1);
            C.DrawTile(TeamTex, width, height, 168, 211, 166, 44);

            // draw disc
            C.SetPos(posx, posy);
            C.DrawColor = default.WhiteColor;
            C.DrawTile(TeamTex, C.ClipX * 0.0195 * Scale, C.ClipY * 0.026 * Scale, 119, 258, 54, 55);

            // draw name
            if(Misc_Player(PlayerOwner).Settings.bEnableColoredNamesOnHUD)
                name = PRI.GetColoredName();
            else
                name = PRI.PlayerName;
            C.DrawColor = NameColor;
            C.SetPos(posx + namex, posy + namey);
            class'Misc_Util'.static.DrawTextClipped(C, name, MaxNamePos);

            // draw location
            MaxNamePos = 0.80 * (width - namex);
            name = PRI.GetLocationName();
            C.StrLen(name, xl, yl);
            if(xl > MaxNamePos)
                name = left(name, MaxNamePos / xl * len(name));
            C.SetPos(posx + namex, posy + (height * 1.1) + namey);
            C.DrawColor = LocationColor;
            C.DrawText(name);

            // draw health dot
            C.DrawColor = GetHealthRampColor(PRI);

            C.SetPos(posx + (0.0022 * Scale * C.ClipX), posy + (0.0035 * Scale * C.ClipY));
            C.DrawTile(TeamTex, C.ClipX * 0.0165 * Scale, C.ClipY * 0.0185 * Scale, 340, 432, 78, 78);

            // draw health
            health = PRI.PawnReplicationInfo.Health + PRI.PawnReplicationInfo.Shield;
            name = string(health);
            C.StrLen(name, xl, yl);
            C.SetPos(posx * 1.5 + width - xl, posy + namey);
            C.DrawText(name);

            // draw adrenaline
            name = string(PRI.PawnReplicationInfo.Adrenaline);
            C.StrLen(name, xl, yl);
            C.SetPos(posx * 1.5 + width - xl, posy + (height * 1.1) + namey);
            if(PRI.PawnReplicationInfo.Adrenaline<100)
                C.DrawColor = AdrenColor;
            else
                C.DrawColor = FullAdrenColor;
            C.DrawText(name);


            // draw location dot
            C.DrawColor = WhiteColor;
            Draw2DLocationDot(C, PRI.PawnReplicationInfo.Position, (posx / C.ClipX) + (0.006 * Scale), (posy / C.ClipY) + (0.008 * Scale), 0.008 * Scale, 0.01 * Scale);

            // friends shown
            allies++;
        }
        else
        {
            if(enemies > 9)
                continue;

            space = (0.005 * C.ClipY);
            width = C.ClipX * 0.11;
            MaxNamePos = 0.99 * (width - namex);

            posy = listy + ((height + space) * enemies);
            posx = C.ClipX * 0.99;

            // draw background
            C.SetPos(posx - width, posy);
            C.DrawColor = default.BlackColor;
            C.DrawColor.A = 100;
            C.DrawTile(TeamTex, width, height, 168, 211, 166, 44);

            // draw disc
            C.SetPos(posx - (C.ClipX * 0.0195 * Scale), posy);
            C.DrawColor = default.WhiteColor;
            C.DrawTile(TeamTex, C.ClipX * 0.0195 * Scale, C.ClipY * 0.026 * Scale, 119, 258, 54, 55);

            // draw name
            if(Misc_Player(PlayerOwner).Settings.bEnableColoredNamesOnHUD)
                name = PRI.GetColoredName();
            else
                name = PRI.PlayerName;
            C.TextSize(name, xl, yl);
            xl = Min(xl, MaxNamePos);
            C.DrawColor = NameColor;
            C.SetPos(posx - xl - namex, posy + namey);
            class'Misc_Util'.static.DrawTextClipped(C, name, MaxNamePos);

            // draw health dot
            C.DrawColor = HudColorTeam[PRI.Team.TeamIndex];
            C.SetPos(posx - (0.016 * Scale * C.ClipX), posy + (0.0035 * Scale * C.ClipY));
            C.DrawTile(TeamTex, C.ClipX * 0.0165 * Scale, C.ClipY * 0.0185 * Scale, 340, 432, 78, 78);

            // enemies shown
            enemies++;
        }
    }
}

simulated function DrawPlayersExtendedZAxisTeam(Canvas C, int posx, int posy, int namex, Misc_PRI PRI)
{
    local int HUDOwnerTeam; //team for the HUDOwner
    local float xl;
    local float yl;
    local float MaxNamePos;
    local string name;
    local int StartListY;
    local int space;
    local int namey;
    //local int namex;
    local int height;
    local int width;
    local int health;

    //hagis
    local int radarSizeAllies;
    local int radarCenterX;
    local int radarCenterY;
    local float CU; // spacing unit 1 char width


    if(myOwner == None)
        return;

    if(!class'Misc_Player'.default.bShowTeamInfo)
        return;

    if(PlayerOwner.PlayerReplicationInfo.Team != None)
    {
        HUDOwnerTeam = PlayerOwner.GetTeamNum();
    }
    else
    {
        if(Pawn(PlayerOwner.ViewTarget) == None || Pawn(PlayerOwner.ViewTarget).GetTeamNum() == 255)
            return;

        HUDOwnerTeam = Pawn(PlayerOwner.ViewTarget).GetTeamNum();
    }

    //
    // draw own team / allies
    //

    StartListY = 0.08 * HUDScale * C.ClipY; // Y axis start player entries
    height = C.ClipY * 0.02;

    C.Font = GetFontSizeIndex(C, -3);
    C.StrLen("X", CU, yl);
    namey = (height * 0.6) - (yl * 0.5);

    space = height + (0.0075 * C.ClipY);

    //calc the size of the radar and use this to space out the name and location bars
    radarSizeAllies = (height + space) * 0.85; // fill 85% of player entry height with radar

    //start of text area backgrounds
    //namex = radarSizeAllies + CU;
    width = C.ClipX * 0.12;
    MaxNamePos = width - CU*2.75; //width for text

    //
    // draw text area backgrounds
    //
    C.DrawColor = default.BlackColor;

    //
    // draw text area backgrounds
    //
    C.DrawColor = default.BlackColor;
    C.SetPos(namex, posy);
    C.DrawColor.A = 100;
    C.DrawTile(TeamTex, width, height, 168, 211, 166, 44);

    C.SetPos(namex, posy + height * 1.1);
    C.DrawTile(TeamTex, width, height, 168, 211, 166, 44);

    //
    // draw outer radar disc
    //
    C.SetPos(posx, posy);
    C.DrawColor = default.WhiteColor;
    //C.DrawTile(TeamTex, C.ClipX * 0.0195 * Scale, C.ClipY * 0.026 * Scale, 119, 258, 54, 55); //original crops
    C.DrawTile(TeamTex, radarSizeAllies, radarSizeAllies, 121, 260, 51, 51); //hagis crops

    //calc radar circle center
    radarCenterX = posx + ((radarSizeAllies+1) / 2);
    radarCenterY = posy + ((radarSizeAllies+1) / 2);

    //
    // draw player name
    //
    if(Misc_Player(PlayerOwner).Settings.bEnableColoredNamesOnHUD)
        name = PRI.GetColoredName();
    else
        name = PRI.PlayerName;

    C.DrawColor = NameColor;
    C.SetPos(namex, posy + namey);
    class'Misc_Util'.static.DrawTextClipped(C, name, MaxNamePos);

    //
    // draw player map location
    //
    name = PRI.GetLocationName();
    C.DrawColor = LocationColor;
    C.SetPos(namex, posy + (height * 1.1) + namey);
    class'Misc_Util'.static.DrawTextClipped(C, name, MaxNamePos);

    //
    // get health color
    //
    C.DrawColor = GetHealthRampColor(PRI);

    //
    // draw health amount text
    //
    health = PRI.PawnReplicationInfo.Health + PRI.PawnReplicationInfo.Shield;
    name = string(health);
    C.StrLen(name, xl, yl);
    //C.SetPos((C.ClipX * 0.015) + width + radarSizeAllies - xl, posy + namey);
    C.SetPos(posx + width + radarSizeAllies - xl, posy + namey);
    C.DrawText(name);

    //
    // draw health dot
    //
    // use circle center to calc the position (need to find top left corner)
    // health dot size is 80% of radarSizeAllies 
    C.SetPos(radarCenterX - ((radarSizeAllies * 0.80)/2.0), radarCenterY - ((radarSizeAllies * 0.80)/2.0));
    C.DrawTile(Hudzaxis, radarSizeAllies * 0.80, radarSizeAllies * 0.80, 1, 1, 78, 78);

    //z axis overlay
    if(PlayerOwner.ViewTarget != None)
    {
        //same position as the dot
        C.SetPos(radarCenterX - ((radarSizeAllies * 0.80)/2.0), radarCenterY - ((radarSizeAllies * 0.80)/2.0));

        // player height is 88 use two player heights 176
        if(PRI.PawnReplicationInfo.Position.Z > (PlayerOwner.ViewTarget.Location.Z + 176))
            C.DrawTile(Hudzaxis, radarSizeAllies * 0.80, radarSizeAllies * 0.80, 80, 1, 78, 78); //plus
        else if (PRI.PawnReplicationInfo.Position.Z < (PlayerOwner.ViewTarget.Location.Z - 176))
            C.DrawTile(Hudzaxis, radarSizeAllies * 0.80, radarSizeAllies * 0.80, 160, 1, 78, 78); //minus
    }

    //
    // draw adrenaline amount text
    //
    name = string(PRI.PawnReplicationInfo.Adrenaline);
    C.StrLen(name, xl, yl);
    //C.SetPos((C.ClipX * 0.015) + width + radarSizeAllies - xl, posy + (height * 1.1) + namey);
    C.SetPos(posx + width + radarSizeAllies - xl, posy + (height * 1.1) + namey);
    if(PRI.PawnReplicationInfo.Adrenaline<100)
        C.DrawColor = AdrenColor;
    else
        C.DrawColor = FullAdrenColor;

    C.DrawText(name);

    //
    // draw location dot
    //
    // don't draw location dot when viewing spec players own HUD entry
    if(PlayerOwner.ViewTarget == None ||
        PRI != Misc_PRI(Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo))
    {
        C.DrawColor = WhiteColor;
        NewDraw2DLocationDot(C, PRI.PawnReplicationInfo.Position, radarCenterX, radarCenterY, radarSizeAllies);
    }
}

simulated function DrawPlayersExtendedZAxisEnemy(Canvas C, int posx, int posy, int namex, Misc_PRI PRI)
{
    local int HUDOwnerTeam; //team for the HUDOwner
    local float xl;
    local float yl;
    local float MaxNamePos;
    local float scale;
    local string name;
    local int StartListY;
    local int space;
    local int namey;
//    local int namex;
    local int height;
    local int width;

    //hagis
    local float CU; // spacing unit 1 char width

    if(myOwner == None)
        return;

    if(!class'Misc_Player'.default.bShowTeamInfo)
        return;

    if(PlayerOwner.PlayerReplicationInfo.Team != None)
    {
        HUDOwnerTeam = PlayerOwner.GetTeamNum();
    }
    else
    {
        if(Pawn(PlayerOwner.ViewTarget) == None || Pawn(PlayerOwner.ViewTarget).GetTeamNum() == 255)
            return;

        HUDOwnerTeam = Pawn(PlayerOwner.ViewTarget).GetTeamNum();
    }

    //
    // draw own team / allies
    //

    StartListY = 0.08 * HUDScale * C.ClipY; // Y axis start player entries
    height = C.ClipY * 0.02;

    C.Font = GetFontSizeIndex(C, -3);
    C.StrLen("X", CU, yl);
    namey = (height * 0.6) - (yl * 0.5);
    scale = 0.75; // radar size
    space = (0.005 * C.ClipY);
    //namex = C.ClipX * 0.02;
    width = C.ClipX * 0.11;
    MaxNamePos = 0.99 * (width - namex);

    // draw background
    C.SetPos(posx - width, posy);
    C.DrawColor = default.BlackColor;
    C.DrawColor.A = 100;
    C.DrawTile(TeamTex, width, height, 168, 211, 166, 44);

    // draw disc
    C.SetPos(posx - (C.ClipX * 0.0195 * Scale), posy);
    C.DrawColor = default.WhiteColor;
    C.DrawTile(TeamTex, C.ClipX * 0.0195 * Scale, C.ClipY * 0.026 * Scale, 119, 258, 54, 55);

    // draw name
    if(Misc_Player(PlayerOwner).Settings.bEnableColoredNamesOnHUD)
        name = PRI.GetColoredName();
    else
        name = PRI.PlayerName;

    C.TextSize(name, xl, yl);
    xl = Min(xl, MaxNamePos);
    C.DrawColor = NameColor;
    C.SetPos(posx - xl - namex, posy + namey);
    class'Misc_Util'.static.DrawTextClipped(C, name, MaxNamePos);

    // draw health dot
    C.DrawColor = HudColorTeam[PRI.Team.TeamIndex];
    C.SetPos(posx - (0.016 * Scale * C.ClipX), posy + (0.0035 * Scale * C.ClipY));
    C.DrawTile(TeamTex, C.ClipX * 0.0165 * Scale, C.ClipY * 0.0185 * Scale, 340, 432, 78, 78);

}


simulated function DrawPlayersExtendedZAxis(Canvas C)
{
    local int i;
    local int HUDOwnerTeam; //team for the HUDOwner
    local float yl;
    local float MaxNamePos;
    local int posx;
    local int posy;
    local float scale;
    local int StartListY;
    local int space;
    local int namey;
    local int namex;
    local int height;
    local int width;
    local Misc_PRI pri;

    //hagis
    local int radarSizeAllies;
    local float CU; // spacing unit 1 char width

    local int allies;
    local int enemies;

    if(myOwner == None)
        return;

    if(!class'Misc_Player'.default.bShowTeamInfo)
        return;

    if(PlayerOwner.PlayerReplicationInfo.Team != None)
    {
        HUDOwnerTeam = PlayerOwner.GetTeamNum();
    }
    else
    {
        if(Pawn(PlayerOwner.ViewTarget) == None || Pawn(PlayerOwner.ViewTarget).GetTeamNum() == 255)
            return;

        HUDOwnerTeam = Pawn(PlayerOwner.ViewTarget).GetTeamNum();
    }

    //
    // draw own team / allies
    //

    StartListY = 0.08 * HUDScale * C.ClipY; // Y axis start player entries
    height = C.ClipY * 0.02;

    C.Font = GetFontSizeIndex(C, -3);
    C.StrLen("X", CU, yl);
    namey = (height * 0.6) - (yl * 0.5);

    // loop this twice, once for each team, allies first
    for(i = 0; i < MyOwner.GameReplicationInfo.PRIArray.Length; i++)
    {
        if(allies > 9)
            break;

        PRI = Misc_PRI(myOwner.GameReplicationInfo.PRIArray[i]);

        if(!ShouldDrawPlayer(PRI))
            continue;

        if(PRI.Team.TeamIndex != HUDOwnerTeam)
            continue; // allies first

        space = height + (0.0075 * C.ClipY);

        //calc the size of the radar and use this to space out the name and location bars
        radarSizeAllies = (height + space) * 0.85; // fill 85% of player entry height with radar

        posx = int(CU*0.5); //set posx to left side

        //start of text area backgrounds
        namex = radarSizeAllies + CU;
        width = C.ClipX * 0.12;
        MaxNamePos = width - CU*2.75; //width for text

        posy = StartListY + ((height + space) * allies);

        DrawPlayersExtendedZAxisTeam(C, posx, posy, namex, PRI);

        // friends shown
        allies++;
    }

    //
    // enemies
    //
    for(i = 0; i < MyOwner.GameReplicationInfo.PRIArray.Length; i++)
    {
        if(enemies > 9)
            break;

        PRI = Misc_PRI(myOwner.GameReplicationInfo.PRIArray[i]);

        if(!ShouldDrawPlayer(PRI))
            continue;

        if(PRI.Team.TeamIndex == HUDOwnerTeam)
            continue;

        scale = 0.75; // radar size
        space = (0.005 * C.ClipY);
        namex = C.ClipX * 0.02;
        width = C.ClipX * 0.11;
        MaxNamePos = 0.99 * (width - namex);

        posy = StartListY + ((height + space) * enemies);
        posx = C.ClipX * 0.99;

        if(PlayerOwner.PlayerReplicationInfo.bOnlySpectator)
        {
            space = height + (0.0075 * C.ClipY);

            //calc the size of the radar and use this to space out the name and location bars
            radarSizeAllies = (height + space) * 0.85; // fill 85% of player entry height with radar

            //posx = int(CU*0.5); //set posx to left side

            //start of text area backgrounds
            //namex = radarSizeAllies + CU;
            width = C.ClipX * 0.12;
            MaxNamePos = width - CU*2.75; //width for text

            namex = C.ClipX * 0.88;
            posx = C.ClipX * 0.85;
            posy = StartListY + ((height + space) * enemies);
            DrawPlayersExtendedZAxisTeam(C, posx, posy, namex, PRI);
        }
        else
        {
            DrawPlayersExtendedZAxisEnemy(C, posx, posy, namex, PRI);
        }

        // enemies shown
        enemies++;
    }
}


simulated function DrawSpectatingHud(Canvas C)
{
  Super.DrawSpectatingHud(C);

  if(PlayerOwner.PlayerReplicationInfo!=None && PlayerOwner.PlayerReplicationInfo.bOnlySpectator) {
    if(class'Misc_Player'.default.bAdminVisionInSpec)
      DrawAdminVision(C);
    if(class'Misc_Player'.default.bDrawTargetingLineInSpec)
      DrawTargetingLine(C);
  }
  DrawResWarningIcon(C);
}


simulated function DrawHudPassC(Canvas C)
{
  Super.DrawHudPassC(C);

  if(PlayerOwner.PlayerReplicationInfo!=None && PlayerOwner.PlayerReplicationInfo.bOnlySpectator) {
    if(class'Misc_Player'.default.bAdminVisionInSpec)
      DrawAdminVision(C);
    if(class'Misc_Player'.default.bDrawTargetingLineInSpec)
      DrawTargetingLine(C);
  }
  DrawResWarningIcon(C);
  DrawMutantStyleTeamRadar(C);
}


simulated function UpdateRankAndSpread(Canvas C)
{
    local Misc_BaseGRI GRI;

    if(MyOwner == None)
        return;

    GRI = Misc_BaseGRI(MyOwner.GameReplicationInfo);

    if(class'Misc_Player'.default.bExtendedInfo)
    {
        if((GRI != None) && GRI.UseZAxisRadar)
           DrawPlayersExtendedZAxis(C);
        else
           DrawPlayersExtended(C);
    }
    else
    {
        if((GRI != None) && GRI.UseZAxisRadar)
           DrawPlayersZAxis(C);
        else
           DrawPlayers(C);
    }

    DrawNumSpectators(C);
}

simulated function DrawNumSpectators(Canvas C)
{
    local string numspecs;
    local float XL, YL;
    local Color oldColor;

    if(Misc_BaseGRI(Level.GRI) == none)
        return;

    if(Misc_BaseGRI(Level.GRI) != None && !Misc_BaseGRI(Level.GRI).bShowNumSpecs)
        return;

    if(myOwner == None)
    {
        myOwner = Misc_Player(PlayerOwner);
        if(myOwner == None)
        {
            return;
        }
    }
    if(myOwner.PlayerReplicationInfo.bOnlySpectator)
        return;

    if(!myOwner.bShowSpectators)
        return;

    numspecs = "Spectators:"@string(myOwner.NumSpectators);
    C.StrLen(numspecs, XL, YL);
    C.SetPos((C.ClipX - XL) * 0.032, (C.ClipY - YL) * 0.055);
    oldColor = C.DrawColor;
    C.DrawColor = default.WhiteColor;
    C.DrawTextClipped(numspecs);
    C.DrawColor = oldColor;
}


simulated function UpdateHUD()
{
    local Color red;
    local Color blue;
    local int team;

    if(myOwner == None)
    {
        myOwner = Misc_Player(PlayerOwner);

        if(myOwner == None)
        {
            Super.UpdateHUD();
            return;
        }
    }

    if(MyOwner.HUDSettings.bMatchHudColor)
    {
        if(MyOwner.PlayerReplicationInfo.bOnlySpectator)
        {
            if(Pawn(MyOwner.ViewTarget) != None && Pawn(MyOwner.ViewTarget).GetTeamNum() != 255)
                team = Pawn(MyOwner.ViewTarget).GetTeamNum();
            else
                return;
        }
        else
            team = MyOwner.GetTeamNum();

        red = HudColorRed * 2;
        blue = HudColorBlue * 2;
        red.A = HudColorRed.A;
        blue.A = HudColorBlue.A;

        if(MyOwner.Settings.bEnemyBasedSkins)
        {
            if(team == 0)
            {
                HudColorRed = blue;
                HudColorBlue = red;
                HudColorTeam[0] = blue;
                HudColorTeam[1] = red;

                TeamSymbols[0].Tints[0] = blue;
                TeamSymbols[0].Tints[1] = blue;
                TeamSymbols[1].Tints[0] = red;
                TeamSymbols[1].Tints[1] = red;
            }
            else
            {
                HudColorBlue = blue;
                HudColorRed = red;
                HudColorTeam[1] = blue;
                HudColorTeam[0] = red;

                TeamSymbols[0].Tints[0] = red;
                TeamSymbols[0].Tints[1] = red;
                TeamSymbols[1].Tints[0] = blue;
                TeamSymbols[1].Tints[1] = blue;
            }
        }
        else
        {
            HudColorRed = red;
            HudColorBlue = blue;
        }
    }
    else
    {
        HudColorRed = default.HudColorRed;
        HudColorBlue = default.HudColorBlue;
        HudColorTeam[0] = default.HudColorTeam[0];
        HudColorTeam[1] = default.HudColorTeam[1];

        TeamSymbols[0].Tints[0] = default.HudColorTeam[0];
        TeamSymbols[0].Tints[1] = default.HudColorTeam[0];
        TeamSymbols[1].Tints[0] = default.HudColorTeam[1];
        TeamSymbols[1].Tints[1] = default.HudColorTeam[1];
    }

    Super.UpdateHUD();
}

simulated function DrawAdminVision(Canvas C)
{
    local Pawn Pawn;
    foreach AllActors(class'Pawn', Pawn)
    {
      if(PawnOwner == Pawn)
        continue;
      C.DrawActor(Pawn, false, true);
    }
}

simulated function DrawTargetingLine(Canvas C)
{
  local vector TargetPoint1, TargetPoint2, Loc,Dir;
  local int i;
  local Actor ViewActor;
  local rotator Rot;

  if(PlayerOwner==None)
    return;

  PlayerOwner.PlayerCalcView(ViewActor, Loc, Rot);
  Dir = Vector(Rot);

  if(TargetingActor!=ViewActor) {
    TargetingLines.Length = 0;
    TargetingActor = ViewActor;
  }

  if(ViewActor==None)
    return;

  i = TargetingLines.Length;
  if(i==0 || Dir!=TargetingLines[i-1]) {
    if(i>100) {
      TargetingLines.Remove(0,i-100);
      i = TargetingLines.Length;
    }
    TargetingLines.Length = i+1;
    TargetingLines[i] = Dir;
  }

  for(i=0; i<TargetingLines.Length-1; ++i) {
    if(TargetingLines[i] Dot Dir <= 0)
      continue;
    if(TargetingLines[i+1] Dot Dir <= 0)
      continue;

    TargetPoint1 = C.WorldToScreen(Loc + TargetingLines[i] * 2);
    TargetPoint2 = C.WorldToScreen(Loc + TargetingLines[i+1] * 2);
    DrawCanvasLine(TargetPoint1.X, TargetPoint1.Y, TargetPoint2.X, TargetPoint2.Y, RedColor);
  }
}

function CheckCountdown(GameReplicationInfo GRI)
{
    local Misc_BaseGRI G;

    G = Misc_BaseGRI(GRI);
    if(G == None || G.SecsPerRound == 0 || G.RoundTime == 0 || G.RoundTime == OldRoundTime || GRI.Winner != None)
    {
        Super.CheckCountdown(GRI);
        return;
    }

    OldRoundTime = G.RoundTime;

    if(OldRoundTime == 60)
    {
        if(G.SecsPerRound >= 120)
          PlayerOwner.PlayStatusAnnouncement(LongCountName[3], 1, true);
    }
    else if(OldRoundTime == 30)
    {
        if(G.SecsPerRound >= 90)
          PlayerOwner.PlayStatusAnnouncement(LongCountName[4], 1, true);
    }
    else if(OldRoundTime == 20)
    {
        if(G.SecsPerRound >= 60)
            PlayerOwner.PlayStatusAnnouncement(LongCountName[5], 1, true);
    }
    else if(OldRoundTime <= 5 && OldRoundTime > 0)
    {
        //always play the last 5 count down
        PlayerOwner.PlayStatusAnnouncement(CountDownName[OldRoundTime - 1], 1, true);
    }
}

simulated function DrawTimer(Canvas C)
{
    local Misc_BaseGRI GRI;
    local int Minutes, Hours, Seconds;

    GRI = Misc_BaseGRI(PlayerOwner.GameReplicationInfo);

    if(GRI == None)
        return;

    if(GRI.SecsPerRound > 0)
    {
        Seconds = GRI.RoundTime;
        if(GRI.TimeLimit > 0 && GRI.RoundTime > GRI.RemainingTime)
            Seconds = GRI.RemainingTime;
    }
    else if(GRI.TimeLimit > 0)
        Seconds = GRI.RemainingTime;
    else
        Seconds = GRI.ElapsedTime;

    TimerBackground.Tints[TeamIndex] = HudColorBlack;
    TimerBackground.Tints[TeamIndex].A = 150;

    DrawSpriteTileWidget(C, TimerBackground);
    DrawSpriteTileWidget(C, TimerBackgroundDisc);
    DrawSpriteTileWidget(C, TimerIcon);

    TimerMinutes.OffsetX = default.TimerMinutes.OffsetX - 80;
    TimerSeconds.OffsetX = default.TimerSeconds.OffsetX - 80;
    TimerDigitSpacer[0].OffsetX = Default.TimerDigitSpacer[0].OffsetX;
    TimerDigitSpacer[1].OffsetX = Default.TimerDigitSpacer[1].OffsetX;

    if( Seconds > 3600 )
    {
        Hours = Seconds / 3600;
        Seconds -= Hours * 3600;

        DrawNumericWidget( C, TimerHours, DigitsBig);
        TimerHours.Value = Hours;

        if(Hours>9)
        {
            TimerMinutes.OffsetX = default.TimerMinutes.OffsetX;
            TimerSeconds.OffsetX = default.TimerSeconds.OffsetX;
        }
        else
        {
            TimerMinutes.OffsetX = default.TimerMinutes.OffsetX -40;
            TimerSeconds.OffsetX = default.TimerSeconds.OffsetX -40;
            TimerDigitSpacer[0].OffsetX = Default.TimerDigitSpacer[0].OffsetX - 32;
            TimerDigitSpacer[1].OffsetX = Default.TimerDigitSpacer[1].OffsetX - 32;
        }

        DrawSpriteTileWidget( C, TimerDigitSpacer[0]);
    }
    DrawSpriteTileWidget( C, TimerDigitSpacer[1]);

    Minutes = Seconds / 60;
    Seconds -= Minutes * 60;

    TimerMinutes.Value = Min(Minutes, 60);
    TimerSeconds.Value = Min(Seconds, 60);

    DrawNumericTileWidget( C, TimerMinutes, DigitsBig);
    DrawNumericTileWidget( C, TimerSeconds, DigitsBig);
}


function DisplayEnemyName(Canvas C, PlayerReplicationInfo PRI)
{
    PlayerOwner.ReceiveLocalizedMessage(class'UTComp_PlayerNameMessage',0,PRI);
}


simulated function DisplayLocalMessages( Canvas C )
{
    Super.DisplayLocalMessages(C);

    DrawStatsList(C, 0, 0.150, 0.150);
    DrawStatsList(C, 1, 0.850, 0.150);
    DrawStatsList(C, 2, 0.150, 0.50);
    DrawStatsList(C, 3, 0.850, 0.50);

}

function DrawStatsList (Canvas C, int Index, float XPos, float YPos)
{
  local float Y;
  local float XL;
  local float YL;
  local float F;
  local int i;

  if ( Len(StatsLists[Index].ListName) == 0 )
  {
    return;
  }
  Y = YPos;
  C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C,-2);
  F = FMin((Level.TimeSeconds - StatsLists[Index].RecvTime) * 3,1.0);
  C.DrawColor = Default.WhiteColor * F;
  C.DrawColor.A = byte(255 * FMin(F * 2,1.0));
  C.DrawScreenText(StatsLists[Index].ListName,XPos,Y,DP_LowerMiddle);
  C.StrLen(StatsLists[Index].ListName,XL,YL);
  Y += YL * 1.5 / C.ClipY;
  C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C,-3);
  i = 0;
  JL0189:
  if ( i < 10 )
  {
    F = FMin((Level.TimeSeconds - StatsLists[Index].RecvTimeRow - i * 0.12) * 3,1.0);
    if ( F <= 0 )
    {
      goto JL045F;
    }
    if ( i < StatsLists[Index].RowNames.Length )
    {
            C.DrawColor = Default.WhiteColor * 0.69999999 * F;
      C.DrawColor.A = byte(255 * FMin(F * 2,1.0));
      //C.DrawScreenText(string(i + 1) $ ".",XPos - 0.02,Y,DP_LowerMiddle);
      C.DrawScreenText(StatsLists[Index].RowNames[i],XPos - 0.0725 - C.SizeX / 250000.0,Y,DP_LowerLeft);
      C.DrawScreenText(StatsLists[Index].RowValues[i],XPos + 0.10,Y,DP_LowerRight);
      C.StrLen(StatsLists[Index].RowNames[i],XL,YL);
    } else {
      C.DrawColor = Default.WhiteColor * 0.41 * F;
      C.DrawColor.A = byte(160 * F);
     // C.DrawScreenText(string(i + 1) $ ".",XPos - 0.02,Y,DP_LowerMiddle);
      C.DrawScreenText("-- No Suspect registered 8==0",XPos - 0.0725 - C.SizeX / 250000.0,Y,DP_LowerLeft);
      C.DrawScreenText("-",XPos + 0.10,Y,DP_LowerMiddle);
      C.StrLen("A",XL,YL);
    }
    Y += YL / C.ClipY;
	JL045F:
    ++i;
    goto JL0189;
  }
}


function NewDraw2DLocationDot(Canvas C, vector Loc, int CenterX, int CenterY, int OutsideDiameter)
{
    local rotator Dir;
    local float Angle;
    local Actor Start;

    local int posCenterX;
    local int posCenterY;
    local float length;
    local float dotSize;
    local float dist;
    local float scale;


    if(PlayerOwner.Pawn == None)
    {
        if(PlayerOwner.ViewTarget != None)
            Start = PlayerOwner.ViewTarget;
        else
            Start = PlayerOwner;
    }
    else
    {
        Start = PlayerOwner.Pawn;
    }

    Dir = rotator(Loc - Start.Location);
    Angle = ((Dir.Yaw - Start.Rotation.Yaw) & 65535) * 6.2832 / 65536;
    dist = VSize(Loc - Start.Location);
    scale = 1.5 - dist/3000.0;
    scale = FClamp(scale, 0.5,2.0);

    dotSize = OutsideDiameter * 0.4; // 40% diameter
    dotSize *= scale;
    length = (OutsideDiameter - (dotSize/2.0)) / 2.0;

    posCenterX = CenterX + length * sin(Angle);
    posCenterY = CenterY - length * cos(Angle);

    C.SetPos(posCenterX - (dotSize/2.0), posCenterY - (dotSize/2.0)); //adjust for dot size

    C.Style = ERenderStyle.STY_Alpha;
    C.DrawTile(LocationDot, dotSize, dotSize, 340, 432, 78, 78);
}

defaultproperties
{
    TeamTex=Texture'HUDContent.Generic.HUD'
    Hudzaxis=Texture'WS3SPN.textures.Hudzaxis'
    TrackedPlayer=Texture'WS3SPN.textures.chair'
    FullHealthColor=(B=200,G=100,A=255)
    NameColor=(B=200,G=200,R=200,A=255)
    LocationColor=(G=130,R=175,A=255)
    AdrenColor=(B=201,G=200,R=181,A=255)
    FullAdrenColor=(G=78,R=229,A=255)
    CurrentStatsList=3
}
