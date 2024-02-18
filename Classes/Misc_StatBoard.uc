class Misc_StatBoard extends DMStatsScreen;


#exec TEXTURE IMPORT NAME=Scoreboard_old FILE=Textures\Scoreboard_old.dds GROUP=Textures MIPS=Off ALPHA=1 DXT=5

var Texture Box;
var Texture BaseTex;

var int KillsX;
var int DamageX;
var int FiredX;
var int AccX;

var Misc_PRI OwnerPRI;
var Misc_PRI ViewPRI;

var Color CurrentColor;

static function float GetPercentage(float f1, float f2)
{
    if(f1 == 0.0)
        return 0.0;
    return FMin(100.0, ((f2 / f1) * 100.0));
}

function GetStatsFor(class<Weapon> weaponClass, TeamPlayerReplicationInfo ThePRI, out int killsw)
{
    local int i;
	
    killsw = 0;
    for(i = 0; i < ThePRI.WeaponStatsArray.Length; i++)
    {
        if(class'Object'.static.ClassIsChildOf(ThePRI.WeaponStatsArray[i].WeaponClass, weaponClass))
        {
            killsw = ThePRI.WeaponStatsArray[i].Kills;
            return;
        }
    }
}

simulated function DrawBars(Canvas C, int num, int x, int y, int w, int h)
{
    // background
    C.SetPos(x, y);
    C.DrawColor = CurrentColor; //HUDClass.default.WhiteColor * 0.15;
    //C.DrawColor.A = 128;
    C.DrawRect(Box, w, h * num);

    // outline
    C.DrawColor = HUDClass.default.WhiteColor * 0.4;
    C.SetPos(x, y);
    C.DrawRect(Box, w, 1);
    C.SetPos(x, y);
    C.DrawRect(Box, 1, h * num);
    C.SetPos(x + w, y);
    C.DrawRect(Box, 1, h * num);
    C.SetPos(x, y + h * num);
    C.DrawRect(Box, w + 1, 1);
}

simulated function DrawHitStat(Canvas C, int fired, int hit, int dam, int killsw, string WeaponName, int x, int y, int w, int h, int TextX, int TextY)
{
    local int Acc;
    local float XL, YL;

    DrawBars(C, 1, x, y, w, h);

    Acc = GetPercentage(fired, hit);

    C.SetPos(x + TextX, y + TextY);
    
    /*if(fired > 0)
        C.DrawColor = HUDClass.default.WhiteColor * 0.7;
    else 
        C.DrawColor = HUDClass.default.WhiteColor * 0.3;*/

    C.DrawColor = HUDClass.default.WhiteColor * 0.7;

    C.DrawText(WeaponName, true);
    C.StrLen(killsw, XL, YL);
    C.SetPos(x + KillsX - XL, y + TextY);
    C.DrawText(killsw, true);

    C.StrLen(Hit@"/"@Fired@":", XL, YL);
    C.SetPos(x + FiredX - XL, y + TextY);
    C.DrawText(Hit@"/"@Fired@":", true);

    C.StrLen(Acc, XL, YL);
    C.SetPos(x + AccX - XL, y + TextY);
    C.DrawText(Acc$"%", true);

    C.StrLen(Dam, XL, YL);
    C.SetPos(x + DamageX - XL, y + TextY);
    C.DrawText(dam, true);
}

simulated function DrawHitStats(Canvas C, Misc_PRI.HitStats Stats, string WeaponName, int x, int y, int w, int h, int TextX, int TextY, Misc_PRI TmpPRI, class<Weapon> WeaponClass)
{
    local int Acc, PriAcc, AltAcc;
    local int Dam, PriDam, AltDam;
    local int Fired, PriFired, AltFired;
    local int Hit, PriHit, AltHit;
    local int KillsW;
    local float XL, YL;

    PriFired = Stats.Primary.Fired;
    AltFired = Stats.Secondary.Fired;
    Fired = PriFired + AltFired;
    PriHit = Stats.Primary.Hit;
    AltHit = Stats.Secondary.Hit;
    Hit = PriHit + AltHit;

    Acc = GetPercentage(Fired, PriHit + AltHit);
    PriDam = Stats.Primary.Damage;
    AltDam = Stats.Secondary.Damage;
    Dam = PriDam + AltDam;

    DrawBars(C, 1, x, y, w, h);

    if(PriFired > 0)
        PriAcc = GetPercentage(PriFired, PriHit);
    if(AltFired > 0)
        AltAcc += GetPercentage(AltFired, AltHit);

    GetStatsFor(WeaponClass, TmpPRI, killsw);
    
    C.DrawColor = HUDClass.default.WhiteColor * 0.7;

    C.SetPos(x + TextX, y + TextY);
    C.DrawText(WeaponName, true);

    if(class<FlakCannon>(WeaponClass) != None)
        Fired = PriFired / 9 + AltFired;

    C.StrLen(Hit@"/"@Fired@":", XL, YL);
    C.SetPos(x + FiredX - XL, y + TextY);
    C.DrawText(Hit@"/"@Fired@":", true);

    C.StrLen(Acc, XL, YL);
    C.SetPos(x + AccX - XL, y + TextY);
    C.DrawText(Acc$"%", true);

    C.StrLen(Dam, XL, YL);
    C.SetPos(x + DamageX - XL, y + TextY);
    C.DrawText(Dam, true);

    C.StrLen(killsw, XL, YL);
    C.SetPos(x + KillsX - XL, y + TextY);
    C.DrawText(killsw, true);
    y += h;
    /* summary */

    /* primary */
    C.SetPos(x + TextX + TextX, y + TextY);
    C.DrawText("Pri:", true);

    C.StrLen(PriHit@"/"@PriFired@":", XL, YL);
    C.SetPos(x + FiredX - XL, y + TextY);
    C.DrawText(PriHit@"/"@PriFired@":", true);

    C.StrLen(PriAcc, XL, YL);
    C.SetPos(x + AccX - XL, y + TextY);
    C.DrawText(PriAcc$"%", true);

    C.StrLen(PriDam, XL, YL);
    C.SetPos(x + DamageX - XL, y + TextY);
    C.DrawText(PriDam, true);
    y += h;
    /* primary */

    /* alt */
    C.SetPos(x + TextX + TextX, y + TextY);
    C.DrawText("Alt:", true);

    C.StrLen(AltHit@"/"@AltFired@":", XL, YL);
    C.SetPos(x + FiredX - XL, y + TextY);
    C.DrawText(AltHit@"/"@AltFired@":", true);

    C.StrLen(AltAcc, XL, YL);
    C.SetPos(x + AccX - XL, y + TextY);
    C.DrawText(AltAcc$"%", true);

    C.StrLen(AltDam, XL, YL);
    C.SetPos(x + DamageX - XL, y + TextY);
    C.DrawText(AltDam, true);
    /* alt */
}

simulated event DrawScoreBoard(Canvas C)
{
    local Misc_PRI TmpPRI;

    local int Awards, Combos;
    local int TextX, TextY;
    local int Dam, killsw;
    local int i, j;
    local float XL, YL, XL2, YL2;
    local Color Red;
    local Color Blue;
    local Color OwnerColor;
    local Color ViewedColor;
    local string name;
    local byte OwnerTeam, ViewTeam;
	local string PointsStr;
    local int BarX;
    local int BarY;
    local int BarW;
    local int BarH;
	local int LastPPRTextXPos;
    local int MiscX;
    local int MiscY;
    local int MiscW;
    local int MiscH;
	local int pprIdx;
    local int PlayerBoxX;
    local int PlayerBoxY;
    local int PlayerBoxW;
    local int PlayerBoxH;
	local string PPRStr;
	
    if(PlayerOwner == None)
	{
		PlayerOwner = UnrealPlayer(Owner);
		if(PlayerOwner == None)
		{
			Super.DrawScoreboard(C);
			return;
		}
	}

    if(PRI == None)
    {
        PRI = TeamPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);
		if(PRI == None)
		{
			Super.DrawScoreboard(C);
			return;
		}

        if(PRI.bOnlySpectator || PRI.bOutOfLives)
        {
            if(Pawn(PlayerOwner.ViewTarget) != None && Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo != None)
                PRI = TeamPlayerReplicationInfo(Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo);
            else
                NextStats();
        }
    }

    ViewPRI = Misc_PRI(PRI);
	if(ViewPRI == None)
	{
		Super.DrawScoreboard(C);
		return;
	}
		
    if(OwnerPRI == None || Misc_Player(PlayerOwner).bFirstOpen )
    {    
        OwnerPRI = Misc_PRI(PlayerOwner.PlayerReplicationInfo);
        if(PlayerOwner.PlayerReplicationInfo.bOnlySpectator && Pawn(PlayerOwner.ViewTarget) != None)
        {
            OwnerPRI = Misc_PRI(Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo);
            if(OwnerPRI == None)
				OwnerPRI = ViewPRI;
        }

        Misc_Player(PlayerOwner).bFirstOpen = false;
    }

    Red = HUDClass.default.RedColor;
    Red.A = 200;
    Blue = HUDClass.default.TurqColor;
    Blue.A = 200;

    if(OwnerPRI.Team == None)
        OwnerTeam = 255;
    else
        OwnerTeam = OwnerPRI.Team.TeamIndex;

    if(ViewPRI.Team == None)
        ViewTeam = 255;
    else
        ViewTeam = ViewPRI.Team.TeamIndex;

    if(OwnerTeam == 255 || OwnerTeam == 1)
        OwnerColor = Blue;
    else
        OwnerColor = Red;

    if(ViewTeam == 255 || ViewTeam == 1)
        ViewedColor = Blue;
    else
        ViewedColor = Red;

    if(Level.TimeSeconds - LastUpdateTime > 5)
    {
        LastUpdateTime = Level.TimeSeconds;
        PlayerOwner.ServerUpdateStats(OwnerPRI);
        PlayerOwner.ServerUpdateStats(ViewPRI);
    }

    MiscW = C.ClipX * 0.48;

    PlayerBoxX = C.ClipX * 0.02;
    PlayerBoxW = C.ClipX * 0.46;
    PlayerBoxH = C.ClipY * 0.5174;

    BarH = PlayerBoxH / 15;
    BarW = C.ClipX * 0.46;

    TextX = 0.005 * C.ClipX;
    TextY = 0.0036 * C.ClipY;

    KillsX = (PlayerBoxW * 0.69) * 0.4;
    AccX = (PlayerBoxW * 0.69) * 0.75;
    DamageX = (PlayerBoxW * 0.69) - TextX;

    /* draw the player's backgrounds */
    // draw the top and example bar
    C.Style = ERenderStyle.STY_Alpha;
    C.DrawColor = HUDClass.default.WhiteColor;
    C.DrawColor.A = 175;

    MiscX = C.ClipX * 0.01;
    MiscY = C.ClipY * 0.1;
    MiscH = C.ClipY * 0.1183;
    C.SetPos(MiscX, MiscY);
    C.DrawTile(BaseTex, MiscW, MiscH, 126, 126, 772, 137);

    MiscX = C.ClipX * 0.51;
    C.SetPos(MiscX, MiscY);
    C.DrawTile(BaseTex, MiscW, MiscH, 126, 125, 772, 137);

    MiscX = C.ClipX * 0.01;
    MiscY = MiscY + MiscH;
    MiscH = C.ClipY * 0.0366;
    MiscW = C.ClipX * 0.0075;
    C.SetPos(MiscX, MiscY);
    C.DrawTile(BaseTex, MiscW, MiscH, 126, 263, 10, 10);

    MiscX = C.ClipX * 0.51;
    C.SetPos(MiscX, MiscY);
    C.DrawTile(BaseTex, MiscW, MiscH, 126, 263, 10, 10);

    MiscX = C.ClipX * 0.01 + MiscW;
    MiscW = C.ClipX * 0.48 - (MiscW * 2);
    C.SetPos(MiscX, MiscY);
    C.DrawColor = OwnerColor;
    C.DrawTile(BaseTex, MiscW, MiscH, 137, 263, 751, 42);

    C.SetPos(MiscX + MiscW, MiscY);
    C.DrawColor = HUDClass.default.WhiteColor;
    C.DrawColor.A = 175;
    C.DrawTile(BaseTex, C.ClipX * 0.0069, MiscH, 888, 263, 10, 10);

    MiscX = MiscX + C.ClipX * 0.5;
    C.SetPos(MiscX, MiscY);
    C.DrawColor = ViewedColor;
    C.DrawTile(BaseTex, MiscW, MiscH, 137, 263, 751, 42);

    C.SetPos(MiscX + MiscW, MiscY);
    C.DrawColor = HUDClass.default.WhiteColor;
    C.DrawColor.A = 175;
    C.DrawTile(BaseTex, C.ClipX * 0.0069, MiscH, 888, 263, 10, 10);

    MiscX = C.ClipX * 0.01;
    MiscY = MiscY + MiscH;
    MiscH = C.ClipY * 0.005;
    MiscW = C.ClipX * 0.48;
    C.SetPos(MiscX, MiscY);
    C.DrawTile(BaseTex, MiscW, MiscH, 126, 306, 772, 4);

    MiscX = C.ClipX * 0.51;
    C.SetPos(MiscX, MiscY);
    C.DrawTile(BaseTex, MiscW, MiscH, 126, 306, 772, 4);

    PlayerBoxY = MiscY + MiscH + (C.ClipY * 0.005);

    MiscX = C.ClipX * 0.01;
    MiscY = MiscY + MiscH;
    MiscH = C.ClipY * 0.5175;
    C.SetPos(MiscX, MiscY);
    C.DrawTile(BaseTex, MiscW, MiscH, 126, 398, 772, 10);

    MiscX = C.ClipX * 0.51;
    C.SetPos(MiscX, MiscY);
    C.DrawTile(BaseTex, MiscW, MiscH, 126, 398, 772, 10);

    MiscX = C.ClipX * 0.01;
    MiscY = MiscY + MiscH;
    MiscH = C.ClipY * 0.0633;
    C.SetPos(MiscX, MiscY);
    C.DrawTile(BaseTex, MiscW, MiscH, 126, 829, 772, 68);

    MiscX = C.ClipX * 0.51;
    C.SetPos(MiscX, MiscY);
    C.DrawTile(BaseTex, MiscW, MiscH, 126, 829, 772, 68);
	
	
  MiscH = C.ClipY * 0.0633;
  MiscW = MiscH;
  MiscX = (C.ClipX - MiscW) * 0.5;
  MiscY = (C.ClipY - MiscH) * 0.5;
  C.SetPos(MiscX,MiscY);
  C.DrawColor = HudClass.Default.WhiteColor;
  C.DrawColor.A = 175;
  C.DrawTile(BaseTex, MiscW,MiscH,0.0,0.0,64.0,64.0);
  if ( OwnerPRI.Rank == 1.0 )
  {
    PointsStr = "Thanks for Playing! You got the highest possible ;)!!";
  } else {
    if ( OwnerPRI.AvgPPR == 0.0 )
    {
      PointsStr = "Make Some Points To See How Close You Are To Rank Up! ";
     
    }else {
      PointsStr = "You Are -> " $ string(int(OwnerPRI.PointsToRankUp))  $ " <-Points away from the NEXT Rank! ";
    }																							
  }
	
	 MiscX = 0;
  MiscW = int(C.ClipX);
  MiscH = int(C.ClipY * 0.04);
  MiscY = int(C.ClipY - MiscH);
  C.SetPos(MiscX,MiscY);
  C.Style = 5;
  C.DrawColor = HudClass.Default.BlackColor;
  C.DrawColor.A = 175;
  C.DrawTile(Box,MiscW,MiscH,126.0,790.0,772.0,137.0);
  C.DrawColor = HudClass.Default.WhiteColor * 0.80999999;
  C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C,-3);
  C.TextSize(PointsStr,XL,YL);
  C.SetPos((C.ClipX - XL) * 0.5,MiscY + C.ClipY * 0.011);
  C.DrawText(PointsStr,True);
	
    /* draw the player's backgrounds */

    /* draw name, score, kills, etc... in the top */
    for(i = 0; i < 2; i++)
    {
        if(i == 0)
        {
            TmpPRI = OwnerPRI;
            BarX = C.ClipX * 0.02;
        }
        else
        {
            BarX = C.ClipX * 0.52;
            TmpPRI = ViewPRI;
        }

        BarY = C.ClipY * 0.155;

        C.Font = PlayerController(Owner).MyHUD.GetFontSizeIndex(C, -2);

        // name  
        if(TmpPRI.bOutOfLives)
            C.DrawColor = HUDClass.default.WhiteColor * 0.5;
        else 
            C.DrawColor = HUDClass.default.WhiteColor * 0.7;
        C.SetPos(BarX + (C.ClipX * 0.01), BarY + (C.ClipY * 0.008));
        name = TmpPRI.GetColoredName();
        C.StrLen(name, XL, YL);
        if(XL > C.ClipX * 0.23)
            name = Left(name, C.ClipX * 0.23 / XL * len(name));
        C.DrawText(name, true);

        // score
        name = string(int(TmpPRI.Score % 10000));
        C.DrawColor = HUDClass.default.WhiteColor * 0.7;
        C.StrLen(name, XL, YL);
        C.SetPos(BarX + (C.ClipX * 0.27) - (XL * 0.5), BarY + (C.ClipY * 0.008));
        C.DrawText(name, true);

        // kills
        if(!PlayerController(Owner).GameReplicationInfo.bTeamGame)
            name = string(int(TmpPRI.Score / 10000));
        else
            name = string(TmpPRI.Kills);

        C.StrLen(name, XL, YL);
        C.SetPos(BarX + (C.ClipX * 0.35) - (XL * 0.5), BarY + (C.ClipY * 0.008));
        C.DrawText(name, true);

        // ping
        C.DrawColor = HUDClass.default.CyanColor * 0.5;
        C.DrawColor.B = 150;
        C.DrawColor.R = 20;
        name = string(Min(999, TmpPRI.Ping *4));
        C.StrLen(name, XL, YL);
        C.SetPos(BarX + (C.ClipX * 0.42) - (XL * 0.5), BarY + (C.ClipY * 0.008));
        C.DrawText(name, true);
		
		
		C.Style = 5;
    C.DrawColor = HudClass.Default.WhiteColor;
    C.DrawColor.A = 175;
    if ( (ViewPRI != OwnerPRI) || (i == 0) )
    {
      MiscX = int(C.ClipX * 0.0);
      MiscH = int(C.ClipY * 0.04);
      C.SetPos(MiscX,MiscY);
      C.DrawColor = HudClass.Default.BlackColor;
      C.DrawColor.A = 175;
     // C.DrawTile(Box,C.ClipX,MiscH,126.0,790.0,772.0,137.0);
      C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C,-3);
     C.DrawColor = HudClass.Default.Whitecolor * 0.69999999;
      LastPPRTextXPos = int(C.ClipX * 0.03);
      if ( i == 0 )
      {
        MiscY = int(int(C.ClipY * 0.01) * 1.0);
      } else {
        MiscY = int(int(C.ClipY * 0.013) * 4.0);
      }
      if ( ViewPRI != None )
      {
        if ( Len(OwnerPRI.PlayerName) > Len(ViewPRI.PlayerName) )
        {
//			if(OwnerPRI.Moneyreal > 0)
//				{Name = OwnerPRI.PlayerName @"d";}
//          Name = OwnerPRI.PlayerName;
        } else {
		  
          Name = ViewPRI.PlayerName;
        }
        C.TextSize(Name $ " PPRs: "  ,XL,YL);
        LastPPRTextXPos = int(C.ClipX * 0.01 + XL);
        Name = TmpPRI.GetColoredName();
        C.TextSize(Name $ " PPRs: ",XL,YL);
        C.SetPos(LastPPRTextXPos - XL,MiscY);
        C.DrawText("²²²" $ Name $ "²²² PPRs: "  ,True);
        C.DrawColor.A = 175;
      }
	  
	  pprIdx = 0;
	  JL14F0:
      
      if ( pprIdx < TmpPRI.PPRListLength - 1 )
      {
        if ( (TmpPRI.PPRListLength == 25) && (pprIdx == 0) )
        {
          C.DrawColor = HudClass.Default.RedColor * 0.89999998;
        } else {
          C.DrawColor = HudClass.Default.WhiteColor * 0.81;
        }
        PPRStr = Class'Misc_PRI'.static.GetFormattedPPR(TmpPRI.PPRList[pprIdx]);
        C.SetPos(LastPPRTextXPos,MiscY);
        C.StrLen(PPRStr,XL,YL);
        LastPPRTextXPos += int(XL + C.ClipX * 0.011);
        C.DrawText(PPRStr,True);
        pprIdx++;
        goto JL14F0;
      }
	 
    }

        C.Font = PlayerController(Owner).MyHUD.GetFontSizeIndex(C, -3);
        name = string(TmpPRI.PacketLoss);
        C.StrLen(name, XL, YL);
        C.SetPos(BarX + (C.ClipX * 0.42) - (XL * 0.5), BarY + (C.ClipY * 0.035));
        C.DrawText(name, true);

        // location (ready/not ready/dead)
        // location (ready/not ready/dead)
        if(!GRI.bMatchHasBegun)
        {
            if(TmpPRI.bReadyToPlay)
                name = class'TAM_Scoreboard'.default.ReadyText;
            else
                name = class'TAM_Scoreboard'.default.NotReadyText;

            if(TmpPRI.bAdmin)
            {
                name = "Admin -"@name;
                C.DrawColor.R = 170;
                C.DrawColor.G = 20;
                C.DrawColor.B = 20;
            }
            else
            {
                C.DrawColor = HUDClass.default.RedColor * 0.7;
                C.DrawColor.G = 130;
            }
        }
        else
        {
            if(!TmpPRI.bAdmin && !TmpPRI.bOutOfLives)
            {
                C.DrawColor = HUDClass.default.RedColor * 0.7;
                C.DrawColor.G = 130;

                if((TmpPRI.Team != None && TmpPRI.Team.TeamIndex == OwnerTeam) || TmpPRI == OwnerPRI)
                    name = TmpPRI.GetLocationName();
                else
                    name = TmpPRI.StringUnknown;
            }
            else
            {
                C.DrawColor.R = 170;
                C.DrawColor.G = 20;
                C.DrawColor.B = 20;

                if(TmpPRI.bAdmin)
                    name = "Admin";
                else if(TmpPRI.bOutOfLives)
                    name = "Dead";
            }
        }
        C.StrLen(name, XL, YL);
        if(XL > C.ClipX * 0.23)
            name = left(name, C.ClipX * 0.23 / XL * len(name));
        C.SetPos(BarX + (C.ClipX * 0.02), BarY + (C.ClipY * 0.035));
        C.DrawText(name, true);

        // points per round
        C.DrawColor = HUDClass.default.WhiteColor * 0.55;
        
        if(TmpPRI.PlayedRounds > 0)
            XL = (TmpPRI.Score % 10000) / TmpPRI.PlayedRounds;
        else
            XL = (TmpPRI.Score % 10000);

        if(int((XL - int(XL)) * 10) < 0)
        {
            if(int(XL) == 0)
                name = "-"$string(int(XL));
            else
                name = string(int(XL));
            name = name$"."$-int((XL - int(XL)) * 10);
        }
        else
        {
            name = string(int(XL));
            name = name$"."$int((XL - int(XL)) * 10);
        }

        C.StrLen(name, XL, YL);
        C.SetPos(BarX + (C.ClipX * 0.27) - (XL * 0.5), BarY + (C.ClipY * 0.035));
        C.DrawText(name, true);

        // draw deaths
        C.DrawColor.R = 170;
        C.DrawColor.G = 20;
        C.DrawColor.B = 20;
        name = string(int(TmpPRI.Deaths));
        C.StrLen(name, xl, yl);
        C.SetPos(BarX + (C.ClipX * 0.35) - (XL * 0.5), BarY + (C.ClipY * 0.035));
        C.DrawText(name, true);
		
		
		
		
		
		
		
		

    }
    /* draw name, score, etc... in top */

    for(j = 0; j < 2; j++)
    {
        if(j == 0)
        {
            TmpPRI = OwnerPRI;
            PlayerBoxX = C.ClipX * 0.02;

            CurrentColor = OwnerColor * 0.35;
            CurrentColor.A = 75;
        }
        else
        {
            TmpPRI = ViewPRI;
            PlayerBoxX = C.ClipX * 0.52;

            CurrentColor = ViewedColor * 0.35;
            CurrentColor.A = 75;
        }

        /* awards */
        MiscX = PlayerBoxX + (PlayerBoxW * 0.7);
        MiscY = PlayerBoxY;
        MiscW = PlayerBoxW * 0.295;
        MiscH = C.ClipY * 0.02;
        C.StrLen("Test", XL, YL);
        TextY = (MiscH * 0.6 - YL * 0.5);

        Awards = 1;
        if(TmpPRI.bFirstBlood)
            Awards++;

        for(i = 0; i < 6; i++)
            if(TmpPRI.Spree[i] > 0)
                Awards++;

        for(i = 0; i < 7; i++)
            if(TmpPRI.MultiKills[i] > 0)
                Awards++;

        if(TmpPRI.FlakCount > 4)
            Awards++;
        if(TmpPRI.ComboCount > 4)
            Awards++;
        if(TmpPRI.HeadCount > 2)
            Awards++;
		if(TmpPRI.LinkCount > 0) 
            Awards++;
        if(TmpPRI.HatTrickCount > 0)
            Awards++;
		if(TmpPRI.MinigunCount > 3)
            Awards++;
        if(TmpPRI.GoalsScored > 0)
            Awards++;
        if(TmpPRI.FlawlessCount > 0)
            Awards++;
        if(TmpPRI.OverkillCount > 0)
            Awards++;
        if(TmpPRI.DarkHorseCount > 0)
            Awards++;
        if(TmpPRI.ranovercount > 4)
            Awards++;
        if(TmpPRI.CampCount > 1)
            Awards++;
        if(TmpPRI.Suicides > 2)
            Awards++;
		if ( TmpPRI.LinkCount >= Class'DamType_LinkShaft'.Default.AwardLevel )		
		Awards++;		
		if(TmpPRI.rocketsuicide > 0)
           Awards++;
		if(TmpPRI.RoxCount >= 7)
			Awards++;
		if(TmpPRI.GrenCount  >= Class'DamType_AssaultGrenade'.Default.AwardLevel)
			Awards++;	
		if(TmpPRI.ShieldCount  >= Class'DamType_ShieldImpact'.Default.AwardLevel)
			Awards++;	
			
			
		
        DrawBars(C, Awards, MiscX, MiscY, MiscW, MiscH);
        C.SetPos(MiscX + TextX, MiscY + TextY);
        C.DrawColor = HUDClass.default.WhiteColor * 0.7;
        C.DrawText("Awards", true);

        if(Awards > 1)
        {
            MiscX += TextX;
            MiscY += MiscH;

            if(TmpPRI.bFirstBlood)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText(FirstBloodString);
                MiscY += MiscH;
            }

            for(i = 0; i < 6; i++)
            {
                if(TmpPRI.Spree[i] > 0)
                {
                    C.SetPos(MiscX + TextX, MiscY + TextY);
                     C.DrawText(Class'KillingSpreeMessage'.Default.SelfSpreeNote[i] $ MakeColorCode(HudClass.Default.GoldColor * 0.69999999) $ "x" $ string(TmpPRI.Spree[i]));;
                    MiscY += MiscH;
                }
            }

            for(i = 0; i < 7; i++)
            {
                if(TmpPRI.MultiKills[i] > 0)
                {
                    C.SetPos(MiscX + TextX, MiscY + TextY);
                    C.DrawText(KillString[i]$MakeColorCode(HUDClass.default.GoldColor * 0.7)$"x"$TmpPRI.MultiKills[i]);
                    MiscY += MiscH;
                }
            }

            if(TmpPRI.FlakCount >= 4)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText(FlakMonkey);
                MiscY += MiscH;
            }

            if(TmpPRI.ranovercount >= 4)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("Bukkake!");
                MiscY += MiscH;
            }

            if(TmpPRI.combocount >= Class'DamType_ShockCombo'.Default.AwardLevel)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("Combo Whore");
                MiscY += MiscH;
            }

            if(TmpPRI.HeadCount > 5)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("HeadHunter");
                MiscY += MiscH;
            }
			
			if(TmpPRI.LinkCount >= Class'DamType_LinkShaft'.Default.AwardLevel)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("Link Shafter");
                MiscY += MiscH;
            }

            if(TmpPRI.GoalsScored > 0)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("Final Kill!"$MakeColorCode(HUDClass.default.GoldColor * 0.7)$"x"$TmpPRI.GoalsScored);
                MiscY += MiscH;
            }

            if(TmpPRI.HatTrickCount > 0)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("Hat-trick!"$MakeColorCode(HUDClass.default.GoldColor * 0.7)$"x"$TmpPRI.HatTrickCount);
                MiscY += MiscH;
            }
			
            if(TmpPRI.FlawlessCount > 0)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("Flawless!"$MakeColorCode(HUDClass.default.GoldColor * 0.7)$"x"$TmpPRI.FlawlessCount);
                MiscY += MiscH;
            }

            if(TmpPRI.OverkillCount > 0)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("Overkill!"$MakeColorCode(HUDClass.default.GoldColor * 0.7)$"x"$TmpPRI.OverkillCount);
                MiscY += MiscH;
            }

            if(TmpPRI.DarkHorseCount > 0)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("Dark Horse!"$MakeColorCode(HUDClass.default.GoldColor * 0.7)$"x"$TmpPRI.DarkHorseCount);
                MiscY += MiscH;
            }

            if(TmpPRI.CampCount > 1)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("Campy Bastard!", true);
                MiscY += MiscH;
            }

            if(TmpPRI.Suicides > 2)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("Emo!", true);
                MiscY += MiscH;
            }
			
			if(TmpPRI.RoxCount >= 7)
			{
				C.SetPos(MiscX + TextX, MiscY + TextY);
				C.DrawText("Rocket Man!", true);
				MiscY += MiscH;
			}
			
			if(TmpPRI.ShieldCount >= 1)
			{
				C.SetPos(MiscX + TextX, MiscY + TextY);
				C.DrawText("Shield!", true);
				MiscY += MiscH;
			}
			
			if(TmpPRI.GrenCount >= 1)
			{
				C.SetPos(MiscX + TextX, MiscY + TextY);
				C.DrawText("Grand!", true);
				MiscY += MiscH;
			}
			
			if(TmpPRI.MinigunCount >= 3)
            {
                C.SetPos(MiscX + TextX, MiscY + TextY);
                C.DrawText("Minigun KING");
                MiscY += MiscH;
            }

            MiscX -= TextX;
        }
        /* awards */

        /* combos */  
        if(Awards == 1)
            MiscY += MiscH * 1.275;
        else
            MiscY += MiscH * 0.275;

        Combos = 1;
        for(i = 0; i < 5; i++)
            if(TmpPRI.Combos[i] > 0)
                Combos++;

        DrawBars(C, Combos, MiscX, MiscY, MiscW, MiscH);
        C.SetPos(MiscX + TextX, MiscY + TextY);
        C.DrawColor = HUDClass.default.WhiteColor * 0.7;
        C.DrawText("Combos", true);

        if(Combos > 1)
        {
            MiscX += TextX;
            for(i = 0; i < 5; i++)
            {
                if(TmpPRI.Combos[i] > 0)
                {
                    MiscY += MiscH;
                    C.SetPos(MiscX + TextX, MiscY + TextY);
                    C.DrawText(ComboNames[i]$MakeColorCode(HUDClass.default.GoldColor * 0.7)$"x"$TmpPRI.Combos[i]);
                }
            }
            MiscX -= TextX;
        }
        /* combo */

        /* efficiency */
        MiscY += MiscH * 1.275;

        DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
        C.DrawColor = HUDClass.default.WhiteColor * 0.7;
        
        C.SetPos(MiscX + TextX, MiscY + TextY);
        C.DrawText("Efficiency:", true);

        name = string(int(GetPercentage(TmpPRI.Deaths + TmpPRI.Kills, TmpPRI.Kills))) $ "%";
        C.StrLen(name, XL, YL);
        C.SetPos(MiscX + MiscW - TextX - XL, MiscY + TextY);
        C.DrawText(name, true);
        /* efficiency */

        /* RFF */
        if(PlayerController(Owner).GameReplicationInfo.bTeamGame)
        {
            MiscY += MiscH * 1.275;

            DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
            C.DrawColor = HUDClass.default.WhiteColor * 0.7;
            
            C.SetPos(MiscX + TextX, MiscY + TextY);
            C.DrawText("ReverseFF:", true);

            name = string(int(TmpPRI.ReverseFF * 100)) $ "%";
            C.StrLen(name, XL, YL);
            C.SetPos(MiscX + MiscW - TextX - XL, MiscY + TextY);
            C.DrawText(name, true);
        }
        /* RFF */

        /* Res */
        MiscY += MiscH * 1.275;
        DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
        C.DrawColor = HUDClass.default.WhiteColor * 0.7;
        
        C.SetPos(MiscX + TextX, MiscY + TextY);
        C.DrawText("Resurrections:", true);

        name = string(TmpPRI.ResCount);
        C.StrLen(name, XL, YL);
        C.SetPos(MiscX + MiscW - TextX - XL, MiscY + TextY);
        C.DrawText(name, true);

        if(Freon_PRI(TmpPRI) != None)
        {
            /* Thaw */
            MiscY += MiscH * 1.275;
            DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
            C.DrawColor = HUDClass.default.WhiteColor * 0.7;
            
            C.SetPos(MiscX + TextX, MiscY + TextY);
            C.DrawText("Thaws:", true);

            name = string(Freon_PRI(TmpPRI).Thaws);
            C.StrLen(name, XL, YL);
            C.SetPos(MiscX + MiscW - TextX - XL, MiscY + TextY);
            C.DrawText(name, true);

            /* Git */
            MiscY += MiscH * 1.275;
            DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
            C.DrawColor = HUDClass.default.WhiteColor * 0.7;
            
            C.SetPos(MiscX + TextX, MiscY + TextY);
            C.DrawText("Gits:", true);

            name = string(Freon_PRI(TmpPRI).Git);
            C.StrLen(name, XL, YL);
            C.SetPos(MiscX + MiscW - TextX - XL, MiscY + TextY);
            C.DrawText(name, true);
        }

        MiscY += MiscH * 1.275;
        //DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
        DrawBars(C, TmpPRI.VsStatsList.Length+2, MiscX, MiscY, MiscW, MiscH);
        C.DrawColor = HUDClass.default.WhiteColor * 0.7;
        
        C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C,-5);
        C.StrLen("X", XL, YL);
        C.SetPos(MiscX + TextX, MiscY + TextY + YL/4);
        C.DrawText("Versus:               Kills Deaths", true);

        for(i=0;i<TmpPRI.VsStatsList.Length;i++)
        {
            /* vs stats */
            MiscY += MiscH;
            C.DrawColor = HUDClass.default.WhiteColor * 0.7;
            
            C.SetPos(MiscX + TextX, MiscY + TextY);
            name = TmpPRI.VsStatsList[i].OpponentName;
            C.StrLen(class'Misc_Util'.static.StripColor(name), XL, YL);
            if(XL > C.ClipX * 0.08)
                name = Left(name, C.ClipX * 0.08 / XL * len(class'Misc_Util'.static.StripColor(name)));
            C.DrawText(name, true);

            C.DrawColor = HUDClass.default.WhiteColor * 0.7;
            name = string(TmpPRI.VsStatsList[i].Wins);
            C.StrLen(name, XL, YL);
            C.StrLen("XXXXXX", XL2, YL2);
            C.SetPos(MiscX + MiscW - TextX - XL - XL2, MiscY + TextY);
            C.DrawText(string(TmpPRI.VsStatsList[i].Wins), true);
            name = string(TmpPRI.VsStatsList[i].Losses);
            C.StrLen(name, XL, YL);
            C.SetPos(MiscX + MiscW - TextX - XL, MiscY + TextY);
            C.DrawText(name, true);
        }
        C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C,-3);

        /* weapons */
        // show 'Weapon'...'Kills'...etc. bar
        MiscX = PlayerBoxX + (PlayerBoxW * 0.005);
        MiscY = PlayerBoxY;
        MiscW = PlayerBoxW * 0.69;

        DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
        C.SetPos(MiscX + TextX, MiscY + TextY);
        C.DrawColor = HUDClass.default.WhiteColor * 0.7;
        C.DrawText("Weapon", true);
        C.StrLen("Kills", XL, YL);
        C.SetPos(MiscX + KillsX - XL, MiscY + TextY);
        C.DrawText("Kills", true);
        C.StrLen("Shots : Acc", XL, YL);
        C.SetPos(MiscX + AccX - XL, MiscY + TextY);
        C.DrawText("Shots : Acc%", true);
        C.StrLen("Dam.", XL, YL);
        C.SetPos(MiscX + DamageX - XL, MiscY + TextY);
        C.DrawText("Dam.", true);
        MiscY += MiscH * 1.275;

        C.StrLen(" Acc", XL, YL);
        FiredX = AccX - XL;


        // SG
        if(TmpPRI.SGDamage > 0)
        {
            DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);

            dam = TmpPRI.SGDamage;
            if(dam > 0)
                C.DrawColor = HUDClass.default.WhiteColor * 0.7;
            else
                C.DrawColor = HUDClass.default.WhiteColor * 0.3;
            C.SetPos(MiscX + TextX, MiscY + TextY);
            C.DrawText("Shield", true);
            C.StrLen(dam, XL, YL);
            C.SetPos(MiscX + DamageX - XL, MiscY + TextY);
            C.DrawText(dam, true);

            GetStatsFor(class'ShieldGun', TmpPRI, killsw);
            C.StrLen(killsw, XL, YL);
            C.SetPos(MiscX + KillsX - XL, MiscY + TextY);
            C.DrawText(killsw, true);
        }
        MiscY += MiscH * 1.275;
		
        // assault
        if(TmpPRI.Assault.Primary.Fired > 0 || TmpPRI.Assault.Secondary.Fired > 0)
            DrawHitStats(C, TmpPRI.Assault, "Assault", MiscX, MiscY, MiscW, MiscH, TextX, TextY, TmpPRI, class'AssaultRifle');
        MiscY += MiscH * 3.275;

        // bio
        if(TmpPRI.Bio.Fired > 0)
        {
            GetStatsFor(class'BioRifle', TmpPRI, killsw);
            DrawHitStat(C, TmpPRI.Bio.Fired, TmpPRI.Bio.Hit, TmpPRI.Bio.Damage, killsw, "Bio", MiscX, MiscY, MiscW, MiscH, TextX, TextY);
        }
        MiscY += MiscH * 1.275;

        // shock
        if(TmpPRI.Shock.Primary.Fired > 0 || TmpPRI.Shock.Secondary.Fired > 0)
            DrawHitStats(C, TmpPRI.Shock, "Shock", MiscX, MiscY, MiscW, MiscH, TextX, TextY, TmpPRI, class'ShockRifle');
        MiscY += MiscH * 3.275;

        // combo
        if(TmpPRI.Combo.Fired > 0)
            DrawHitStat(C, TmpPRI.Combo.Fired, TmpPRI.Combo.Hit, TmpPRI.Combo.Damage, TmpPRI.ComboCount, "Combo", MiscX, MiscY, MiscW, MiscH, TextX, TextY);
        MiscY += MiscH * 1.275;

        // link
        if(TmpPRI.Link.Primary.Fired > 0 || TmpPRI.Link.Secondary.Fired > 0)
            DrawHitStats(C, TmpPRI.Link, "Link", MiscX, MiscY, MiscW, MiscH, TextX, TextY, TmpPRI, class'LinkGun');
        MiscY += MiscH * 3.275;

        // mini
        if(TmpPRI.Mini.Primary.Fired > 0 || TmpPRI.Mini.Secondary.Fired > 0)
            DrawHitStats(C, TmpPRI.Mini, "Mini", MiscX, MiscY, MiscW, MiscH, TextX, TextY, TmpPRI, class'MiniGun');
        MiscY += MiscH * 3.275;

        // flak
        if(TmpPRI.Flak.Primary.Fired > 0 || TmpPRI.Flak.Secondary.Fired > 0)
            DrawHitStats(C, TmpPRI.Flak, "Flak", MiscX, MiscY, MiscW, MiscH, TextX, TextY, TmpPRI, class'FlakCannon');
        MiscY += MiscH * 3.275;

        // rockets
        if(TmpPRI.Rockets.Fired > 0)
        {
            GetStatsFor(class'RocketLauncher', TmpPRI, killsw);
            DrawHitStat(C, TmpPRI.Rockets.Fired, TmpPRI.Rockets.Hit, TmpPRI.Rockets.Damage, killsw, "Rockets", MiscX, MiscY, MiscW, MiscH, TextX, TextY);
        }
        MiscY += MiscH * 1.275;

        // SNIPER
        if(TmpPRI.ClassicSniper.Fired > 0)
        {
            GetStatsFor(class'ClassicSniperRifle', TmpPRI, killsw);
            DrawHitStat(C, TmpPRI.ClassicSniper.Fired, TmpPRI.ClassicSniper.Hit, TmpPRI.ClassicSniper.Damage, killsw, "Sniper", MiscX, MiscY, MiscW, MiscH, TextX, TextY);
        }
        MiscY += MiscH * 1.275;  

        // LG
        if(TmpPRI.Sniper.Fired > 0)
        {
            GetStatsFor(class'SniperRifle', TmpPRI, killsw);
            DrawHitStat(C, TmpPRI.Sniper.Fired, TmpPRI.Sniper.Hit, TmpPRI.Sniper.Damage, killsw, "Lightning", MiscX, MiscY, MiscW, MiscH, TextX, TextY);
        }
        MiscY += MiscH * 1.275;
				
       // headshots
       if(TmpPRI.Sniper.Hit > 0 || TmpPRI.ClassicSniper.Hit > 0)
       DrawHitStat(C, TmpPRI.Sniper.Hit + TmpPRI.ClassicSniper.Hit, TmpPRI.HeadShots, TmpPRI.HeadShots * 140, TmpPRI.HeadCount, "Headshots", MiscX, MiscY, MiscW, MiscH, TextX, TextY);
       MiscY += MiscH * 1.275;

        // total
        DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
        C.DrawColor = HUDClass.default.WhiteColor * 0.7;
        C.SetPos(MiscX + TextX, MiscY + TextY);
        C.DrawText("Total", true);
        dam = TmpPRI.EnemyDamage;
        C.StrLen(dam, XL, YL);
        C.SetPos(MiscX + DamageX - XL, MiscY + TextY);
        C.DrawText(dam, true);

        killsw = TmpPRI.Kills;
        C.StrLen(killsw, XL, YL);
        C.SetPos(MiscX + KillsX - XL, MiscY + TextY);
        C.DrawText(killsw, true);

        MiscY += MiscH * 1.275;
        /* weapons */
    }

    bDisplayMessages = true;
}

defaultproperties
{
     Box=Texture'Engine.WhiteSquareTexture'
     BaseTex=Texture'3SPNvSoL.textures.Scoreboard_old'
}
