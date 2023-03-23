class Menu_TabWeapons extends UT2k3TabPanel;
var automated moCheckBox ch_UseNewEyeHeight;
var automated moCheckBox ch_TeamColorRockets;
var automated moCheckBox ch_TeamColorBio;
var automated moCheckBox ch_TeamColorFlak;
var automated moCheckBox ch_TeamColorShock;
//var automated moCheckBox ch_TeamColorSniper;

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

    ch_UseNewEyeHeight.Checked(class'Misc_Player'.default.bUseNewEyeHeightAlgorithm);
    ch_TeamColorRockets.Checked(class'Misc_Player'.default.bTeamColorRockets);
    ch_TeamColorBio.Checked(class'Misc_Player'.default.bTeamColorBio);
    ch_TeamColorFlak.Checked(class'Misc_Player'.default.bTeamColorFlak);
    ch_TeamColorShock.Checked(class'Misc_Player'.default.bTeamColorShock);
    //ch_TeamColorSniper.Checked(class'Misc_Player'.default.bTeamColorSniper);

    class'Menu_Menu3SPN'.default.SettingsDirty = OldDirty;
}

function InternalOnChange( GUIComponent C )
{
    Switch(C)
    {	
        case ch_UseNewEyeHeight:
            class'Misc_Player'.default.bUseNewEyeHeightAlgorithm = ch_UseNewEyeHeight.IsChecked();
            Misc_Player(PlayerOwner()).SetEyeHeightAlgorithm(ch_UseNewEyeHeight.IsChecked());
        break;

        case ch_TeamColorRockets:
            class'Misc_Player'.default.bTeamColorRockets = ch_TeamColorRockets.IsChecked();
        break;
        
        case ch_TeamColorBio:
            class'Misc_Player'.default.bTeamColorBio = ch_TeamColorBio.IsChecked();
        break;

        case ch_TeamColorFlak:
            class'Misc_Player'.default.bTeamColorFlak = ch_TeamColorFlak.IsChecked();
        break;

        case ch_TeamColorShock:
            class'Misc_Player'.default.bTeamColorShock = ch_TeamColorShock.IsChecked();
        break;

        /*
        case ch_TeamColorSniper:
            class'Misc_Player'.default.bTeamColorSniper = ch_TeamColorSniper.IsChecked();
        break;
        */
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

    Begin Object Class=moCheckBox Name=CheckTeamColorRockets
         Caption="Team colored rockets"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Add team coloring to rockets"
         WinTop=0.290000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabWeapons.InternalOnChange
     End Object
     ch_TeamColorRockets=moCheckBox'3SPNvSoL.Menu_TabWeapons.CheckTeamColorRockets'

    Begin Object Class=moCheckBox Name=CheckTeamColorBio
         Caption="Team colored bio"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Add team coloring to bio globs"
         WinTop=0.340000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabWeapons.InternalOnChange
     End Object
     ch_TeamColorBio=moCheckBox'3SPNvSoL.Menu_TabWeapons.CheckTeamColorBio'

    Begin Object Class=moCheckBox Name=CheckTeamColorFlak
         Caption="Team colored flak"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Add team coloring to flak"
         WinTop=0.390000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabWeapons.InternalOnChange
     End Object
     ch_TeamColorFlak=moCheckBox'3SPNvSoL.Menu_TabWeapons.CheckTeamColorFlak'

    Begin Object Class=moCheckBox Name=CheckTeamColorShock
         Caption="Team colored shock"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Add team coloring to shock"
         WinTop=0.440000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabWeapons.InternalOnChange
     End Object
     ch_TeamColorShock=moCheckBox'3SPNvSoL.Menu_TabWeapons.CheckTeamColorShock'

    /*
    Begin Object Class=moCheckBox Name=CheckTeamColorSniper
         Caption="Team colored lightning gun"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         Hint="Add team coloring to lightning gun"
         WinTop=0.490000
         WinLeft=0.100000
         WinWidth=0.800000
         OnChange=Menu_TabWeapons.InternalOnChange
     End Object
     ch_TeamColorSniper=moCheckBox'3SPNvSoL.Menu_TabWeapons.CheckTeamColorSniper'
     */
}
