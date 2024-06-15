class Menu_TabInfo extends UT2k3TabPanel;

#exec TEXTURE IMPORT NAME=Display99 GROUP=GUI FILE=Textures\Display99.dds MIPS=off ALPHA=1 DXT=5

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
    Content = Repl(Content, "[3SPNVersion]", class'Misc_BaseGRI'.default.VersionName$" "$class'Misc_BaseGRI'.default.VersionNumber);
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
         HeaderBase=Texture'WS3SPN.GUI.Display99'
     End Object
     SectionBackg=AltSectionBackground'WS3SPN.Menu_TabInfo.SectionBackgObj'

     Begin Object Class=wsGUIScrollTextBox Name=TextBoxObj
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
     TextBox=wsGUIScrollTextBox'WS3SPN.Menu_TabInfo.TextBoxObj'

     InfoText(0)="Greetings!"
     InfoText(1)="======="
     InfoText(2)="þ"
     InfoText(3)="This is [3SPNVersion], please take a moment to update your settings!"
     InfoText(4)="þ"
     InfoText(5)="You can always access the 3SPN configuration menu later by pressing [Menu3SPNKey] or typing 'menu3spn' in the console."
     InfoText(6)="þ"
     InfoText(7)="Send bug reports and feedback / Suggestions to CaptainSnarf#9567 (snarf) on Discord"
     InfoText(8)="þ"
     InfoText(9)="Special Thanks & CREDITS go to:"
     InfoText(10)="  * Aaron Everitt and Joel Moffatt for UTComp."
     InfoText(11)="  * Michael Massey, Eric Chavez, Mike Hillard, Len Bradley and Steven Phillips for 3SPN."
     InfoText(12)="  * Shaun Goeppinger for Necro."
     InfoText(13)="  * Klunxis for keeping SoL alive."
     InfoText(14)="  * The SoL community for all the improvement ideas"
     InfoText(15)="  * Pooty for help and additions to UTCompOmni."
     InfoText(16)="  * Anonymous for general help with UT, PC gaming and optimization."
     InfoText(17)="  * Kokuei for for his awesome work on the core game engine."
     InfoText(18)="  * Patience, l8erade, Vapor and everyone at UFC for keeping the competitive scene alive."
     InfoText(19)="  * void at www.combowhore.com for many many enhancements to 3SPN."
     InfoText(20)="  * Beltamaxx for his great ideas, inspiration and encouragement."
     InfoText(21)="  * SoL�Lizard for 3SPN changes and support."
     InfoText(22)="  * Attila, Horst & InhumanAimz for their work on 3SPN "
     InfoText(23)="  * Hv, Viking, f00l, Mythic, Nolja for their help with 3SPN RU "
     InfoText(24)="  * The RU Community for their testing, patience, and feedback."
     InfoText(25)="All without whom this mutator and its adjustments would not be possible!"
}
