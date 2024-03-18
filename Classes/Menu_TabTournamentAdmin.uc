class Menu_TabTournamentAdmin extends UT2k3TabPanel;

var bool bAdmin;

function bool AllowOpen(string MenuClass)
{
	if(PlayerOwner()==None || PlayerOwner().PlayerReplicationInfo==None)
		return false;
	return true;
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
	local GameReplicationInfo GRI;

    Super.InitComponent(MyController, MyOwner);
	
	if(Controls.Length==0)
		return;

	GRI = PlayerOwner().Level.GRI;
	if(GRI!=None)
	{
		if(GRI.Teams[0]!=None)
			moEditBox(Controls[3]).SetText(string(GRI.Teams[0].Score));
		if(GRI.Teams[1]!=None)
			moEditBox(Controls[5]).SetText(string(GRI.Teams[1].Score));
	}
	
    moCheckBox(Controls[6]).Checked(class'Misc_Player'.default.bAdminVisionInSpec);
    moCheckBox(Controls[7]).Checked(class'Misc_Player'.default.bDrawTargetingLineInSpec);
    moCheckBox(Controls[8]).Checked(class'Misc_Player'.default.bReportNewNetStats);
  
    bAdmin = PlayerOwner().PlayerReplicationInfo!=None && (PlayerOwner().PlayerReplicationInfo.bAdmin || PlayerOwner().Level.NetMode == NM_Standalone);
    if(!bAdmin)
        for(i = 1; i < Controls.Length; i++)
            Controls[i].DisableMe();

    SetTimer(1.0, true);
}

function OnChange(GUIComponent C)
{
    local Misc_Player MP;
    local bool b;

    if(moCheckBox(c) != None)
    {
        b = moCheckBox(c).IsChecked();
        if(c == Controls[6])
            class'Misc_Player'.default.bAdminVisionInSpec = b;
        if(c == Controls[7])
            class'Misc_Player'.default.bDrawTargetingLineInSpec = b;
        if(c == Controls[8])
        {
            class'Misc_Player'.default.bReportNewNetStats = b;
            
            MP = Misc_Player(PlayerOwner());
            if(MP != None)
            {
              MP.ServerReportNewNetStats(b);
            }
        }
    }
       
    class'Misc_Player'.static.StaticSaveConfig();    
}

function bool OnClick(GUIComponent C)
{
    local Misc_Player MP;

    if(!bAdmin)
        return false;

    MP = Misc_Player(PlayerOwner());
    if(MP == None)
        return false;
		
	if(C==Controls[1])
	{
		MP.SetTeamScore(int(GUIEditBox(Controls[3]).TextStr), int(GUIEditBox(Controls[5]).TextStr));
	}
	
    return true;
}

function Timer()
{
    local bool bNewAdmin;
    local int i;

    bAdmin = true;

    bNewAdmin = (PlayerOwner().PlayerReplicationInfo.bAdmin || PlayerOwner().Level.NetMode == NM_Standalone);
    if(bNewAdmin == bAdmin)
        return;

    bAdmin = bNewAdmin;

    if(!bAdmin)
        for(i = 1; i < Controls.Length; i++)
            Controls[i].DisableMe();
    else
        for(i = 1; i < Controls.Length; i++)
            Controls[i].EnableMe();
}

defaultproperties
{
     Begin Object Class=GUIImage Name=TabBackground
         Image=Texture'InterfaceContent.Menu.ScoreBoxA'
         ImageColor=(B=0,G=0,R=0)
         ImageStyle=ISTY_Stretched
         WinHeight=1.000000
         bNeverFocus=True
     End Object
     Controls(0)=GUIImage'WS3SPN.Menu_TabTournamentAdmin.TabBackground'

     Begin Object Class=GUIButton Name=ApplyButton
         Caption="Apply Score"
         StyleName="SquareMenuButton"
         WinTop=0.100000
         WinLeft=0.490000
         WinWidth=0.400000
         WinHeight=0.100000
         OnClick=Menu_TabTournamentAdmin.OnClick
         OnKeyEvent=ApplyButton.InternalOnKeyEvent
     End Object
     Controls(1)=GUIButton'WS3SPN.Menu_TabTournamentAdmin.ApplyButton'

     Begin Object Class=GUILabel Name=RedScoreLabel
         Caption="Red Score:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.100000
         WinLeft=0.100000
         WinWidth=0.250000
         WinHeight=0.037500
     End Object
     Controls(2)=GUILabel'WS3SPN.Menu_TabTournamentAdmin.RedScoreLabel'

     Begin Object Class=GUIEditBox Name=RedScoreEditBox
         WinTop=0.100000
         WinLeft=0.250000
         WinWidth=0.100000
         WinHeight=0.037500
         OnActivate=RedScoreEditBox.InternalActivate
         OnDeActivate=RedScoreEditBox.InternalDeactivate
         OnKeyType=RedScoreEditBox.InternalOnKeyType
         OnKeyEvent=RedScoreEditBox.InternalOnKeyEvent
     End Object
     Controls(3)=GUIEditBox'WS3SPN.Menu_TabTournamentAdmin.RedScoreEditBox'

     Begin Object Class=GUILabel Name=BlueScoreLabel
         Caption="Blue Score:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.160000
         WinLeft=0.100000
         WinWidth=0.250000
         WinHeight=0.037500
     End Object
     Controls(4)=GUILabel'WS3SPN.Menu_TabTournamentAdmin.BlueScoreLabel'

     Begin Object Class=GUIEditBox Name=BlueScoreEditBox
         WinTop=0.160000
         WinLeft=0.250000
         WinWidth=0.100000
         WinHeight=0.037500
         OnActivate=BlueScoreEditBox.InternalActivate
         OnDeActivate=BlueScoreEditBox.InternalDeactivate
         OnKeyType=BlueScoreEditBox.InternalOnKeyType
         OnKeyEvent=BlueScoreEditBox.InternalOnKeyEvent
     End Object
     Controls(5)=GUIEditBox'WS3SPN.Menu_TabTournamentAdmin.BlueScoreEditBox'

     Begin Object Class=moCheckBox Name=AdminVisionCheck
         Caption="Enable Wall Hack When Spectating."
         OnCreateComponent=AdminVisionCheck.InternalOnCreateComponent
         WinTop=0.280000
         WinLeft=0.100000
         WinWidth=0.700000
         WinHeight=0.037500
         OnChange=Menu_TabTournamentAdmin.OnChange
     End Object
     Controls(6)=moCheckBox'WS3SPN.Menu_TabTournamentAdmin.AdminVisionCheck'

     Begin Object Class=moCheckBox Name=TargetingLineCheck
         Caption="Enable Targeting Tracking When Spectating."
         OnCreateComponent=TargetingLineCheck.InternalOnCreateComponent
         WinTop=0.340000
         WinLeft=0.100000
         WinWidth=0.700000
         WinHeight=0.037500
         OnChange=Menu_TabTournamentAdmin.OnChange
     End Object
     Controls(7)=moCheckBox'WS3SPN.Menu_TabTournamentAdmin.TargetingLineCheck'

     Begin Object Class=moCheckBox Name=NewNetStatsCheck
         Caption="Enable NewNet Stats Reporting (Debug)."
         OnCreateComponent=NewNetStatsCheck.InternalOnCreateComponent
         WinTop=0.400000
         WinLeft=0.100000
         WinWidth=0.700000
         WinHeight=0.037500
         OnChange=Menu_TabTournamentAdmin.OnChange
     End Object
     Controls(8)=moCheckBox'WS3SPN.Menu_TabTournamentAdmin.NewNetStatsCheck'

}
