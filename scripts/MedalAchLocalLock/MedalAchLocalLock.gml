/// Locks an achievement that the player has previously unlocked. This only applies to locally
/// stored achievements.
/// 
/// @param medalIndex

function MedalAchLocalLock(_medalIndex)
{
    static _system       = __MedalSystem();
    static _medalToRefMap = _system.__medalToRefMap;
    
    if (not _system.__local)
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalWarning($"Cannot unaward medal, this feature is only available for local data          {debug_get_callstack()}");
        }
        
        return;
    }
    
    var _struct = _medalToRefMap[? _medalIndex];
    if (_struct == undefined)
    {
        __MedalSoftError($"Medal index {_medalIndex} not recognised");
        return;
    }
    
    var _ref = _struct.__serviceRef;
    if (_system.__localData[$ _ref] != false)
    {
        if (MEDAL_VERBOSE)
        {
            __MedalTrace($"Unawarding medal {_medalIndex} (service reference `{_ref}`)");
        }
        
        _system.__localData[$ _ref] = false;
        _system.__localChanged = true;
    }
    else
    {
        if (MEDAL_VERBOSE)
        {
            __MedalTrace($"Unawarding medal {_medalIndex} but player doesn't have it (service reference `{_ref}`)");
        }
    }
}