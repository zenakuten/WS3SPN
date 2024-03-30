class Menu_Settings extends UT2k3TabPanel;

#exec texture Import File=textures\SPNLogo.TGA Name=SPNLogo Mips=Off Alpha=1

var automated GUIImage i_SPNLogo;
var automated moComboBox ReceiveAward;
var automated moCheckBox ConfigureNetSpeed;
var automated GUINumericEdit EditConfigureNetSpeedValue;
var automated moCheckBox EnableWidescreenFixes;
var automated moCheckBox PlayOwnLandings;
var automated moComboBox AbortNecro;
var automated moCheckBox ShowSpectators;
var automated moCheckBox KillingSpreeCheers;

///////////////////////////////

var automated moCheckBox DisableTeamInfo;
var automated moCheckBox DisableComboList;
var automated moCheckBox ExtendedTeamInfo;
var automated moCheckBox TakeScreenShot;
var automated GUILabel AloneLabel;
var automated GUISlider AloneSlider;
var automated GUIButton AttemptTimeout;
var automated moCheckBox DisableEndCeremonySounds;
var automated GUIButton OpenUTComp;


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

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local bool OldDirty;
    local TAM_GRI GRI;

	Super.InitComponent(myController,MyOwner);	 
	 
    GRI = TAM_GRI(PlayerOwner().Level.GRI);

	OldDirty = class'Menu_Menu3SPN'.default.SettingsDirty;

	ReceiveAward.AddItem("Disabled");
	ReceiveAward.AddItem("Player");
	ReceiveAward.AddItem("Team");
	ReceiveAward.AddItem("All");
	ReceiveAward.ReadOnly(True);
	ReceiveAward.SetIndex(class'Misc_Player'.default.ReceiveAwardType);

    ConfigureNetSpeed.Checked(class'Misc_Player'.default.bConfigureNetSpeed);

    EditConfigureNetSpeedValue.MinValue=9000;
    EditConfigureNetSpeedValue.MaxValue=100000;
    EditConfigureNetSpeedValue.MyEditBox.MaxWidth=6;
    EditConfigureNetSpeedValue.SetValue(class'Misc_Player'.default.ConfigureNetSpeedValue);

    AbortNecro.AddItem("None");
    AbortNecro.AddItem("Meow");
    AbortNecro.AddItem("Buzz");
    AbortNecro.AddItem("Fart");
    AbortNecro.ReadOnly(true);
	AbortNecro.SetIndex(class'Misc_Player'.default.AbortNecroSoundType);

    PlayOwnLandings.Checked(class'Misc_Pawn'.default.bPlayOwnLandings);
    ShowSpectators.Checked(class'Misc_Player'.default.bShowSpectators);

    if(Misc_BaseGRI(PlayerOwner().Level.GRI) != None && !Misc_BaseGRI(PlayerOwner().Level.GRI).bShowNumSpecs)
    {
        ShowSpectators.SetVisibility(false);
    }

    KillingSpreeCheers.Checked(class'Misc_Player'.default.bKillingSpreeCheers);

    ////////////////////

    DisableTeamInfo.Checked(!class'Misc_Player'.default.bShowTeamInfo);
    DisableComboList.Checked(!class'Misc_Player'.default.bShowCombos);    
    ExtendedTeamInfo.Checked(class'Misc_Player'.default.bExtendedInfo);
    TakeScreenShot.Checked(class'Misc_Player'.default.bAutoScreenShot);

    AloneSlider.Value = class'Misc_Player'.default.SoundAloneVolume;
	
	DisableEndCeremonySounds.Checked(class'Misc_Player'.default.bDisableEndCeremonySound);
	
	if(GRI != None)
	{
        if(!PlayerOwner().PlayerReplicationInfo.bAdmin && GRI.TimeOuts == 0)
        {
            AttemptTimeout.DisableMe();
        }
	}
    else
    {
        AttemptTimeout.DisableMe();
    }

	class'Menu_Menu3SPN'.default.SettingsDirty = OldDirty;
}

function InternalOnChange( GUIComponent C )
{
    Switch(C)
    {	
		case ReceiveAward:
			class'Misc_Player'.default.ReceiveAwardType = ReceiveAwardTypes(ReceiveAward.GetIndex());
			break;

		case ConfigureNetSpeed:
			class'Misc_Player'.default.bConfigureNetSpeed = ConfigureNetSpeed.IsChecked();
             Misc_Player(PlayerOwner()).SetInitialNetSpeed();
			break;
            
		case EditConfigureNetSpeedValue:
            if(int(EditConfigureNetSpeedValue.Value) > 0)
            {
                class'Misc_Player'.default.ConfigureNetSpeedValue = int(EditConfigureNetSpeedValue.Value);
                Misc_Player(PlayerOwner()).SetInitialNetSpeed();
            }
			break;

		case AbortNecro:
			class'Misc_Player'.default.AbortNecroSoundType = AbortNecroSounds(AbortNecro.GetIndex());
			break;

		case PlayOwnLandings:
            class'Misc_Pawn'.default.bPlayOwnLandings = PlayOwnLandings.IsChecked();
            class'Misc_Pawn'.static.StaticSaveConfig();

            if(Misc_Pawn(PlayerOwner().Pawn) != None)
            {
                Misc_Pawn(PlayerOwner().Pawn).bPlayOwnLandings = PlayOwnLandings.IsChecked();
                Misc_Pawn(PlayerOwner().Pawn).SaveConfig();
            }            
			break;

		case ShowSpectators:
			class'Misc_Player'.default.bShowSpectators = ShowSpectators.IsChecked();
			break;
        case KillingSpreeCheers:
			class'Misc_Player'.default.bKillingSpreeCheers = KillingSpreeCheers.IsChecked();

        case DisableTeamInfo:
            class'Misc_Player'.default.bShowTeamInfo = !DisableTeamInfo.IsChecked();
            break;

        case DisableComboList:
            class'Misc_Player'.default.bShowCombos = !DisableComboList.IsChecked();
            break;

        case ExtendedTeamInfo:
            class'Misc_Player'.default.bExtendedInfo = ExtendedTeamInfo.IsChecked();
            break;

        case TakeScreenShot:
            class'Misc_Player'.default.bAutoScreenShot = TakeScreenShot.IsChecked();
            break;

        case DisableEndCeremonySounds:
            class'Misc_Player'.default.bDisableEndCeremonySound = DisableEndCeremonySounds.IsChecked();
            break;
        
        case AloneSlider:
            class'Misc_Player'.default.SoundAloneVolume = AloneSlider.Value;
            break;
    }
	
    Misc_Player(PlayerOwner()).ReloadDefaults();
    class'Misc_Player'.Static.StaticSaveConfig();	
	class'Menu_Menu3SPN'.default.SettingsDirty = true;
}

function bool InternalOnClick(GUIComponent C)
{
    switch(C)
    {
        case AttemptTimeout:
            Misc_Player(PlayerOwner()).CallTimeout();
            Controller.CloseMenu();
            break;

        case OpenUTComp:
            Controller.ReplaceMenu(class'BS_xPlayer'.default.UTCompMenuClass);
            break;
    }

	return true;
}

defaultproperties
{
    Begin Object class=GUIImage name=SPNLogo
     ImageStyle=ISTY_Scaled
         ImageRenderStyle=MSTY_Alpha
		WinWidth=0.375000
		WinHeight=0.125000
		WinLeft=0.312500
		WinTop=0.01
        Image=Texture'SPNLogo'
     End Object
     i_SPNLogo=GUIImage'SPNLogo'

     Begin Object Class=wsComboBox Name=ComboReceiveAwardType
         Caption="Receive Awards:"
         OnCreateComponent=ComboReceiveAwardType.InternalOnCreateComponent
         WinTop=0.15
         WinLeft=0.000000
         WinWidth=0.400000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     ReceiveAward=wsComboBox'WS3SPN.Menu_Settings.ComboReceiveAwardType'

     Begin Object Class=wsCheckBox Name=CheckConfigureNetSpeed
         Caption="Auto Set Net Speed:"
         OnCreateComponent=CheckConfigureNetSpeed.InternalOnCreateComponent
         WinTop=0.210000
         WinLeft=0.000000
         WinWidth=0.250000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     ConfigureNetSpeed=wsCheckBox'WS3SPN.Menu_Settings.CheckConfigureNetSpeed'

     Begin Object Class=wsGUINumericEdit Name=InputConfigureNetSpeed
         WinTop=0.200000
         WinLeft=0.300000
         WinWidth=0.100000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     EditConfigureNetSpeedValue=wsGUINumericEdit'WS3SPN.Menu_Settings.InputConfigureNetSpeed'

     Begin Object Class=wsCheckBox Name=PlayOwnLandingsCheckBox
         Caption="Play Own Landing Sounds:"
         OnCreateComponent=PlayOwnLandingsCheckBox.InternalOnCreateComponent
         WinTop=0.270000
         WinLeft=0.000000
         WinWidth=0.400000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     PlayOwnLandings=wsCheckBox'WS3SPN.Menu_Settings.PlayOwnLandingsCheckBox'

     Begin Object Class=wsComboBox Name=AbortNecroSoundTypesCombo
         Caption="Abort Necro Sound:"
         OnCreateComponent=ComboReceiveAwardType.InternalOnCreateComponent
         WinTop=0.330000
         WinLeft=0.000000
         WinWidth=0.400000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     AbortNecro=wsComboBox'WS3SPN.Menu_Settings.AbortNecroSoundTypesCombo'

     Begin Object Class=wsCheckBox Name=ShowSpectatorsCheckBox
         Caption="Show spectators:"
         OnCreateComponent=ShowSpectatorsCheckBox.InternalOnCreateComponent
         WinTop=0.38
         WinLeft=0.000000
         WinWidth=0.400000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     ShowSpectators=wsCheckBox'WS3SPN.Menu_Settings.ShowSpectatorsCheckBox'

     Begin Object Class=wsCheckBox Name=KillingSpreeCheersCheckBox
         Caption="Killing spree cheers:"
         OnCreateComponent=KillingSpreeCheersCheckBox.InternalOnCreateComponent
         WinTop=0.43
         WinLeft=0.000000
         WinWidth=0.400000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     KillingSpreeCheers=wsCheckBox'WS3SPN.Menu_Settings.KillingSpreeCheersCheckBox'

     /////////////////////////////////////////////

     Begin Object Class=wsCheckBox Name=ShotCheck
         Caption="Take end-game screenshot."
         OnCreateComponent=ShotCheck.InternalOnCreateComponent
         WinTop=0.150000
         WinLeft=0.600000
         WinWidth=0.400000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     TakeScreenShot=wsCheckBox'WS3SPN.Menu_Settings.ShotCheck'

     Begin Object Class=wsCheckBox Name=TeamCheck
         Caption="Disable Team Info."
         OnCreateComponent=TeamCheck.InternalOnCreateComponent
         Hint="Disables showing team members and enemies on the HUD."
         WinTop=0.21
         WinLeft=0.600000
         WinWidth=0.400000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     DisableTeamInfo=wsCheckBox'WS3SPN.Menu_Settings.TeamCheck'

     Begin Object Class=wsCheckBox Name=ComboCheck
         Caption="Disable Combo List."
         OnCreateComponent=ComboCheck.InternalOnCreateComponent
         Hint="Disables showing combo info on the lower right portion of the HUD."
         WinTop=0.27
         WinLeft=0.600000
         WinWidth=0.400000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     DisableComboList=wsCheckBox'WS3SPN.Menu_Settings.ComboCheck'

     Begin Object Class=wsCheckBox Name=ExtendCheck
         Caption="Extended Teammate info."
         OnCreateComponent=ExtendCheck.InternalOnCreateComponent
         Hint="Displays extra teammate info; health and location name."
         WinTop=0.330000
         WinLeft=0.600000
         WinWidth=0.400000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     ExtendedTeamInfo=wsCheckBox'WS3SPN.Menu_Settings.ExtendCheck'

     Begin Object Class=wsCheckBox Name=CeremonySoundsCheck
         Caption="Disable End Ceremony Sounds."
         OnCreateComponent=CeremonySoundsCheck.InternalOnCreateComponent
         Hint="Disables end ceremony sounds."
         WinTop=0.39000
         WinLeft=0.600000
         WinWidth=0.400000
         OnChange=Menu_Settings.InternalOnChange
     End Object
     DisableEndCeremonySounds=wsCheckBox'WS3SPN.Menu_Settings.CeremonySoundsCheck'

     Begin Object Class=wsGUISlider Name=AloneVolumeSlider
         MaxValue=2.000000
         WinTop=0.45
         WinLeft=0.800000
         WinWidth=0.200000
         OnClick=AloneVolumeSlider.InternalOnClick
         OnMousePressed=AloneVolumeSlider.InternalOnMousePressed
         OnMouseRelease=AloneVolumeSlider.InternalOnMouseRelease
         OnChange=Menu_Settings.InternalOnChange
         OnKeyEvent=AloneVolumeSlider.InternalOnKeyEvent
         OnCapturedMouseMove=AloneVolumeSlider.InternalCapturedMouseMove
     End Object
     AloneSlider=wsGUISlider'WS3SPN.Menu_Settings.AloneVolumeSlider'

     Begin Object Class=GUILabel Name=AloneVolumeLabel
         StyleName="WSLabel"
         Caption="Alone Volume:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.43
         WinLeft=0.600000
     End Object
     AloneLabel=GUILabel'WS3SPN.Menu_Settings.AloneVolumeLabel'

     Begin Object Class=GUIButton Name=UTCompBtn
         Caption="UTComp Settings"
         StyleName="WSButton"
         WinTop=0.49000
         WinLeft=0.800000
         WinWidth=0.200000
         WinHeight=0.080000
         OnClick=Menu_Settings.InternalOnClick
         OnKeyEvent=UTCompBtn.InternalOnKeyEvent
     End Object
     OpenUTComp=GUIButton'WS3SPN.Menu_Settings.UTCompBtn'

     Begin Object Class=GUIButton Name=TimeoutBtn
         Caption="Attempt Timeout"
         StyleName="WSButton"
         WinTop=0.910000
         WinLeft=0.750000
         WinWidth=0.200000
         WinHeight=0.080000
         OnClick=Menu_Settings.InternalOnClick
         OnKeyEvent=TimeoutBtn.InternalOnKeyEvent
     End Object
     AttemptTimeout=GUIButton'WS3SPN.Menu_Settings.TimeoutBtn'

}
