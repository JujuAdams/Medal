/// Returns whether a locally stored achievement has been unlocked or not.
/// 
/// @param achievementIndex

function AllchGetLocalState(_achievementIndex)
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
    
    var _struct = _allchToRefMap[? _achievementIndex];
    if (_struct == undefined)
    {
        __AllchSoftError($"Achievement {_achievementIndex} not recognised");
        return false;
    }
    
    return _system.__localData[$ _struct.__serviceRef] ?? false;
}