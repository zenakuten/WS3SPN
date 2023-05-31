//-----------------------------------------------------------------------------------
// MutNecro [ComboWhore Ed] | ComboWhore Tweak based on code by Shaun Goeppinger 2013
// www.combowhore.com
//-----------------------------------------------------------------------------------

#exec AUDIO IMPORT FILE="Sounds\Resurrection.wav"
#exec AUDIO IMPORT FILE="Sounds\Thaw.wav"
#exec AUDIO IMPORT FILE="Sounds\ShortCircuit.wav"
#exec AUDIO IMPORT FILE="Sounds\fart.wav"
#exec AUDIO IMPORT FILE="Sounds\meow1.wav"
#exec AUDIO IMPORT FILE="Sounds\meow2.wav"
#exec AUDIO IMPORT FILE="Sounds\meow3.wav"

class MutNecro extends Mutator;

var() config bool bShowSpawnMessage;
var() config bool bBotsCanNecro;
var() config color SpawnMessageColour;

var() xPlayer NotifyPlayer[32];
var() localized string PropsDisplayText[2];
var() localized string PropsDescText[2];
var() class<NecroCombo> NecroComboClass;

function string RecommendCombo(string ComboName)
{
    
    
        if ( FRand() < 0.41 )
        {
            ComboName = "3SPNvSoL.NecroCombo";
		}
        else
        {
            ComboName = "xGame.ComboDefensive";
		}
    

    if ( NextMutator != None )
    {
        return NextMutator.RecommendCombo(ComboName);
	}

    return ComboName;
}

function ModifyPlayer(Pawn Other)
{
  	Super.ModifyPlayer(Other);

  	if (bShowSpawnMessage && PlayerController(Other.Controller)!=None)
  	{
		PlayerController(Other.Controller).ClientMessage(Level.Game.MakeColorCode(SpawnMessageColour)$"To cut a teammates hair press B,B,F,F with 100 adren.");
	}
}

function Timer()
{
	local byte i;

    //local Controller C;
    //for(C=Level.ControllerList; C!=None; C=C.NextController)
    //    C.Adrenaline = 100;
  
	for ( i=0; i<32; i++ )
	{
		if ( NotifyPlayer[i] != None )
		{
			NotifyPlayer[i].ClientReceiveCombo("3SPNvSoL.NecroCombo");
			NotifyPlayer[i] = None;
		}
	}
}

function bool IsRelevant(Actor Other, out byte bSuperRelevant)
{
	local byte i;

	if ( xPlayer(Other) != None )
	{
		for ( i=0; i<16; i++ )
		{
			if ( xPlayer(Other).ComboNameList[i] ~= "3SPNvSoL.NecroCombo" )
			{
				break;
			}
			else if ( xPlayer(Other).ComboNameList[i] == "" )
			{
				xPlayer(Other).ComboNameList[i] = "3SPNvSoL.NecroCombo";
				break;
			}
		}

		for ( i=0; i<32; i++ )
		{
			if ( NotifyPlayer[i] == None )
			{
				NotifyPlayer[i] = xPlayer(Other);
				SetTimer(0.5, false);
				break;
			}
		}
	}

	if ( NextMutator != None )
	{
		return NextMutator.IsRelevant(Other, bSuperRelevant);
	}
	else
	{
		return true;
	}
}

function GetServerDetails( out GameInfo.ServerResponseLine ServerState )
{
	local int i;

    i = ServerState.ServerInfo.Length;
    ServerState.ServerInfo.Length = i+3;
	ServerState.ServerInfo[i].Key = "Mutator";
   	ServerState.ServerInfo[i].Value = GetHumanReadableName();
	ServerState.ServerInfo[i+1].Key = "Necromancy";
	ServerState.ServerInfo[i+1].Value = "v3";
	ServerState.ServerInfo[i+2].Key = "Necro Award";
	ServerState.ServerInfo[i+2].Value = string(class'NecroCombo'.default.NecroScoreAward);
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting("Necro Combo v3", "bBotsCanNecro", default.PropsDisplayText[0], 0, 10, "Check");
	PlayInfo.AddSetting("Necro Combo v3", "bShowSpawnMessage", default.PropsDisplayText[1], 0, 10, "Check");


	if (default.NecroComboClass != None)
	{
		default.NecroComboClass.static.FillPlayInfo(PlayInfo);
        // this spams a fuckton to logs
        // PlayInfo.Dump();
		PlayInfo.PopClass();
	}
}

static function string GetDescriptionText(string PropName)
{
	switch (PropName)
	{
		case "bBotsCanNecro":	        return default.PropsDescText[0];
		case "bShowSpawnMessage":		return default.PropsDescText[1];
	}
}

defaultproperties
{
     bBotsCanNecro=True
     SpawnMessageColour=(B=224,G=58,R=196,A=255)
     PropsDisplayText(0)="Bots Can Perform Necro"
     PropsDisplayText(1)="Show How To Necro Message"
     PropsDescText(0)="Should bots use necro? (true by default)"
     PropsDescText(1)="Show the (To resurrect a teammate press B,B,F,F with 100 adren) spawn message? (True by default)."
     NecroComboClass=Class'3SPNvSoL.NecroCombo'
     bAddToServerPackages=True
     GroupName="Combo Necromancy"
     FriendlyName="Necromancy v3"
     Description="Resurrect a team mate from the dead! Support for Invasion and Team Games based on number of lives. (To resurrect a teammate press B,B,F,F with 100 adren)"
}
