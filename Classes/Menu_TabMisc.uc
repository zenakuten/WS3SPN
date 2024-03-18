class Menu_TabMisc extends UT2k3TabPanel;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local Misc_Player MP;
    local TAM_GRI GRI;

    Super.InitComponent(MyController, MyOwner);

    MP = Misc_Player(PlayerOwner());
    if(MP == None)
        return;

    GRI = TAM_GRI(PlayerOwner().Level.GRI);
    
    moCheckBox(Controls[5]).Checked(class'Misc_Player'.default.bMatchHUDToSkins);
    moCheckBox(Controls[6]).Checked(!class'Misc_Player'.default.bShowTeamInfo);
    moCheckBox(Controls[7]).Checked(!class'Misc_Player'.default.bShowCombos);    
    moCheckBox(Controls[14]).Checked(class'Misc_Player'.default.bExtendedInfo);

    moCheckBox(Controls[16]).Checked(!class'Misc_Pawn'.default.bPlayOwnFootsteps);
    moCheckBox(Controls[17]).Checked(class'Misc_Player'.default.bAutoScreenShot);

    GUISlider(Controls[18]).Value = class'Misc_Player'.default.SoundAloneVolume;
	
	moCheckBox(Controls[22]).Checked(class'Misc_Player'.default.bDisableEndCeremonySound);
	
	if(GRI != None)
	{
        if(GRI.TimeOuts == 0 && !PlayerOwner().PlayerReplicationInfo.bAdmin)
             GUIButton(Controls[20]).DisableMe();
	}
	else
	{
        GUIButton(Controls[20]).DisableMe();
	}
}

function OnChange(GUIComponent C)
{
    local bool b;
	
    if(moCheckBox(c) != None)
    {
        b = moCheckBox(c).IsChecked();
        if(c == Controls[5])
            class'Misc_Player'.default.bMatchHUDToSkins = b;
        else if(c == Controls[6])
            class'Misc_Player'.default.bShowTeamInfo = !b;
        else if(c == Controls[7])
            class'Misc_Player'.default.bShowCombos = !b;
        else if(c == Controls[14])
            class'Misc_Player'.default.bExtendedInfo = b;
        else if(c == Controls[17])
            class'Misc_Player'.default.bAutoScreenShot = b;
		else if(c == Controls[22])
			class'Misc_Player'.default.bDisableEndCeremonySound = b;
    }
    else if(GUISlider(c) != None)
    {
        switch(c)
        {
            case Controls[18]:
                class'Misc_Player'.default.SoundAloneVolume = GUISlider(c).Value;
				break;
        }
    }

    Misc_Player(PlayerOwner()).SetupCombos();
	Misc_Player(PlayerOwner()).ReloadDefaults();
	class'Misc_Player'.static.StaticSaveConfig();
	class'Menu_Menu3SPN'.default.SettingsDirty = true;
}

function bool OnClick(GUIComponent C)
{
    if(C == Controls[20]) // Attempt TimeOut
    {
        Misc_Player(PlayerOwner()).CallTimeout();
        Controller.CloseMenu();
    }
	return true;
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
     Controls(0)=GUIImage'WS3SPN.Menu_TabMisc.TabBackground'

     Begin Object Class=moCheckBox Name=TeamCheck
         Caption="Disable Team Info."
         OnCreateComponent=TeamCheck.InternalOnCreateComponent
         Hint="Disables showing team members and enemies on the HUD."
         WinTop=0.415000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabMisc.OnChange
     End Object
     Controls(6)=moCheckBox'WS3SPN.Menu_TabMisc.TeamCheck'

     Begin Object Class=moCheckBox Name=ComboCheck
         Caption="Disable Combo List."
         OnCreateComponent=ComboCheck.InternalOnCreateComponent
         Hint="Disables showing combo info on the lower right portion of the HUD."
         WinTop=0.505000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabMisc.OnChange
     End Object
     Controls(7)=moCheckBox'WS3SPN.Menu_TabMisc.ComboCheck'

     Begin Object Class=GUILabel Name=ComboLabel
         Caption="Combos:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.145000
         WinLeft=0.050000
     End Object
     Controls(12)=GUILabel'WS3SPN.Menu_TabMisc.ComboLabel'

     Begin Object Class=moCheckBox Name=ExtendCheck
         Caption="Extended Teammate info."
         OnCreateComponent=ExtendCheck.InternalOnCreateComponent
         Hint="Displays extra teammate info; health and location name."
         WinTop=0.460000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabMisc.OnChange
     End Object
     Controls(14)=moCheckBox'WS3SPN.Menu_TabMisc.ExtendCheck'

     Begin Object Class=GUILabel Name=DummyObject
         TextColor=(B=255,G=255,R=255,A=0)
         bVisible=False
     End Object
     Controls(15)=GUILabel'WS3SPN.Menu_TabMisc.DummyObject'

     Begin Object Class=moCheckBox Name=ShotCheck
         Caption="Take end-game screenshot."
         OnCreateComponent=ShotCheck.InternalOnCreateComponent
         WinTop=0.100000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabMisc.OnChange
     End Object
     Controls(17)=moCheckBox'WS3SPN.Menu_TabMisc.ShotCheck'

     Begin Object Class=GUISlider Name=AloneVolumeSlider
         MaxValue=2.000000
         WinTop=0.792500
         WinLeft=0.500000
         WinWidth=0.400000
         OnClick=AloneVolumeSlider.InternalOnClick
         OnMousePressed=AloneVolumeSlider.InternalOnMousePressed
         OnMouseRelease=AloneVolumeSlider.InternalOnMouseRelease
         OnChange=Menu_TabMisc.OnChange
         OnKeyEvent=AloneVolumeSlider.InternalOnKeyEvent
         OnCapturedMouseMove=AloneVolumeSlider.InternalCapturedMouseMove
     End Object
     Controls(18)=GUISlider'WS3SPN.Menu_TabMisc.AloneVolumeSlider'

     Begin Object Class=GUILabel Name=AloneVolumeLabel
         Caption="Alone Volume:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.775000
         WinLeft=0.100000
     End Object
     Controls(19)=GUILabel'WS3SPN.Menu_TabMisc.AloneVolumeLabel'

     Begin Object Class=GUIButton Name=TimeoutButton
         Caption="Attempt Timeout"
         StyleName="SquareMenuButton"
         WinTop=0.910000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.080000
         OnClick=Menu_TabMisc.OnClick
         OnKeyEvent=TimeoutButton.InternalOnKeyEvent
     End Object
     Controls(20)=GUIButton'WS3SPN.Menu_TabMisc.TimeoutButton'

     Begin Object Class=moCheckBox Name=CeremonySoundsCheck
         Caption="Disable End Ceremony Sounds."
         OnCreateComponent=CeremonySoundsCheck.InternalOnCreateComponent
         Hint="Disables end ceremony sounds."
         WinTop=0.645000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabMisc.OnChange
     End Object
     Controls(22)=moCheckBox'WS3SPN.Menu_TabMisc.CeremonySoundsCheck'
}
