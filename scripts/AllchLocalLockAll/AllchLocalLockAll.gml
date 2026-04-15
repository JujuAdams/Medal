/// Locks all achievements. This only applies to locally stored achievements. This is helpful for
/// testing.

function AllchLocalLockAll()
{
    static _system = __AllchSystem();
    
    if (not _system.__local)
    {
        if (ALLCH_RUNNING_FROM_IDE)
        {
            __AllchWarning($"Cannot unaward all allchs, this feature is only available for local data");
        }
        
        return;
    }
    
    if (struct_names_count(_system.__localData) > 0)
    {
        if (ALLCH_VERBOSE)
        {
            __AllchTrace($"Unawarding all allchs");
        }
        
        _system.__localData = {};
        _system.__localChanged = true;
    }
    else
    {
        if (ALLCH_VERBOSE)
        {
            __AllchTrace($"Unawarding all allchs but player doesn't have any");
        }
    }
}