class TAM_Warmup extends UTComp_Warmup;

function ResetStats()
{
    local Misc_PRI mPRI;

    super.ResetStats();

    foreach dynamicactors(class'Misc_PRI', mPRI)
        mPRI.ResetStats();
}

defaultproperties
{
}