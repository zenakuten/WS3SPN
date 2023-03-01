class Menu_TabDamage extends UT2k3TabPanel;

var automated moComboBox DamageSelect;

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

	class'Menu_Menu3SPN'.default.SettingsDirty = OldDirty;
}

function InternalOnChange( GUIComponent C )
{
    Switch(C)
    {	
		case DamageSelect:
			class'Misc_Player'.default.DamageIndicatorType = DamageSelect.GetIndex() + 1;
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

}
