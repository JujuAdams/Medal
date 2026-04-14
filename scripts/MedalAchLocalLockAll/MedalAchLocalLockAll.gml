/// Locks all achievements. This only applies to locally stored achievements. This is helpful for
/// testing.

function MedalAchLocalLockAll()
{
    static _system = __MedalSystem();
    
    if (not _system.__local)
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalTrace($"Warning! Cannot unaward all medals, this feature is only available for local data          {debug_get_callstack()}");
        }
        
        return;
    }
    
    if (struct_names_count(_system.__localData) > 0)
    {
        if (MEDAL_VERBOSE)
        {
            __MedalTrace($"Unawarding all medals");
        }
        
        _system.__localData = {};
        _system.__localChanged = true;
    }
    else
    {
        if (MEDAL_VERBOSE)
        {
            __MedalTrace($"Unawarding all medals but player doesn't have any");
        }
    }
}