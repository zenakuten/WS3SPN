class Menu_TabWeapons extends UT2k3TabPanel;
var automated moCheckBox ch_UseNewEyeHeight;
var automated moCheckBox ch_TeamColorRockets;
var automated moCheckBox ch_TeamColorBio;
var automated moCheckBox ch_TeamColorFlak;
var automated moCheckBox ch_TeamColorShock;
var automated GUIImage weaponCheckBox, redBox, blueBox;
var automated GUILabel RRL, RBL, RGL, BRL, BGL, BBL, redBoxLabel, blueBoxLabel;
var automated GUISlider RRSlide, RBSlide, RGSlide, BRSlide, BGSlide, BBSlide;
var automated moCheckBox ch_TeamColorEnemyAlly;
var TeamColorSpinnyRocket redRox,blueRox;
var vector      RedRoxOffset;
var vector      BlueRoxOffset;
//var automated moCheckBox ch_TeamColorSniper;

function bool AllowOpen(string MenuClass)
{
	if(PlayerOwner()==None || PlayerOwner().PlayerReplicationInfo==None)
		return false;
	return true;
}

event Opened(GUIComponent Sender)
{
	local bool OldDirty;
	OldDirty = class'Menu_Menu3SPN'.default.SettingsDirty;
	super.Opened(Sender);
	class'Menu_Menu3SPN'.default.SettingsDirty = OldDirty;	
}

event Closed(GUIComponent Sender, bool bCancelled)
{
    HideSpinnyRox(true);
    if(redRox!=None)
    {
        redRox.bHidden=true;
    }
    if(blueRox!=None)
    {
        blueRox.bHidden=true;
    }
    super.Closed(Sender, bCancelled);
}

function Free()
{
    super.Free();
    if(redRox!=None)
    {
        redRox.Destroy();
        redRox=None;
    }
    if(blueRox!=None)
    {
        blueRox.Destroy();
        blueRox=None;
    }

}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local Misc_Player P;
	local bool OldDirty;

	Super.InitComponent(myController,MyOwner);	 
	 
    P = Misc_Player(PlayerOwner());
    if(P == None)
        return;
		

	OldDirty = class'Menu_Menu3SPN'.default.SettingsDirty;

    ch_UseNewEyeHeight.Checked(class'Misc_Player'.default.bUseNewEyeHeightAlgorithm);
    ch_TeamColorRockets.Checked(class'Misc_Player'.default.bTeamColorRockets);
    ch_TeamColorBio.Checked(class'Misc_Player'.default.bTeamColorBio);
    ch_TeamColorFlak.Checked(class'Misc_Player'.default.bTeamColorFlak);
    ch_TeamColorShock.Checked(class'Misc_Player'.default.bTeamColorShock);
    ch_TeamColorEnemyAlly.Checked(!class'Misc_Player'.default.bTeamColorUseTeam);
    UpdateColorTextTeam();    

    if(redRox == None)
    {
        redRox = P.Spawn(class'TeamColorSpinnyRocket');
        redRox.SetTeam(0);
        UpdateRedRoxColors();
    }

    if(blueRox == None)
    {
        blueRox = P.Spawn(class'TeamColorSpinnyRocket');
        blueRox.SetTeam(1);
        UpdateBlueRoxColors();
    }

    MatchSlidersToColors();

    class'Menu_Menu3SPN'.default.SettingsDirty = OldDirty;
}

function MatchSlidersToColors()
{
    local Color red;
    local Color blue;
    local int myTeam;

    myTeam = PlayerOwner().GetTeamNum();
    red = class'TeamColorManager'.static.GetColor(0,PlayerOwner());
    blue = class'TeamColorManager'.static.GetColor(1,PlayerOwner());
    if(IsEnemyAlly())
    {
        red = class'TeamColorManager'.static.GetColor(1-myTeam,PlayerOwner());
        blue = class'TeamColorManager'.static.GetColor(myTeam,PlayerOwner());
    }

    RRSlide.Value = red.R;
    RGSlide.Value = red.G;
    RBSlide.Value = red.B;

    BRSlide.Value = blue.R;
    BGSlide.Value = blue.G;
    BBSlide.Value = blue.B;
}

function InternalOnChange( GUIComponent C )
{
    Switch(C)
    {	
        case ch_UseNewEyeHeight:
            class'Misc_Player'.default.bUseNewEyeHeightAlgorithm = ch_UseNewEyeHeight.IsChecked();
            Misc_Player(PlayerOwner()).SetEyeHeightAlgorithm(ch_UseNewEyeHeight.IsChecked());
        break;

        case ch_TeamColorEnemyAlly:
            class'Misc_Player'.default.bTeamColorUseTeam = !ch_TeamColorEnemyAlly.IsChecked();
            UpdateColors();
            MatchSlidersToColors();
        break;

        case ch_TeamColorRockets:
            class'Misc_Player'.default.bTeamColorRockets = ch_TeamColorRockets.IsChecked();
        break;
        
        case ch_TeamColorBio:
            class'Misc_Player'.default.bTeamColorBio = ch_TeamColorBio.IsChecked();
        break;

        case ch_TeamColorFlak:
            class'Misc_Player'.default.bTeamColorFlak = ch_TeamColorFlak.IsChecked();
        break;

        case ch_TeamColorShock:
            class'Misc_Player'.default.bTeamColorShock = ch_TeamColorShock.IsChecked();
        break;

        case RRSlide:
            class'Misc_Player'.default.TeamColorRed.R = RRSlide.Value;
            UpdateColors();
        break;

        case RGSlide:
            class'Misc_Player'.default.TeamColorRed.G = RGSlide.Value;
            UpdateColors();
        break;

        case RBSlide:
            class'Misc_Player'.default.TeamColorRed.B = RBSlide.Value;
            UpdateColors();
        break;
        
        case BRSlide:
            class'Misc_Player'.default.TeamColorBlue.R = BRSlide.Value;
            UpdateColors();
        break;

        case BGSlide:
            class'Misc_Player'.default.TeamColorBlue.G = BGSlide.Value;
            UpdateColors();
        break;

        case BBSlide:
            class'Misc_Player'.default.TeamColorBlue.B = BBSlide.Value;
            UpdateColors();
        break;

    }
	
    Misc_Player(PlayerOwner()).ReloadDefaults();
    class'Misc_Player'.Static.StaticSaveConfig();	
    class'Menu_Menu3SPN'.default.SettingsDirty = true;
}

function bool IsEnemyAlly()
{
    return !class'Misc_Player'.default.bTeamColorUseTeam;
}

function UpdateRedRoxColors()
{
    local int myTeam;
    myTeam = PlayerOwner().GetTeamNum();
    if(redRox != None && redRox.RocketTrail != None)
    {
        if(IsEnemyAlly())
        {
            redRox.SetTeam(1-myTeam);
        }
        else
        {
            redRox.SetTeam(0);
        }

        redRox.RocketTrail.bColorSet=false;
    }
}

function UpdateBlueRoxColors()
{
    local int myTeam;
    myTeam = PlayerOwner().GetTeamNum();
    if(blueRox != None && blueRox.RocketTrail != None)
    {
        if(IsEnemyAlly())
        {
            blueRox.SetTeam(myTeam);
        }
        else
        {
            blueRox.SetTeam(1);
        }
        blueRox.RocketTrail.bColorSet=false;
    }
}

function bool InternalDraw(Canvas C)
{
	local vector CamPos, X, Y, Z;
	local rotator CamRot;

	C.GetCameraLocation(CamPos, CamRot);
	GetAxes(CamRot, X, Y, Z);

    if(redRox != None)
    {
	    redRox.SetLocation(CamPos + (RedRoxOffset.X * X) + (RedRoxOffset.Y * Y) + (RedRoxOffset.Z * Z));
	    C.DrawActor(redRox.RocketTrail, false, true, 90.0);
	    C.DrawActor(redRox.Corona, false, true, 90.0);
	    C.DrawActor(redRox, false, true, 90.0);
    }

    if(blueRox != None)
    {
	    blueRox.SetLocation(CamPos + (BlueRoxOffset.X * X) + (BlueRoxOffset.Y * Y) + (BlueRoxOffset.Z * Z));
	    C.DrawActor(blueRox.RocketTrail, false, true, 90.0);
	    C.DrawActor(blueRox.Corona, false, true, 90.0);
	    C.DrawActor(blueRox, false, true, 90.0);
    }

	return false;
}

function HideSpinnyRox(bool bHide)
{
    if(RedRox != None)
    {
        RedRox.bHidden=bHide;
        RedRox.Corona.bHidden=bHide;
        RedRox.RocketTrail.bHidden=bHide;
    }
    if(BlueRox != None)
    {
        BlueRox.bHidden=bHide;
        BlueRox.Corona.bHidden=bHide;
        BlueRox.RocketTrail.bHidden=bHide;
    }
}

function ShowPanel(bool bShow)
{
    Super.ShowPanel(bShow);
    HideSpinnyRox(!bShow);
}

function UpdateColorTextTeam()
{
    local int myTeam;
    myTeam=PlayerOwner().GetTeamNum();
    if(IsEnemyAlly())
    {
        redBoxLabel.TextColor = class'TeamColorManager'.static.GetColor(1-myTeam,PlayerOwner());
        blueBoxLabel.TextColor = class'TeamColorManager'.static.GetColor(myTeam,PlayerOwner());
    }
    else
    {
        redBoxLabel.TextColor = class'TeamColorManager'.static.GetColor(0,PlayerOwner());
        blueBoxLabel.TextColor = class'TeamColorManager'.static.GetColor(1,PlayerOwner());
    }
}

function UpdateColors()
{
    UpdateColorTextTeam();
    UpdateRedRoxColors();
    UpdateBlueRoxColors();
}

defaultproperties
{
    Begin Object Class=moCheckBox Name=UseNewEyeHeight
         Caption="New Eye Height Algorithm"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Use the new height height algorithm"
         WinTop=0.190000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabWeapons.InternalOnChange
     End Object
     ch_UseNewEyeHeight=moCheckBox'3SPNvSoL.Menu_TabWeapons.UseNewEyeHeight'

    Begin Object Class=GUIImage Name=TabWeaponBackground
         Image=Texture'InterfaceContent.Menu.ScoreBoxA'
         ImageColor=(A=100)
         ImageStyle=ISTY_Stretched
         WinTop=0.300000
         WinLeft=0.075000
         WinWidth=0.850000
         WinHeight=0.220000
         RenderWeight=1.000000
         bNeverFocus=True
    End Object
    weaponCheckBox=GUIImage'3SPNvSoL.Menu_TabWeapons.TabWeaponBackground'

    Begin Object Class=moCheckBox Name=CheckTeamColorRockets
         Caption="Team colored rockets"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Add team coloring to rockets"
         WinTop=0.310000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabWeapons.InternalOnChange
     End Object
     ch_TeamColorRockets=moCheckBox'3SPNvSoL.Menu_TabWeapons.CheckTeamColorRockets'

    Begin Object Class=moCheckBox Name=CheckTeamColorBio
         Caption="Team colored bio"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Add team coloring to bio globs"
         WinTop=0.360000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabWeapons.InternalOnChange
     End Object
     ch_TeamColorBio=moCheckBox'3SPNvSoL.Menu_TabWeapons.CheckTeamColorBio'

    Begin Object Class=moCheckBox Name=CheckTeamColorFlak
         Caption="Team colored flak"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Add team coloring to flak"
         WinTop=0.410000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabWeapons.InternalOnChange
     End Object
     ch_TeamColorFlak=moCheckBox'3SPNvSoL.Menu_TabWeapons.CheckTeamColorFlak'

    Begin Object Class=moCheckBox Name=CheckTeamColorShock
         Caption="Team colored shock"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Add team coloring to shock"
         WinTop=0.460000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabWeapons.InternalOnChange
     End Object
     ch_TeamColorShock=moCheckBox'3SPNvSoL.Menu_TabWeapons.CheckTeamColorShock'

    Begin Object Class=moCheckBox Name=CheckTeamColorEnemyAlly
         Caption="Use enemy/ally colors"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Use enemy/ally logic instead of red/blue"
         //WinTop=0.760000
         WinTop=0.830000
         //WinLeft=0.550000
         WinLeft=0.100000
         WinWidth=0.350000
         OnChange=Menu_TabWeapons.InternalOnChange
    End Object
    ch_TeamColorEnemyAlly=moCheckBox'3SPNvSoL.Menu_TabWeapons.CheckTeamColorEnemyAlly'

    Begin Object Class=GUIImage Name=TabRedColorBackground
         Image=Texture'InterfaceContent.Menu.ScoreBoxA'
         ImageColor=(A=100)
         ImageStyle=ISTY_Stretched
         WinTop=0.550000
         WinLeft=0.075000
         WinWidth=0.42500
         WinHeight=0.270000
         RenderWeight=1.000000
         bNeverFocus=True
    End Object
    redBox=GUIImage'3SPNvSoL.Menu_TabWeapons.TabRedColorBackground'

    Begin Object Class=GUIImage Name=TabBlueColorBackground
         Image=Texture'InterfaceContent.Menu.ScoreBoxA'
         ImageColor=(A=100)
         ImageStyle=ISTY_Stretched
         WinTop=0.550000
         WinLeft=0.50000
         WinWidth=0.42500
         WinHeight=0.270000
         RenderWeight=1.000000
         bNeverFocus=True
    End Object
    blueBox=GUIImage'3SPNvSoL.Menu_TabWeapons.TabBlueColorBackground'

    Begin Object Class=GUILabel Name=RedBoxLbl
         Caption="Red or Enemy"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.580000
         WinLeft=0.230000
         WinHeight=20.000000
     End Object
     redboxLabel=GUILabel'3SPNvSoL.Menu_TabWeapons.RedBoxLbl'

    Begin Object Class=GUILabel Name=BlueBoxLbl
         Caption="Blue or Ally"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.580000
         WinLeft=0.680000
         WinHeight=20.000000
     End Object
     blueboxLabel=GUILabel'3SPNvSoL.Menu_TabWeapons.BlueBoxLbl'


    // ------------------

     Begin Object Class=GUISlider Name=RedRSlider
         bIntSlider=True
         WinTop=0.6250000
         WinLeft=0.120000
         WinWidth=0.260000
         OnClick=RedRSlider.InternalOnClick
         OnMousePressed=RedRSlider.InternalOnMousePressed
         OnMouseRelease=RedRSlider.InternalOnMouseRelease
         OnChange=Menu_TabWeapons.InternalOnChange
         OnKeyEvent=RedRSlider.InternalOnKeyEvent
         OnCapturedMouseMove=RedRSlider.InternalCapturedMouseMove
         MaxValue=255
     End Object
     RRSlide=GUISlider'3SPNvSoL.Menu_TabWeapons.RedRSlider'

     Begin Object Class=GUISlider Name=RedGSlider
         bIntSlider=True
         WinTop=0.6750000
         WinLeft=0.120000
         WinWidth=0.260000
         OnClick=RedGSlider.InternalOnClick
         OnMousePressed=RedGSlider.InternalOnMousePressed
         OnMouseRelease=RedGSlider.InternalOnMouseRelease
         OnChange=Menu_TabWeapons.InternalOnChange
         OnKeyEvent=RedGSlider.InternalOnKeyEvent
         OnCapturedMouseMove=RedGSlider.InternalCapturedMouseMove
         MaxValue=255
     End Object
     RGSlide=GUISlider'3SPNvSoL.Menu_TabWeapons.RedGSlider'

     Begin Object Class=GUISlider Name=RedBSlider
         bIntSlider=True
         WinTop=0.7250000
         WinLeft=0.120000
         WinWidth=0.260000
         OnClick=RedBSlider.InternalOnClick
         OnMousePressed=RedBSlider.InternalOnMousePressed
         OnMouseRelease=RedBSlider.InternalOnMouseRelease
         OnChange=Menu_TabWeapons.InternalOnChange
         OnKeyEvent=RedBSlider.InternalOnKeyEvent
         OnCapturedMouseMove=RedBSlider.InternalCapturedMouseMove
         MaxValue=255
     End Object
     RBSlide=GUISlider'3SPNvSoL.Menu_TabWeapons.RedBSlider'

     Begin Object Class=GUISlider Name=BlueRSlider
         bIntSlider=True
         WinTop=0.6250000
         WinLeft=0.5500000
         WinWidth=0.260000
         OnClick=BlueRSlider.InternalOnClick
         OnMousePressed=BlueRSlider.InternalOnMousePressed
         OnMouseRelease=BlueRSlider.InternalOnMouseRelease
         OnChange=Menu_TabWeapons.InternalOnChange
         OnKeyEvent=BlueRSlider.InternalOnKeyEvent
         OnCapturedMouseMove=BlueRSlider.InternalCapturedMouseMove
         MaxValue=255
     End Object
     BRSlide=GUISlider'3SPNvSoL.Menu_TabWeapons.BlueRSlider'

     Begin Object Class=GUISlider Name=BlueGSlider
         bIntSlider=True
         WinTop=0.6750000
         WinLeft=0.5500000
         WinWidth=0.260000
         OnClick=BlueGSlider.InternalOnClick
         OnMousePressed=BlueGSlider.InternalOnMousePressed
         OnMouseRelease=BlueGSlider.InternalOnMouseRelease
         OnChange=Menu_TabWeapons.InternalOnChange
         OnKeyEvent=BlueGSlider.InternalOnKeyEvent
         OnCapturedMouseMove=BlueGSlider.InternalCapturedMouseMove
         MaxValue=255
     End Object
     BGSlide=GUISlider'3SPNvSoL.Menu_TabWeapons.BlueGSlider'

     Begin Object Class=GUISlider Name=BlueBSlider
         bIntSlider=True
         WinTop=0.7250000
         WinLeft=0.550000
         WinWidth=0.260000
         OnClick=BlueBSlider.InternalOnClick
         OnMousePressed=BlueBSlider.InternalOnMousePressed
         OnMouseRelease=BlueBSlider.InternalOnMouseRelease
         OnChange=Menu_TabWeapons.InternalOnChange
         OnKeyEvent=BlueBSlider.InternalOnKeyEvent
         OnCapturedMouseMove=BlueBSlider.InternalCapturedMouseMove
         MaxValue=255
     End Object
     BBSlide=GUISlider'3SPNvSoL.Menu_TabWeapons.BlueBSlider'

     Begin Object Class=GUILabel Name=RedRLabel
         Caption="R:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.6250000
         WinLeft=0.100000
         WinHeight=20.000000
     End Object
     RRL=GUILabel'3SPNvSoL.Menu_TabWeapons.RedRLabel'

     Begin Object Class=GUILabel Name=RedGLabel
         Caption="G:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.6750000
         WinLeft=0.100000
         WinHeight=20.000000
     End Object
     RGL=GUILabel'3SPNvSoL.Menu_TabWeapons.RedGLabel'

     Begin Object Class=GUILabel Name=RedBLabel
         Caption="B:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.725000
         WinLeft=0.100000
         WinHeight=20.000000
     End Object
     RBL=GUILabel'3SPNvSoL.Menu_TabWeapons.RedBLabel'

     Begin Object Class=GUILabel Name=BlueRLabel
         Caption="R:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.6250000
         WinLeft=0.53000
         WinHeight=20.000000
     End Object
     BRL=GUILabel'3SPNvSoL.Menu_TabWeapons.BlueRLabel'

     Begin Object Class=GUILabel Name=BlueGLabel
         Caption="G:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.6750000
         WinLeft=0.53000
         WinHeight=20.000000
     End Object
     BGL=GUILabel'3SPNvSoL.Menu_TabWeapons.BlueGLabel'

     Begin Object Class=GUILabel Name=BlueBLabel
         Caption="B:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.725000
         WinLeft=0.53000
         WinHeight=20.000000
     End Object
     BBL=GUILabel'3SPNvSoL.Menu_TabWeapons.BlueBLabel'

     RedRoxOffset=(X=300.000000,Y=-25.000000,Z=-50.000000)
     BlueRoxOffset=(X=300.000000,Y=175.000000,Z=-50.000000)

    OnDraw=Menu_TabWeapons.InternalDraw
}
