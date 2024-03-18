class Menu_TabDamage extends UT2k3TabPanel;

var automated moComboBox ReceiveAward;
var automated moCheckBox ConfigureNetSpeed;
var automated GUINumericEdit EditConfigureNetSpeedValue;
var automated moCheckBox EnableWidescreenFixes;
var automated moCheckBox PlayOwnLandings;
var automated moComboBox AbortNecro;
// var automated moNumericEdit EditNetUpdateRate;
// var automated moCheckBox EnableDodgeFix;
var automated moCheckBox ShowSpectators;
var automated moCheckBox KillingSpreeCheers;

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

	Super.InitComponent(myController,MyOwner);	 
	 
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

    /*
    EditNetUpdateRate.MinValue=90;
    EditNetUpdateRate.MaxValue=250;
    if(Misc_Player(PlayerOwner()) != None)
    {
        if(Misc_BaseGRI(PlayerOwner().GameReplicationInfo) != None)
        {
            EditNetUpdateRate.MinValue=Misc_BaseGRI(Misc_Player(PlayerOwner()).GameReplicationInfo).MinNetUpdateRate;
            EditNetUpdateRate.MaxValue=Misc_BaseGRI(Misc_Player(PlayerOwner()).GameReplicationInfo).MaxNetUpdateRate;

            if(!Misc_BaseGRI(PlayerOwner().GameReplicationInfo).UseNetUpdateRate)
            {
                EditNetUpdateRate.DisableMe();
            }
        }
    }
    EditNetUpdateRate.SetValue(class'Misc_Player'.default.DesiredNetUpdateRate);
    */

    AbortNecro.AddItem("None");
    AbortNecro.AddItem("Meow");
    AbortNecro.AddItem("Buzz");
    AbortNecro.AddItem("Fart");
    AbortNecro.ReadOnly(true);
	AbortNecro.SetIndex(class'Misc_Player'.default.AbortNecroSoundType);

    PlayOwnLandings.Checked(class'Misc_Pawn'.default.bPlayOwnLandings);
    // EnableDodgeFix.Checked(class'Misc_Player'.default.bEnableDodgeFix);
    ShowSpectators.Checked(class'Misc_Player'.default.bShowSpectators);

    if(Misc_BaseGRI(PlayerOwner().Level.GRI) != None && !Misc_BaseGRI(PlayerOwner().Level.GRI).bShowNumSpecs)
    {
        ShowSpectators.SetVisibility(false);
    }

    KillingSpreeCheers.Checked(class'Misc_Player'.default.bKillingSpreeCheers);

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

    }
	
    Misc_Player(PlayerOwner()).ReloadDefaults();
    class'Misc_Player'.Static.StaticSaveConfig();	
	class'Menu_Menu3SPN'.default.SettingsDirty = true;
}

defaultproperties
{
     Begin Object Class=moComboBox Name=ComboReceiveAwardType
         Caption="Receive Awards:"
         OnCreateComponent=ComboReceiveAwardType.InternalOnCreateComponent
         WinTop=0.35
         WinLeft=0.100000
         WinWidth=0.600000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     ReceiveAward=moComboBox'WS3SPN.Menu_TabDamage.ComboReceiveAwardType'

     Begin Object Class=moCheckBox Name=CheckConfigureNetSpeed
         Caption="Auto Set Net Speed:"
         OnCreateComponent=CheckConfigureNetSpeed.InternalOnCreateComponent
         WinTop=0.410000
         WinLeft=0.100000
         WinWidth=0.400000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     ConfigureNetSpeed=moCheckBox'WS3SPN.Menu_TabDamage.CheckConfigureNetSpeed'

     Begin Object Class=GUINumericEdit Name=InputConfigureNetSpeed
         WinTop=0.400000
         WinLeft=0.550000
         WinWidth=0.150000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     EditConfigureNetSpeedValue=GUINumericEdit'WS3SPN.Menu_TabDamage.InputConfigureNetSpeed'

     Begin Object Class=moCheckBox Name=PlayOwnLandingsCheckBox
         Caption="Play Own Landing Sounds:"
         OnCreateComponent=PlayOwnLandingsCheckBox.InternalOnCreateComponent
         WinTop=0.470000
         WinLeft=0.100000
         WinWidth=0.600000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     PlayOwnLandings=moCheckBox'WS3SPN.Menu_TabDamage.PlayOwnLandingsCheckBox'

     Begin Object Class=moComboBox Name=AbortNecroSoundTypesCombo
         Caption="Abort Necro Sound:"
         OnCreateComponent=ComboReceiveAwardType.InternalOnCreateComponent
         WinTop=0.530000
         WinLeft=0.100000
         WinWidth=0.600000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     AbortNecro=moComboBox'WS3SPN.Menu_TabDamage.AbortNecroSoundTypesCombo'

     Begin Object Class=moCheckBox Name=ShowSpectatorsCheckBox
         Caption="Show spectators:"
         OnCreateComponent=ShowSpectatorsCheckBox.InternalOnCreateComponent
         WinTop=0.58
         WinLeft=0.100000
         WinWidth=0.600000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     ShowSpectators=moCheckBox'WS3SPN.Menu_TabDamage.ShowSpectatorsCheckBox'

     Begin Object Class=moCheckBox Name=KillingSpreeCheersCheckBox
         Caption="Killing spree cheers:"
         OnCreateComponent=KillingSpreeCheersCheckBox.InternalOnCreateComponent
         WinTop=0.63
         WinLeft=0.100000
         WinWidth=0.600000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     KillingSpreeCheers=moCheckBox'WS3SPN.Menu_TabDamage.KillingSpreeCheersCheckBox'
}
