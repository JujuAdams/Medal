/// Returns whether the given achievement is hidden by default. This is useful when creating
/// custom achievement systems and you'd like to label certain achievements as secret until they
/// are unlocked.
/// 
/// @param allchIndex

function AllchGetLocalHidden(_allchIndex)
{
    static _allchToRefMap = __AllchSystem().__allchToRefMap;
    
    var _struct = _allchToRefMap[? _allchIndex];
    if (_struct == undefined)
    {
        __AllchSoftError($"Allch index {_allchIndex} not recognised");
        return true;
    }
    
    return _struct.__hidden;
}