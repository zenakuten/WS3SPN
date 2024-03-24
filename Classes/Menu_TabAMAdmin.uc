class Menu_TabAMAdmin extends UT2k3TabPanel;

var bool bAdmin;

var moComboBox MapList;
var moComboBox PickupModeList;
var string MapName;
var array<string> Maps;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    Super.InitComponent(MyController, MyOwner);

	if(Controls.Length==0)
		return;
		
    moEditBox(Controls[4]).SetText(string(TAM_GRI(PlayerOwner().Level.GRI).StartingHealth));
    moEditBox(Controls[5]).SetText(string(TAM_GRI(PlayerOwner().Level.GRI).StartingArmor));
    moCheckBox(Controls[6]).Checked(TAM_GRI(PlayerOwner().Level.GRI).bChallengeMode);
    moEditBox(Controls[7]).SetText(string(TAM_GRI(PlayerOwner().Level.GRI).MaxHealth));

    moEditBox(Controls[8]).SetText(string(TAM_GRI(PlayerOwner().Level.GRI).SecsPerRound));
    moEditBox(Controls[9]).SetText(string(TAM_GRI(PlayerOwner().Level.GRI).OTDamage));
    moEditBox(Controls[10]).SetText(string(TAM_GRI(PlayerOwner().Level.GRI).OTInterval));

    moCheckBox(Controls[11]).Checked(TAM_GRI(PlayerOwner().Level.GRI).bDisableSpeed);
    moCheckBox(Controls[12]).Checked(TAM_GRI(PlayerOwner().Level.GRI).bDisableInvis);
    moCheckBox(Controls[13]).Checked(TAM_GRI(PlayerOwner().Level.GRI).bDisableBerserk);
    moCheckBox(Controls[14]).Checked(TAM_GRI(PlayerOwner().Level.GRI).bDisableBooster);

    moCheckBox(Controls[15]).Checked(TAM_GRI(PlayerOwner().Level.GRI).bKickExcessiveCampers);
	moCheckBox(Controls[21]).Checked(TAM_GRI(PlayerOwner().Level.GRI).bSpecExcessiveCampers);
    moEditBox(Controls[16]).SetText(string(TAM_GRI(PlayerOwner().Level.GRI).CampThreshold));  

    moCheckBox(Controls[17]).Checked(TAM_GRI(PlayerOwner().Level.GRI).bForceRUP);    

    PickupModeList = moComboBox(Controls[18]);
    PickupModeList.AddItem("Off");
    PickupModeList.AddItem("Random");
    PickupModeList.AddItem("Optimal");
    PickupModeList.SilentSetIndex(TAM_GRI(PlayerOwner().Level.GRI).PickupMode);

    MapName = Left(string(PlayerOwner().Level), InStr(string(PlayerOwner().Level), "."));
    
    MapList = moComboBox(Controls[3]);
    MapList.AddItem(MapName);
    MapList.SilentSetIndex(MapList.FindIndex(MapName));
    xPlayer(PlayerOwner()).ProcessMapName = ProcessMapName;
    xPlayer(PlayerOwner()).ServerRequestMapList();

    bAdmin = PlayerOwner().PlayerReplicationInfo!=None && (PlayerOwner().PlayerReplicationInfo.bAdmin || PlayerOwner().Level.NetMode == NM_Standalone);
    if(!bAdmin)
        for(i = 1; i < Controls.Length; i++)
            Controls[i].DisableMe();

    SetTimer(1.0, true);
}

function OnChange(GUIComponent C)
{
}

function ProcessMapName(string map)
{
    if(map == "")
    {
        MapList.ResetComponent();
        MapList.AddItem(MapName);
        MapList.SilentSetIndex(MapList.FindIndex(MapName));
    }
    else
    {
        if(map ~= MapName)
            return;

        MapList.AddItem(map);
    }
}

function bool OnClick(GUIComponent C)
{
    local string s;

    if(!bAdmin)
        return false;

    // save
    if(C == Controls[1])
    {
        s = "?StartingHealth="$moEditBox(Controls[4]).GetText();
        s = s$"?StartingArmor="$moEditBox(Controls[5]).GetText();
        s = s$"?ChallengeMode="$moCheckBox(Controls[6]).IsChecked();
        s = s$"?MaxHealth="$moEditBox(Controls[7]).GetText();

        s = s$"?SecsPerRound="$moEditBox(Controls[8]).GetText();
        s = s$"?OTDamage="$moEditBox(Controls[9]).GetText();
        s = s$"?OTInterval="$moEditBox(Controls[10]).GetText();

        s = s$"?DisableSpeed="$moCheckBox(Controls[11]).IsChecked();
        s = s$"?DisableInvis="$moCheckBox(Controls[12]).IsChecked();
        s = s$"?DisableBerserk="$moCheckBox(Controls[13]).IsChecked();
        s = s$"?DisableBooster="$moCheckBox(Controls[14]).IsChecked();

        s = s$"?KickExcessiveCampers="$moCheckBox(Controls[15]).IsChecked();
        s = s$"?CampThreshold="$moEditBox(Controls[16]).GetText();
        
        s = s$"?ForceRUP="$moCheckBox(Controls[17]).IsChecked();
        s = s$"?PickupMode="$PickupModeList.GetText();

        if(Misc_Player(PlayerOwner())  != None)
        {
            Misc_Player(PlayerOwner()).ClientMessage("Sent settings to server");
            Misc_Player(PlayerOwner()).ServerSetMapString(s);
        }
    }

    // map change
    if(C == Controls[2])
    {
        s = MapList.GetText();

        if(PlayerOwner().Level.NetMode != NM_Standalone)
            PlayerOwner().ConsoleCommand("admin servertravel"@s);
        else
            PlayerOwner().ConsoleCommand("open"@s);
    }

    return true;
}

function Timer()
{
    local bool bNewAdmin;
    local int i;

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
     Controls(0)=GUIImage'WS3SPN.Menu_TabAMAdmin.TabBackground'

     Begin Object Class=GUIButton Name=SaveButton
         Caption="Save"
         StyleName="WSButton"
         Hint="Save settings. Changes will take effect on the next map."
         WinTop=0.850000
         WinLeft=0.300000
         WinWidth=0.150000
         WinHeight=0.090000
         OnClick=Menu_TabAMAdmin.OnClick
         OnKeyEvent=SaveButton.InternalOnKeyEvent
     End Object
     Controls(1)=GUIButton'WS3SPN.Menu_TabAMAdmin.SaveButton'

     Begin Object Class=GUIButton Name=LoadButton
         Caption="Load Map"
         StyleName="WSButton"
         Hint="Force a map change."
         WinTop=0.850000
         WinLeft=0.550000
         WinWidth=0.150000
         WinHeight=0.090000
         OnClick=Menu_TabAMAdmin.OnClick
         OnKeyEvent=LoadButton.InternalOnKeyEvent
     End Object
     Controls(2)=GUIButton'WS3SPN.Menu_TabAMAdmin.LoadButton'

     Begin Object Class=wsComboBox Name=MapBox
         CaptionWidth=0.200000
         Caption="Map:"
         OnCreateComponent=MapBox.InternalOnCreateComponent
         WinTop=0.775000
         WinLeft=0.200000
         WinWidth=0.600000
         WinHeight=0.037500
     End Object
     Controls(3)=wsComboBox'WS3SPN.Menu_TabAMAdmin.MapBox'

     Begin Object Class=wsEditBox Name=HealthBox
         CaptionWidth=0.600000
         Caption="Health:"
         OnCreateComponent=HealthBox.InternalOnCreateComponent
         WinTop=0.050000
         WinLeft=0.050000
         WinWidth=0.400000
         WinHeight=0.060000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(4)=wsEditBox'WS3SPN.Menu_TabAMAdmin.HealthBox'

     Begin Object Class=wsEditBox Name=ArmorBox
         CaptionWidth=0.600000
         Caption="Armor:"
         OnCreateComponent=ArmorBox.InternalOnCreateComponent
         WinTop=0.050000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.060000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(5)=wsEditBox'WS3SPN.Menu_TabAMAdmin.ArmorBox'

     Begin Object Class=wsCheckBox Name=ChallengeCheck
         OnCreateComponent=ChallengeCheck.InternalOnCreateComponent
         WinTop=0.100000
         WinLeft=0.050000
         WinWidth=0.400000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(6)=wsCheckBox'WS3SPN.Menu_TabAMAdmin.ChallengeCheck'

     Begin Object Class=wsEditBox Name=MaxHealthBox
         CaptionWidth=0.600000
         Caption="Max Health:"
         OnCreateComponent=MaxHealthBox.InternalOnCreateComponent
         WinTop=0.100000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.060000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(7)=wsEditBox'WS3SPN.Menu_TabAMAdmin.MaxHealthBox'

     Begin Object Class=wsEditBox Name=MinsBox
         CaptionWidth=0.600000
         Caption="Seconds Per Round:"
         OnCreateComponent=MinsBox.InternalOnCreateComponent
         WinTop=0.200000
         WinLeft=0.050000
         WinWidth=0.400000
         WinHeight=0.060000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(8)=wsEditBox'WS3SPN.Menu_TabAMAdmin.MinsBox'

     Begin Object Class=wsEditBox Name=OTDamBox
         CaptionWidth=0.600000
         Caption="Overtime Damage:"
         OnCreateComponent=OTDamBox.InternalOnCreateComponent
         WinTop=0.200000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.060000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(9)=wsEditBox'WS3SPN.Menu_TabAMAdmin.OTDamBox'

     Begin Object Class=wsEditBox Name=OTIntBox
         CaptionWidth=0.600000
         Caption="Damage Interval:"
         OnCreateComponent=OTIntBox.InternalOnCreateComponent
         WinTop=0.250000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.060000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(10)=wsEditBox'WS3SPN.Menu_TabAMAdmin.OTIntBox'

     Begin Object Class=wsCheckBox Name=SpeedCheck
         Caption="Disable Speed"
         OnCreateComponent=SpeedCheck.InternalOnCreateComponent
         WinTop=0.400000
         WinLeft=0.050000
         WinWidth=0.400000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(11)=wsCheckBox'WS3SPN.Menu_TabAMAdmin.SpeedCheck'

     Begin Object Class=wsCheckBox Name=InvisCheck
         Caption="Disable Invis"
         OnCreateComponent=InvisCheck.InternalOnCreateComponent
         WinTop=0.400000
         WinLeft=0.550000
         WinWidth=0.400000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(12)=wsCheckBox'WS3SPN.Menu_TabAMAdmin.InvisCheck'

     Begin Object Class=wsCheckBox Name=BerserkCheck
         Caption="Disable Berserk"
         OnCreateComponent=BerserkCheck.InternalOnCreateComponent
         WinTop=0.450000
         WinLeft=0.050000
         WinWidth=0.400000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(13)=wsCheckBox'WS3SPN.Menu_TabAMAdmin.BerserkCheck'

     Begin Object Class=wsCheckBox Name=BoosterCheck
         Caption="Disable Booster"
         OnCreateComponent=BoosterCheck.InternalOnCreateComponent
         WinTop=0.450000
         WinLeft=0.550000
         WinWidth=0.400000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(14)=wsCheckBox'WS3SPN.Menu_TabAMAdmin.BoosterCheck'

     Begin Object Class=wsCheckBox Name=KickCheck2
         Caption="Spectate Excessive Campers"
         OnCreateComponent=KickCheck2.InternalOnCreateComponent
         WinTop=0.600000
         WinLeft=0.050000
         WinWidth=0.400000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(15)=wsCheckBox'WS3SPN.Menu_TabAMAdmin.KickCheck2'

     Begin Object Class=wsEditBox Name=CampBox
         CaptionWidth=0.600000
         Caption="Camp Area:"
         OnCreateComponent=CampBox.InternalOnCreateComponent
         WinTop=0.600000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.060000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(16)=wsEditBox'WS3SPN.Menu_TabAMAdmin.CampBox'

     Begin Object Class=wsCheckBox Name=ForceCheck
         Caption="Force Ready"
         OnCreateComponent=ForceCheck.InternalOnCreateComponent
         WinTop=0.700000
         WinLeft=0.050000
         WinWidth=0.400000
         OnChange=Menu_TabAMAdmin.OnChange
     End Object
     Controls(17)=wsCheckBox'WS3SPN.Menu_TabAMAdmin.ForceCheck'

     Begin Object Class=wsComboBox Name=PickupModeBox
         CaptionWidth=0.600000
         Caption="Pickup Mode:"
         OnCreateComponent=PickupModeBox.InternalOnCreateComponent
         WinTop=0.700000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.060000
     End Object
     Controls(18)=wsComboBox'WS3SPN.Menu_TabAMAdmin.PickupModeBox'

}
