/// Returns whether a locally stored achievement has been unlocked or not.
/// 
/// @param allchIndex

function AllchGetLocalState(_allchIndex)
{
    static _system        = __AllchSystem();
    static _allchToRefMap = _system.__allchToRefMap;
    
    if (not _system.__local)
    {
        if (ALLCH_RUNNING_FROM_IDE)
        {
            __AllchWarning("Cannot get state, not using locally stored data");
        }
        
        return false;
    }
    
    var _struct = _allchToRefMap[? _allchIndex];
    if (_struct == undefined)
    {
        __AllchSoftError($"Allch index {_allchIndex} not recognised");
        return false;
    }
    
    return _system.__localData[$ _struct.__serviceRef] ?? false;
}