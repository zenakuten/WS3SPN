class Menu_TabDamage extends UT2k3TabPanel;

var automated moComboBox DamageSelect;
var automated moComboBox ReceiveAward;

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
         WinTop=0.400000
         WinLeft=0.100000
         WinWidth=0.600000
         OnChange=Menu_TabDamage.InternalOnChange
     End Object
     ReceiveAward=moComboBox'3SPNvSoL.Menu_TabDamage.ComboReceiveAwardType'

}
