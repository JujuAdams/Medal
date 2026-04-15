/// Returns whether a locally stored achievement has been unlocked or not.
/// 
/// @param medalIndex

function MedalAchGetLocalState(_medalIndex)
{
    static _system        = __MedalSystem();
    static _medalToRefMap = _system.__medalToRefMap;
    
    if (not _system.__local)
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalWarning("Cannot get state, not using locally stored data");
        }
        
        return false;
    }
    
    var _struct = _medalToRefMap[? _medalIndex];
    if (_struct == undefined)
    {
        __MedalSoftError($"Medal index {_medalIndex} not recognised");
        return false;
    }
    
    return _system.__localData[$ _struct.__serviceRef] ?? false;
}