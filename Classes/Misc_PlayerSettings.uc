class Misc_PlayerSettings extends Object
	config(PlayerSettings3SPNCW)
	PerObjectConfig;
	
struct ColoredNamesSettings
{
	var bool bEnableColoredNamesInTalk;
	var bool bEnableColoredNamesOnScoreboard;
	var bool bEnableColoredNamesOnHUD;
	var bool bAllowColoredMessages;
	var bool bEnableColoredNamesOnEnemies;
	var bool bEnableTeamColoredDeaths;
	var bool bDrawColoredNamesInDeathMessages;
	var Color ColorName[20];
};

struct MiscSettings
{
	var bool bDisableSpeed;
	var bool bDisableBooster;
	var bool bDisableBerserk;
	var bool bDisableInvis;
	var bool bShowTeamInfo;
	var bool bShowCombos;
	var bool bExtendedInfo;
	var bool bPlayOwnFootsteps;
	var bool bPlayOwnLandings;
	var bool bAutoScreenShot;
	var bool bDisableEndCeremonySound;
	var float SoundAloneVolume;
    var int DamageIndicatorType;
    var int ReceiveAwardType;
    var bool bConfigureNetSpeed;
    var int ConfigureNetSpeedValue;
    var bool bEnableEmoticons;
    var bool bKillingSpreeCheers;
};

var config bool Existing;
var config MiscSettings Misc;

static function Misc_PlayerSettings LoadPlayerSettings(Misc_Player P)
{
	local Misc_PlayerSettings PlayerSettings, NewPlayerSettings;
	local string OwnerID, PlayerName, StatsID;
	
	// Try with stats username
	StatsID = class'Misc_Util'.static.GetStatsID(P);
	if(StatsID!="")
	{
		NewPlayerSettings = Misc_PlayerSettings(FindObject("Package." $ StatsID, class'Misc_PlayerSettings'));
		if(NewPlayerSettings == None)
			NewPlayerSettings = new(None, StatsID) class'Misc_PlayerSettings';		
		
		// If these settings exist, just return them
		if(NewPlayerSettings != None && NewPlayerSettings.Existing == True)
			return NewPlayerSettings;
	}

	// Load the legacy settings
	PlayerName = class'Misc_Util'.static.StripColor(P.PlayerReplicationInfo.PlayerName);
    ReplaceText(PlayerName, " ", "_");
	ReplaceText(PlayerName, "]", "_");		
	OwnerID = P.GetPlayerIDHash() $ "_" $ PlayerName;
		
	PlayerSettings = Misc_PlayerSettings(FindObject("Package." $ OwnerID, class'Misc_PlayerSettings'));
	if(PlayerSettings == None)
		PlayerSettings = new(None, OwnerID) class'Misc_PlayerSettings';
	
	// If stats username settings aren't taken, migrate the settings over
	if(NewPlayerSettings != None && NewPlayerSettings.Existing == False)
	{
		NewPlayerSettings.Existing = PlayerSettings.Existing;
		NewPlayerSettings.Misc = PlayerSettings.Misc;
		NewPlayerSettings.SaveConfig();
		
		return NewPlayerSettings;
	}
	
	// Wasn't able to migrate over, so just use the legacy settings
	return PlayerSettings;
}

static function SavePlayerSettings(Misc_PlayerSettings PlayerSettings)
{
	PlayerSettings.Existing = True;
	PlayerSettings.SaveConfig();
	StaticSaveConfig();
}

defaultproperties
{
}
