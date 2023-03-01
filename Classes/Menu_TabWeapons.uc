class Menu_TabWeapons extends UT2k3TabPanel;
var automated moCheckBox ch_UseNewEyeHeight;

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

    //ch_UseNewEyeHeight.Checked(Misc_Player(PlayerOwner()).default.bUseNewEyeHeightAlgorithm);
    ch_UseNewEyeHeight.Checked(class'Misc_Player'.default.bUseNewEyeHeightAlgorithm);

    class'Menu_Menu3SPN'.default.SettingsDirty = OldDirty;
}

function InternalOnChange( GUIComponent C )
{
    Switch(C)
    {	
        case ch_UseNewEyeHeight:
            //Misc_Player(PlayerOwner()).default.bUseNewEyeHeightAlgorithm = ch_UseNewEyeHeight.IsChecked();
            class'Misc_Player'.default.bUseNewEyeHeightAlgorithm = ch_UseNewEyeHeight.IsChecked();
            Misc_Player(PlayerOwner()).SetEyeHeightAlgorithm(ch_UseNewEyeHeight.IsChecked());
        break;
    }
	
    Misc_Player(PlayerOwner()).ReloadDefaults();
    class'Misc_Player'.Static.StaticSaveConfig();	
    class'Menu_Menu3SPN'.default.SettingsDirty = true;
}

defaultproperties
{
    Begin Object Class=moCheckBox Name=UseNewEyeHeight
         Caption="New Eye Height Algorithm"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Use the new height height algorithm"
         WinTop=0.190000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabWeapons.InternalOnChange
     End Object
     ch_UseNewEyeHeight=moCheckBox'3SPNvSoL.Menu_TabWeapons.UseNewEyeHeight'

}
