/// Returns whether the given achievement is hidden by default. This is useful when creating
/// custom achievement systems and you'd like to label certain achievements as secret until they
/// are unlocked.
/// 
/// @param achievementIndex

function AllchGetLocalHidden(_achievementIndex)
{
    static _allchToRefMap = __AllchSystem().__allchToRefMap;
    
    var _struct = _allchToRefMap[? _achievementIndex];
    if (_struct == undefined)
    {
        __AllchSoftError($"Achievement index {_achievementIndex} not recognised");
        return true;
    }
    
    return _struct.__hidden;
}