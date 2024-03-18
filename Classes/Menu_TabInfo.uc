class Menu_TabInfo extends UT2k3TabPanel;

var automated GUISectionBackground SectionBackg;
var automated GUIScrollTextBox TextBox;

var array<string> InfoText;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local Misc_Player MP;
    local TAM_GRI GRI;
    local string Content;

    Super.InitComponent(MyController, MyOwner);

    MP = Misc_Player(PlayerOwner());
    if(MP == None)
        return;
        
    GRI = TAM_GRI(PlayerOwner().Level.GRI);
        
    SectionBackg.ManageComponent(TextBox);
    TextBox.MyScrollText.bNeverFocus=True;
    
    Content = JoinArray(InfoText, TextBox.Separator, True);
    Content = Repl(Content, "[3SPNVersion]", class'Misc_BaseGRI'.default.Version);
    Content = Repl(Content, "[Menu3SPNKey]", class'Interactions'.static.GetFriendlyName(class'Misc_Player'.default.Menu3SPNKey));
    TextBox.SetContent(Content, TextBox.Separator);
}

defaultproperties
{
     Begin Object Class=AltSectionBackground Name=SectionBackgObj
         bFillClient=True
         LeftPadding=0.000000
         RightPadding=0.000000
         WinHeight=1.000000
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         OnPreDraw=SectionBackgObj.InternalPreDraw
     End Object
     SectionBackg=AltSectionBackground'WS3SPN.Menu_TabInfo.SectionBackgObj'

     Begin Object Class=GUIScrollTextBox Name=TextBoxObj
         bNoTeletype=True
         Separator="þ"
         OnCreateComponent=TextBoxObj.InternalOnCreateComponent
         FontScale=FNS_Small
         WinTop=0.010000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.558333
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
     End Object
     TextBox=GUIScrollTextBox'WS3SPN.Menu_TabInfo.TextBoxObj'

     InfoText(0)="Greetings!"
     InfoText(1)="======="
     InfoText(2)="þ"
     InfoText(3)="This seems to be the first time you are running [3SPNVersion], please take a moment to update your settings!"
     InfoText(4)="þ"
     InfoText(5)="NOTE: Your settings have been automatically retrieved from the server if they have been previously saved. Your future settings will be saved on this server automatically and restored on 3SPN updates or UT reinstalls. This behavior can be disabled in the Misc panel. The settings are saved for your PLAYERNAME, so if you change it, you must save the settings again for them to be found later."
     InfoText(6)="þ"
     InfoText(7)="You can always access the 3SPN configuration menu later by pressing [Menu3SPNKey] or typing 'menu3spn' in the console."
     InfoText(8)="þ"
     InfoText(61)="Send bug reports and feedback / Suggestions to CaptainSnarf#9567 (snarf) on Discord"
     InfoText(69)="þ"
     InfoText(70)="Special Thanks & CREDITS go to:"
     InfoText(71)="  * Aaron Everitt and Joel Moffatt for UTComp."
     InfoText(72)="  * Michael Massey, Eric Chavez, Mike Hillard, Len Bradley and Steven Phillips for 3SPN."
     InfoText(73)="  * Shaun Goeppinger for Necro."
     InfoText(74)="  * void at www.combowhore.com for many many enhancements to 3SPN."
     InfoText(75)="  * Beltamaxx for his great ideas, inspiration and encouragement."
     InfoText(76)="  * SoL�Lizard for 3SPN changes and support."
     InfoText(77)="  * Attila, Horst & InhumanAimz for their work on 3SPN "
     InfoText(78)="  * Hv, Viking, f00l, Mythic, Nolja for their help with 3SPN RU "
     InfoText(79)="  * The RU Community for their testing, patience, and feedback."
     InfoText(80)="All without whom this mutator and its adjustments would not be possible!"
}
