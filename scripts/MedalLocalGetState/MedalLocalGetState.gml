/// @param medalIndex

function MedalLocalGetState(_medalIndex)
{
    static _system        = __MedalSystem();
    static _medalToRefMap = _system.__medalToRefMap;
    
    if (not _system.__local)
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalTrace($"Warning! Cannot get state, not using locally stored data          {debug_get_callstack()}");
        }
        
        return false;
    }
    
    var _struct = _medalToRefMap[? _medalIndex];
    if (_struct == undefined)
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalError($"Medal index {_medalIndex} not recognised");
        }
        else
        {
            __MedalTrace($"Warning! Medal index {_medalIndex} not recognised          {debug_get_callstack()}");
        }
        
        return false;
    }
    
    return _system.__localData[$ _struct.__serviceRef] ?? false;
}