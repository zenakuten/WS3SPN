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
    local bool bSpectatingOther;
    for(C = Level.ControllerList; C != None; C=C.NextController)
    {
        if(Misc_Player(C) != None)
            Misc_Player(C).NumSpectators = 0;
    }

    for(C = Level.ControllerList; C != None; C=C.NextController)
    {
        if(Misc_Player(C) != None && C.PlayerReplicationInfo != None && !C.PlayerReplicationInfo.bAdmin)
        {
            PC = Misc_Player(C);
            
            // if we aren't looking at ourself
            if(Freon_Player(C) != None)
            {
                bSpectatingOther = PC.ViewTarget != None 
                    && PC.ViewTarget != C 
                    && PC.ViewTarget != C.Pawn 
                    && Freon_Player(C).ViewTarget != Freon_Player(C).FrozenPawn;
            }
            else
            {
                bSpectatingOther = PC.ViewTarget != None 
                    && PC.ViewTarget != C 
                    && PC.ViewTarget != C.Pawn;
            }

            if(bSpectatingOther)
            {
                // increment spec count for who we are looking at
                if(Misc_Player(PC.ViewTarget) != None)
                {
                    Misc_Player(PC.ViewTarget).NumSpectators++;
                }
                else if(Pawn(PC.ViewTarget) != None && Misc_Player(Pawn(PC.ViewTarget).Controller) != None)
                {
                    Misc_Player(Pawn(PC.ViewTarget).Controller).NumSpectators++;
                }
            }
        }
    }
}

defaultproperties
{
    checkTimer=1.5
    RemoteRole=ROLE_None
    bHidden=true
}