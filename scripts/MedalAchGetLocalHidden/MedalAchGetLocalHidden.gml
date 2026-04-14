/// Returns whether the given achievement is hidden by default. This is useful when creating
/// custom achievement systems and you'd like to label certain achievements as secret until they
/// are unlocked.
/// 
/// @param medalIndex

function MedalAchGetLocalHidden(_medalIndex)
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