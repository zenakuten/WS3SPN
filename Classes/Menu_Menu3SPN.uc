class Menu_Menu3SPN extends UT2k3GUIPage;

#exec TEXTURE IMPORT NAME=Display98 GROUP=GUI FILE=Textures\Display98.dds MIPS=off ALPHA=1 DXT=5

var wsGUITabControl TabC;
var Menu_Settings SettingsTab;
var Menu_TabInfo InfoTab;
var Menu_TabRanks StatsTab;
var UT2k3TabPanel AdminTab;
var Menu_TabTournamentAdmin TournamentAdminTab;

var bool DefaultToInfoTab;
var bool SettingsDirty;
var bool bAdmin;

function bool AllowOpen(string MenuClass)
{
	return false;
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    MyController.RegisterStyle(class'STY_WSButton', true);
    MyController.RegisterStyle(class'STY_WSComboButton', true);
    MyController.RegisterStyle(class'STY_WSLabel', true);
    MyController.RegisterStyle(class'STY_WSLabelWhite', true);
    MyController.RegisterStyle(class'STY_WSListBox', true);
    MyController.RegisterStyle(class'STY_WSSliderBar', true);
    MyController.RegisterStyle(class'STY_WSSliderCaption', true);
    MyController.RegisterStyle(class'STY_WSSliderKnob', true);
    MyController.RegisterStyle(class'STY_WSEditBox', true);
    MyController.RegisterStyle(class'STY_WSSpinner', true);
    MyController.RegisterStyle(class'STY_WSVertDownButton', true);
    MyController.RegisterStyle(class'STY_WSVertUpButton', true);

    Super.InitComponent(MyController, MyOwner);

    bAdmin = PlayerOwner().PlayerReplicationInfo!=None && (PlayerOwner().PlayerReplicationInfo.bAdmin || PlayerOwner().Level.NetMode == NM_Standalone);
	
	GUITitleBar(Controls[1]).Caption = "3SPN "@class'Misc_BaseGRI'.default.Version@"Configuration";	
		
    TabC = wsGUITabControl(Controls[2]);
	InfoTab = Menu_TabInfo(TabC.AddStyledTab("WSButton", "Info", "WS3SPN.Menu_TabInfo",, "General Information", DefaultToInfoTab));
	StatsTab = Menu_TabRanks(TabC.AddStyledTab("WSButton", "Ranks", "WS3SPN.Menu_TabRanks",, "Ranks", false));
	SettingsTab = Menu_Settings(TabC.AddStyledTab("WSButton", "Settings", "WS3SPN.Menu_Settings",, "General Information", DefaultToInfoTab));

	if(InfoTab == None)
		log("Count not open tab Menu_TabInfo", '3SPN');
	if(StatsTab == None)
		log("Count not open tab Menu_TabRanks", '3SPN');
    if(SettingsTab == None)
        log("Could not open tab Menu_Settings", '3SPN');
	if(bAdmin)
	{
		TournamentAdminTab = Menu_TabTournamentAdmin(TabC.AddStyledTab("WSButton", "Tournament", "WS3SPN.Menu_TabTournamentAdmin",, "Tournament", false));
 
		if(PlayerOwner().Level.GRI!=None)
		{
			if(PlayerOwner().Level.GRI.bTeamGame)
				AdminTab = Menu_TabTAMAdmin(TabC.AddStyledTab("WSButton", "Admin", "WS3SPN.Menu_TabTAMAdmin",, "Admin/Server configuration", false));
			else
				AdminTab = Menu_TabAMAdmin(TabC.AddStyledTab("WSButton", "Admin", "WS3SPN.Menu_TabAMAdmin",, "Admin/Server configuration", false));
		}
		
		if(AdminTab == None)
			log("Could not open tab Menu_TabAdmin", '3SPN');
		if(TournamentAdminTab == None)
			log("Could not open the Menu_TabTournamentAdmin", '3SPN');		
	}

    TabC.ActivateTab(TabC.TabStack[2], true);
}

defaultproperties
{
     bRenderWorld=True
     bRequire640x480=False
     bAllowedAsLast=True
     StyleName="WSButton"
     Begin Object Class=GUIImage Name=MenuBack
         Image=Texture'WS3SPN.GUI.Display98'
         ImageColor=(B=10,G=10,R=10,A=64)
         ImageStyle=ISTY_Stretched
         ImageRenderStyle=MSTY_Normal
         WinTop=0.100000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.800000
         RenderWeight=0.000003
     End Object
     Controls(0)=GUIImage'WS3SPN.Menu_Menu3SPN.MenuBack'

     Begin Object Class=GUITitleBar Name=MenuTitle
         Caption="AM/TAM Configuration"
         StyleName="WSButton"
         WinHeight=0.075000
         bBoundToParent=True
         bScaleToParent=True
     End Object
     Controls(1)=GUITitleBar'WS3SPN.Menu_Menu3SPN.MenuTitle'

     Begin Object Class=wsGUITabControl Name=Tabs
         bDockPanels=True
         TabHeight=0.037500
         WinTop=0.060000
         WinLeft=0.015000
         WinWidth=0.970000
         WinHeight=1.000000
         bBoundToParent=True
         bScaleToParent=True
         bAcceptsInput=True
         OnActivate=Tabs.InternalOnActivate
     End Object
     Controls(2)=wsGUITabControl'WS3SPN.Menu_Menu3SPN.Tabs'

     WinTop=0.089000
     WinLeft=0.100000
     WinWidth=0.800000
     WinHeight=0.775000
}
