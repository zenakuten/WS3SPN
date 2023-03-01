//================================================================================
// Message_Grave.
//================================================================================

class Message_Grave extends LocalMessage;

var const Material IconTex;
var const Material IconFade;
var(Message) string GetReadyText;
var(Message) string GetReadyText2;
var(Message) int FontSize2;
var(Message) float IconPosX;
var(Message) float IconPosY;
var(Message) float IconSize;
var(Message) float BoardIconPosX;
var(Message) float BoardIconPosY;
var(Message) float BoardIconSize;

static function Color GetFadeCurrentColor (float Time)
{
  local Color FColor;
  local float FP;

  if ( FadeColor(Default.IconFade) == None )
  {
    return Default.DrawColor;
  }
  FP = FadeColor(Default.IconFade).FadePeriod;
  if ( FP <= 0 )
  {
    return Default.DrawColor;
  }
  Time = (Time - int(Time * 0.5 / FP) * FP * 2) / FP;
  if ( Time > 1 )
  {
    Time = 2.0 - Time;
  }
  FColor = FadeColor(Default.IconFade).Color1 * (1 - Time) + FadeColor(Default.IconFade).Color2 * Time;
  FColor.A = 255;
  return FColor;
}

static function RenderComplexMessage (Canvas C, out float XL, out float YL, optional string MessageString, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  local float Size;
  local float Text1H;

  if ( (RelatedPRI_1 == None) || (PlayerController(RelatedPRI_1.Owner) == None) )
  {
    return;
  }
  if ( Switch == 0 )
  {
    C.DrawColor = Class'HUD'.Default.WhiteColor;
    Size = Default.IconSize * C.ClipY * 0.01;
    C.SetPos(C.ClipX * Default.IconPosX,(C.ClipY - Size) * Default.IconPosY);
    
    C.DrawColor = GetFadeCurrentColor(RelatedPRI_1.Level.TimeSeconds);
    if ( Default.GetReadyText != "" )
    {
      C.Font = PlayerController(RelatedPRI_1.Owner).myHUD.GetFontSizeIndex(C,Default.FontSize);
      C.TextSize(Default.GetReadyText,XL,YL);
      C.SetPos(C.ClipX * Default.IconPosX,(C.ClipY - Size) * Default.IconPosY + Size * -0.09);
      C.DrawTextClipped(Default.GetReadyText);
      Text1H = YL;
    }
    if ( Default.GetReadyText2 != "" )
    {
      C.Font = PlayerController(RelatedPRI_1.Owner).myHUD.GetFontSizeIndex(C,Default.FontSize2);
      C.TextSize(Default.GetReadyText2,XL,YL);
      C.SetPos(C.ClipX * Default.IconPosX,(C.ClipY - Size) * Default.IconPosY + Size + Text1H * 0.1);
      C.DrawTextClipped(Default.GetReadyText2);
    }
  }
  if ( Switch == 1 )
  {
    C.DrawColor = Class'HUD'.Default.WhiteColor;
    Size = Default.BoardIconSize * C.ClipY * 0.01;
    C.SetPos((C.ClipX - Size) * Default.BoardIconPosX,(C.ClipY - Size) * Default.BoardIconPosY);
   
  }
}

defaultproperties
{
     GetReadyText="Prepare"
     GetReadyText2="You're next to res"
     FontSize2=-1
     IconPosX=0.010000
     IconPosY=0.570000
     IconSize=10.000000
     BoardIconPosX=0.500000
     BoardIconPosY=0.740000
     BoardIconSize=10.000000
     bComplexString=True
     bIsUnique=True
     bIsConsoleMessage=False
     Lifetime=999
}
