class SpecMonitor extends Actor;

var float checkTimer;

function PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(checkTimer, true);
}

function Timer()
{
    local Controller C;
    local Misc_Player PC;
    for(C = Level.ControllerList; C != None; C=C.NextController)
    {
        if(Misc_Player(C) != None)
            Misc_Player(C).NumSpectators = 0;
    }

    for(C = Level.ControllerList; C != None; C=C.NextController)
    {
        if(Misc_Player(C) != None)
        {
            PC = Misc_Player(C);
            
            // if we aren't looking at ourself
            if(PC.ViewTarget != None && PC.ViewTarget != C && PC.ViewTarget != C.Pawn)
            {
                // increment spec count for who we are looking at
                if(Misc_Player(PC.ViewTarget) != None)
                {
                    Misc_Player(PC.ViewTarget).NumSpectators++;
                }
                else if(Pawn(PC.ViewTarget) != None && Misc_Player(Pawn(PC.ViewTarget).Controller) != None)
                {
                    Misc_Player(Misc_Pawn(PC.ViewTarget).Controller).NumSpectators++;
                }
            }
        }
    }
}

defaultproperties
{
    checkTimer=1.5
    RemoteRole=ROLE_None
}