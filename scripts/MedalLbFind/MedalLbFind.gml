/// @param leaderboardName

function MedalLbFind(_leaderboardName)
{
    static _leaderboardDict = __MedalSystem().__leaderboardDict;
    
    var _struct = _leaderboardDict[$ _leaderboardName];
    if (not is_struct(_struct))
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalError($"Leaderboard name \"{_leaderboardName}\" not recognised");
        }
        else
        {
            __MedalTrace($"Warning! Medal index {_leaderboardName} not recognised          {debug_get_callstack()}");
        }
        
        return undefined;
    }
    
    return _struct;
}