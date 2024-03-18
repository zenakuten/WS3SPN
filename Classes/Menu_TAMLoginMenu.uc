class Menu_TAMLoginMenu extends UT2K4PlayerLoginMenu;

function AddPanels()
{
	Panels[0].ClassName = "WS3SPN.Menu_PlayerLoginControlsTAM";
	Super.AddPanels();
}

defaultproperties
{
}
