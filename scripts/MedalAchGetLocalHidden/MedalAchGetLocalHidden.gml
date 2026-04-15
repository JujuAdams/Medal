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
        __MedalSoftError($"Medal index {_medalIndex} not recognised");
        return true;
    }
    
    return _struct.__hidden;
}