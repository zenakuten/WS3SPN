// Patches to PlayerController to bring UT2004 to the modern world.
class ModernPlayer extends xPlayer;

var config int MaxSavedMoves;
var config float SavedMovesWarningInterval;
var float LastSavedMovesWarning;

// See PlayerController.uc on how this function works.
//
// This is mostly a duplicate of the original implementation in
// PlayerController, with the exception of the GetFreeMove() call.
// GetFreeMove() is replaced with GetFreeMoveEx(), which respects the
// configurable MaxSavedMoves value. This is to prevent rubberbanding when
// playing on high fps and/or high ping.
function ReplicateMove
(
    float DeltaTime,
    vector NewAccel,
    eDoubleClickDir DoubleClickMove,
    rotator DeltaRot
)
{
    local SavedMove NewMove, OldMove, AlmostLastMove, LastMove;
    local byte ClientRoll;
    local float OldTimeDelta, NetMoveDelta;
    local int OldAccel;
    local vector BuildAccel, AccelNorm, MoveLoc, CompareAccel;
	local bool bPendingJumpStatus;

	MaxResponseTime = Default.MaxResponseTime * Level.TimeDilation;
	DeltaTime = FMin(DeltaTime, MaxResponseTime);

	// find the most recent move, and the most recent interesting move
    if ( SavedMoves != None )
    {
        LastMove = SavedMoves;
        AlmostLastMove = LastMove;
        AccelNorm = Normal(NewAccel);
        while ( LastMove.NextMove != None )
        {
            // find most recent interesting move to send redundantly
            if ( LastMove.IsJumpMove() )
			{
                OldMove = LastMove;
            }
            else if ( (Pawn != None) && ((OldMove == None) || !OldMove.IsJumpMove()) )
            {
				// see if acceleration direction changed
				if ( OldMove != None )
					CompareAccel = Normal(OldMove.Acceleration);
				else
					CompareAccel = AccelNorm;

				if ( (LastMove.Acceleration != CompareAccel) && ((normal(LastMove.Acceleration) Dot CompareAccel) < 0.95) )
					OldMove = LastMove;
			}

            AlmostLastMove = LastMove;
            LastMove = LastMove.NextMove;
        }
        if ( LastMove.IsJumpMove() )
		{
            OldMove = LastMove;
        }
        else if ( (Pawn != None) && ((OldMove == None) || !OldMove.IsJumpMove()) )
        {
			// see if acceleration direction changed
			if ( OldMove != None )
				CompareAccel = Normal(OldMove.Acceleration);
			else
				CompareAccel = AccelNorm;

			if ( (LastMove.Acceleration != CompareAccel) && ((normal(LastMove.Acceleration) Dot CompareAccel) < 0.95) )
				OldMove = LastMove;
		}
    }

    // Get a SavedMove actor to store the movement in.
	NewMove = GetFreeMoveEx();
	if ( NewMove == None )
		return;
	NewMove.SetMoveFor(self, DeltaTime, NewAccel, DoubleClickMove);

    // Simulate the movement locally.
    bDoubleJump = false;
    ProcessMove(NewMove.Delta, NewMove.Acceleration, NewMove.DoubleClickMove, DeltaRot);

	// see if the two moves could be combined
	if ( (PendingMove != None) && (Pawn != None) && (Pawn.Physics == PHYS_Walking)
		&& (NewMove.Delta + PendingMove.Delta < MaxResponseTime)
		&& (NewAccel != vect(0,0,0))
		&& (PendingMove.SavedPhysics == PHYS_Walking)
		&& !PendingMove.bPressedJump && !NewMove.bPressedJump
		&& (PendingMove.bRun == NewMove.bRun)
		&& (PendingMove.bDuck == NewMove.bDuck)
		&& (PendingMove.bDoubleJump == NewMove.bDoubleJump)
		&& (PendingMove.DoubleClickMove == DCLICK_None)
		&& (NewMove.DoubleClickMove == DCLICK_None)
		&& ((Normal(PendingMove.Acceleration) Dot Normal(NewAccel)) > 0.99)
		&& (Level.TimeDilation >= 0.9) )
	{
		Pawn.SetLocation(PendingMove.GetStartLocation());
		Pawn.Velocity = PendingMove.StartVelocity;
		if ( PendingMove.StartBase != Pawn.Base);
			Pawn.SetBase(PendingMove.StartBase);
		Pawn.Floor = PendingMove.StartFloor;
		NewMove.Delta += PendingMove.Delta;
		NewMove.SetInitialPosition(Pawn);

		// remove pending move from move list
		if ( LastMove == PendingMove )
		{
			if ( SavedMoves == PendingMove )
			{
				SavedMoves.NextMove = FreeMoves;
				FreeMoves = SavedMoves;
				SavedMoves = None;
			}
			else
			{
				PendingMove.NextMove = FreeMoves;
				FreeMoves = PendingMove;
				if ( AlmostLastMove != None )
				{
					AlmostLastMove.NextMove = None;
					LastMove = AlmostLastMove;
				}
			}
			FreeMoves.Clear();
		}
		PendingMove = None;
	}

    if ( Pawn != None )
        Pawn.AutonomousPhysics(NewMove.Delta);
    else
        AutonomousPhysics(DeltaTime);
    NewMove.PostUpdate(self);

	if ( SavedMoves == None )
		SavedMoves = NewMove;
	else
		LastMove.NextMove = NewMove;

	if ( PendingMove == None )
	{
		// Decide whether to hold off on move
		if ( (Player.CurrentNetSpeed > 10000) && (GameReplicationInfo != None) && (GameReplicationInfo.PRIArray.Length <= 10) )
			NetMoveDelta = 0.011;
		else
			NetMoveDelta = FMax(0.0222,2 * Level.MoveRepSize/Player.CurrentNetSpeed);

		if ( (Level.TimeSeconds - ClientUpdateTime) * Level.TimeDilation * 0.91 < NetMoveDelta )
		{
			PendingMove = NewMove;
			return;
		}
	}

    ClientUpdateTime = Level.TimeSeconds;

    // check if need to redundantly send previous move
    if ( OldMove != None )
    {
        // old move important to replicate redundantly
        OldTimeDelta = FMin(255, (Level.TimeSeconds - OldMove.TimeStamp) * 500);
        BuildAccel = 0.05 * OldMove.Acceleration + vect(0.5, 0.5, 0.5);
        OldAccel = (CompressAccel(BuildAccel.X) << 23)
                    + (CompressAccel(BuildAccel.Y) << 15)
                    + (CompressAccel(BuildAccel.Z) << 7);
        if ( OldMove.bRun )
            OldAccel += 64;
        if ( OldMove.bDoubleJump )
            OldAccel += 32;
        if ( OldMove.bPressedJump )
            OldAccel += 16;
        OldAccel += OldMove.DoubleClickMove;
    }

    // Send to the server
	ClientRoll = (Rotation.Roll >> 8) & 255;
    if ( PendingMove != None )
    {
		if ( PendingMove.bPressedJump )
			bJumpStatus = !bJumpStatus;
		bPendingJumpStatus = bJumpStatus;
	}
    if ( NewMove.bPressedJump )
         bJumpStatus = !bJumpStatus;

    if ( Pawn == None )
        MoveLoc = Location;
    else
        MoveLoc = Pawn.Location;

    CallServerMove
    (
        NewMove.TimeStamp,
        NewMove.Acceleration * 10,
        MoveLoc,
        NewMove.bRun,
        NewMove.bDuck,
        bPendingJumpStatus,
        bJumpStatus,
        NewMove.bDoubleJump,
        NewMove.DoubleClickMove,
        ClientRoll,
        (32767 & (Rotation.Pitch/2)) * 32768 + (32767 & (Rotation.Yaw/2)),
        OldTimeDelta,
        OldAccel
    );
	PendingMove = None;
}

// Get the next free move, maintaining a maximum of MaxSavedMoves.
//
// The original GetFreeMove() function limits saved move history to 100
// elements. Unfortunately, this causes rubberbanding on high fps due to the
// loss of saved move history. Since GetFreeMove() is marked final, we must
// reimplement it and it's callers.
function SavedMove GetFreeMoveEx() {
    local SavedMove s, first;
    local int i;

    if ( FreeMoves == None )
    {
        // don't allow more than MaxSavedMoves
        For ( s=SavedMoves; s!=None; s=s.NextMove )
        {
            i++;
            if ( i > MaxSavedMoves )
            {
                if (Level.TimeSeconds > LastSavedMovesWarning + SavedMovesWarningInterval)
                {
                    log("Exceeded max saved moves ("$MaxSavedMoves$"), consider increasing", Class.Name);
                    LastSavedMovesWarning = Level.TimeSeconds;
                }

                first = SavedMoves;
                SavedMoves = SavedMoves.NextMove;
                first.Clear();
                first.NextMove = None;
                // clear out all the moves
                While ( SavedMoves != None )
                {
                    s = SavedMoves;
                    SavedMoves = SavedMoves.NextMove;
                    s.Clear();
                    s.NextMove = FreeMoves;
                    FreeMoves = s;
                }
                return first;
            }
        }
        return Spawn(class'SavedMove');
    }
    else
    {
        s = FreeMoves;
        FreeMoves = FreeMoves.NextMove;
        s.NextMove = None;
        return s;
    }
}

defaultproperties
{
    MaxSavedMoves=750
    SavedMovesWarningInterval=5.0
    LastSavedMovesWarning=0
}
