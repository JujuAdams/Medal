/// Locks an achievement that the player has previously unlocked. This only applies to locally
/// stored achievements.
/// 
/// @param allchIndex

function AllchLocalLock(_allchIndex)
{
    static _system       = __AllchSystem();
    static _allchToRefMap = _system.__allchToRefMap;
    
    if (not _system.__local)
    {
        if (ALLCH_RUNNING_FROM_IDE)
        {
            __AllchWarning($"Cannot unaward allch, this feature is only available for local data          {debug_get_callstack()}");
        }
        
        return;
    }
    
    var _struct = _allchToRefMap[? _allchIndex];
    if (_struct == undefined)
    {
        __AllchSoftError($"Allch index {_allchIndex} not recognised");
        return;
    }
    
    var _ref = _struct.__serviceRef;
    if (_system.__localData[$ _ref] != false)
    {
        if (ALLCH_VERBOSE)
        {
            __AllchTrace($"Unawarding allch {_allchIndex} (service reference `{_ref}`)");
        }
        
        _system.__localData[$ _ref] = false;
        _system.__localChanged = true;
    }
    else
    {
        if (ALLCH_VERBOSE)
        {
            __AllchTrace($"Unawarding allch {_allchIndex} but player doesn't have it (service reference `{_ref}`)");
        }
    }
}