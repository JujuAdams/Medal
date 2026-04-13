/// @param medalIndex

function MedalLocalGetHidden(_medalIndex)
{
    static _medalToRefMap = __MedalSystem().__medalToRefMap;
    
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
        
        return true;
    }
    
    return _struct.__hidden;
}