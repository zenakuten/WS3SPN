//================================================================================
// Message_Camper.
//================================================================================

class Message_Camper extends LocalMessage;
//#exec TEXTURE IMPORT NAME=camp8 FILE=Textures\chair.dds GROUP=Textures MIPS=On ALPHA=1 DXT=5
var localized string YouAreCampingDefault;
var localized string YouAreCampingWarning;
var localized string YouAreCampingFirst;
var localized string YouAreCampingSecond;
var localized string YouAreCampingThird;
var localized string PlayerIsCampingOpen;
var localized string PlayerIsCamping;
var localized string Playeriscamp;
var Sound bastard;
//var Color CamperIconColor;

static function RenderComplexMessage (Canvas C, out float XL, out float YL, optional string MessageString, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  local PlayerController LocalPlayer;

  if ( RelatedPRI_1 != None )
  {
    LocalPlayer = RelatedPRI_1.Level.GetLocalPlayerController();
 }
  if ( LocalPlayer != None )
  {
    if ( Team_HUDBase(LocalPlayer.myHUD) != None )
    {
      Team_HUDBase(LocalPlayer.myHUD).DrawColoredText(C,MessageString);
    }
    if ( (Switch == 1) && (Misc_PRI(RelatedPRI_1) != None) && (LocalPlayer.PlayerReplicationInfo != None) && (LocalPlayer.PlayerReplicationInfo.Team != RelatedPRI_1.Team) )
    {
      DrawCamperIcon(C,LocalPlayer,Misc_PRI(RelatedPRI_1).PawnReplicationInfo.Position);
    }
  }
}

static function DrawCamperIcon (Canvas C, PlayerController LocalPlayer, Vector CamperLoc)
{
  local Vector CamLoc;
 local Rotator CamRot;
local Vector ScreenPos;
  local float Alpha;

  if ( (LocalPlayer == None) || (LocalPlayer.Pawn == None) )
  {
    return;
  }
  if ( LocalPlayer.FastTrace(CamperLoc + vect(0.00,0.00,32.00),LocalPlayer.Pawn.Location + vect(0.00,0.00,32.00)) )
  {
    return;
  }
  C.GetCameraLocation(CamLoc,CamRot);
  ScreenPos = C.WorldToScreen(CamperLoc);
  if ( (CamperLoc - CamLoc) Dot Vector(CamRot) < 0 )
  {
    return;
  }
  if ( (ScreenPos.X <= 0) || (ScreenPos.X >= C.ClipX) )
  {
    return;
  }
  if ( (ScreenPos.Y <= 0) || (ScreenPos.Y >= C.ClipY) )
  {
    return;
  }
  Alpha = C.DrawColor.A;
  C.DrawColor.A = byte(Alpha);
//  DrawCenteredIcon(C,Texture'null',ScreenPos.X,ScreenPos.Y,C.ClipX * 0.031 / 1.25,C.ClipY * 0.0417 / 1.25);
  C.Font = LocalPlayer.myHUD.GetFontSizeIndex(C,-3);
  C.DrawColor = Default.DrawColor;
  C.DrawColor.A = byte(Alpha);
//  DrawCenteredText(C,"[" $ string(int(VSize(LocalPlayer.Pawn.Location - CamperLoc) * 0.01875)) $ "m]",ScreenPos.X,ScreenPos.Y + C.ClipY * 0.031);
}

//static function DrawCenteredIcon (Canvas C, Texture Tex, float X, float Y, float XL, float YL)
//{
//  C.SetPos(X - XL * 0.5,Y - YL * 0.5);
//  C.DrawTile(Tex,XL,YL,0.0,0.0,256.0,256.0);
//}

static function DrawCenteredText (Canvas C, string Text, float X, float Y)
{
  local float XL;
  local float YL;

  C.StrLen(Text,XL,YL);
  C.SetPos(X - XL * 0.5,Y - YL * 0.5);
  C.DrawTextClipped(Text,False);
}

static function string GetString (optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  switch (SwitchNum)
  {
    case 0:
    if ( Misc_PRI(RelatedPRI_1) != None )
    {
      if (  !Misc_PRI(RelatedPRI_1).bWarned )
      {
        return Default.YouAreCampingWarning;
      } else {
      if ( Misc_PRI(RelatedPRI_1).CampCount == 0 )
        {
          return Default.YouAreCampingFirst;
        } else {
      if ( Misc_PRI(RelatedPRI_1).CampCount == 1 )
          {
            return Default.YouAreCampingSecond;
          } else {
      if ( Misc_PRI(RelatedPRI_1).CampCount >= 2 )
            {
              return Default.YouAreCampingThird;
            }else {
      if ( Misc_PRI(RelatedPRI_1).CampCount >= 4 )
          {
            return Default.Playeriscamp;
          }
			}
          }
        }
      }
    }
    return Default.YouAreCampingDefault;
    case 1:
    if ( RelatedPRI_1 == None )
    {
      return "";
    }
    return Default.PlayerIsCampingOpen @ Misc_PRI(RelatedPRI_1).PlayerName @ Default.PlayerIsCamping;
    default:
  }
}

static simulated function ClientReceive (PlayerController P, optional int SwitchNum, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( SwitchNum == 0 )
  {
    P.PlayRewardAnnouncement('Camper',1,True);
  }
  Super.ClientReceive(P,SwitchNum,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}

defaultproperties
{
     YouAreCampingDefault="You Are Camping"
     YouAreCampingWarning="Camper Warning"
     YouAreCampingFirst="...Camping and Taking Damage -10"
     YouAreCampingSecond="SECOND OFFENSE"
     YouAreCampingThird="THIRD OFFENSE"
     PlayerIsCamping="Is Camping"
     Playeriscamp="Forced to Spec cause Camping"
     bComplexString=True
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=5
     DrawColor=(B=206,G=178,R=138)
     PosY=0.075000
     FontSize=-1
}
