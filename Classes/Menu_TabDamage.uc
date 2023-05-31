class Menu_TabDamage extends UT2k3TabPanel;

var automated moComboBox DamageSelect;
var automated moComboBox ReceiveAward;
var automated moCheckBox ConfigureNetSpeed;
var automated GUINumericEdit EditConfigureNetSpeedValue;
var automated moCheckBox EnableWidescreenFixes;
var automated moComboBox AbortNecro;
var automated moNumericEdit EditNetUpdateRate;

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

	DamageSelect.AddItem("Disabled");
	DamageSelect.AddItem("Centered");
	DamageSelect.AddItem("Floating");
	DamageSelect.ReadOnly(True);
	DamageSelect.SetIndex(class'Misc_Player'.default.DamageIndicatorType - 1);

	ReceiveAward.AddItem("Disabled");
	ReceiveAward.AddItem("Player");
	ReceiveAward.AddItem("Team");
	ReceiveAward.AddItem("All");
	ReceiveAward.ReadOnly(True);
	ReceiveAward.SetIndex(class'Misc_Player'.default.ReceiveAwardType);

    ConfigureNetSpeed.Checked(class'Misc_Player'.default.bConfigureNetSpeed);
    EnableWidescreenFixes.Checked(class'Misc_Player'.default.bEnableWidescreenFix);
    EditConfigureNetSpeedValue.MinValue=9000;
    EditConfigureNetSpeedValue.MaxValue=99999;
    EditConfigureNetSpeedValue.MyEditBox.MaxWidth=5;
    EditConfigureNetSpeedValue.SetValue(class'Misc_Player'.default.ConfigureNetSpeedValue);
    
    EditNetUpdateRate.MinValue=90;
    EditNetUpdateRate.MaxValue=250;
    if(Misc_Player(PlayerOwner()) != None)
    {
        EditNetUpdateRate.MinValue=Misc_Player(PlayerOwner()).RepInfo.MinNetUpdateRate;
        EditNetUpdateRate.MaxValue=Misc_Player(PlayerOwner()).RepInfo.MaxNetUpdateRate;
    }
    EditNetUpdateRate.SetValue(class'Misc_Player'.default.DesiredNetUpdateRate);

    AbortNecro.AddItem("None");
    AbortNecro.AddItem("Meow");
    AbortNecro.AddItem("Buzz");
    AbortNecro.AddItem("Fart");
    AbortNecro.ReadOnly(true);
	AbortNecro.SetIndex(class'Misc_Player'.default.AbortNecroSoundType);

	class'Menu_Menu3SPN'.default.SettingsDirty = OldDirty;
}

function InternalOnChange( GUIComponent C )
{
    Switch(C)
    {	
		case DamageSelect:
			class'Misc_Player'.default.DamageIndicatorType = DamageSelect.GetIndex() + 1;
			break;

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

		case EnableWidescreenFixes:
			class'Misc_Player'.default.bEnableWidescreenFix = EnableWidescreenFixes.IsChecked();
			break;

		case AbortNecro:
			class'Misc_Player'.default.AbortNecroSoundType = AbortNecroSounds(AbortNecro.GetIndex());
			break;

        case EditNetUpdateRate:
            class'Misc_Player'.default.DesiredNetUpdateRate = EditNetUpdateRate.GetValue();
            Misc_Player(PlayerOwner()).ServerSetNetUpdateRate(EditNetUpdateRate.GetValue(), PlayerOwner().Player.CurrentNetSpeed);
            break;
    }
	
    Misc_Player(PlayerOwner()).ReloadDefaults();
    class'Misc_Player'.Static.StaticSaveConfig();	
	class'Menu_Menu3SPN'.default.SettingsDirty = true;
}

defaultproperties
{
     Begin Object Class=moComboBox Name=ComboDamageIndicatorType
         Caption="Damage Indicators:"
         OnCreateComponent=ComboDamageIndicatorType.InternalOnCreateComponent
         WinTop=0.350000
         WinLeft=0.100000
         WinWidth=0.600000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     DamageSelect=moComboBox'3SPNvSoL.Menu_TabDamage.ComboDamageIndicatorType'

     Begin Object Class=moComboBox Name=ComboReceiveAwardType
         Caption="Receive Awards:"
         OnCreateComponent=ComboReceiveAwardType.InternalOnCreateComponent
         WinTop=0.410000
         WinLeft=0.100000
         WinWidth=0.600000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     ReceiveAward=moComboBox'3SPNvSoL.Menu_TabDamage.ComboReceiveAwardType'

     Begin Object Class=moCheckBox Name=CheckConfigureNetSpeed
         Caption="Auto Set Net Speed:"
         OnCreateComponent=CheckConfigureNetSpeed.InternalOnCreateComponent
         WinTop=0.470000
         WinLeft=0.100000
         WinWidth=0.400000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     ConfigureNetSpeed=moCheckBox'3SPNvSoL.Menu_TabDamage.CheckConfigureNetSpeed'

     Begin Object Class=GUINumericEdit Name=InputConfigureNetSpeed
         WinTop=0.460000
         WinLeft=0.550000
         WinWidth=0.150000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     EditConfigureNetSpeedValue=GUINumericEdit'3SPNvSoL.Menu_TabDamage.InputConfigureNetSpeed'

    Begin Object Class=moCheckBox Name=WidescreenFixCheck
         Caption="Enable Widescreen fixes:"
         OnCreateComponent=WidescreenFixCheck.InternalOnCreateComponent
         WinTop=0.530000
         WinLeft=0.100000
         WinWidth=0.600000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     EnableWidescreenFixes=moCheckBox'3SPNvSoL.Menu_TabDamage.WidescreenFixCheck'

     Begin Object Class=moComboBox Name=AbortNecroSoundTypesCombo
         Caption="Abort Necro Sound:"
         OnCreateComponent=ComboReceiveAwardType.InternalOnCreateComponent
         WinTop=0.580000
         WinLeft=0.100000
         WinWidth=0.600000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     AbortNecro=moComboBox'3SPNvSoL.Menu_TabDamage.AbortNecroSoundTypesCombo'

     Begin Object Class=moNumericEdit Name=InputNetUpdateRate
         Caption="Net Update Rate (for movement):"
         WinTop=0.630000
         WinLeft=0.100000
         WinWidth=0.600000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     EditNetUpdateRate=moNumericEdit'3SPNvSoL.Menu_TabDamage.InputNetUpdateRate'
}
