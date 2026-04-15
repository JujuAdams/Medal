/// @param leaderboardName

function MedalLbFind(_leaderboardName)
{
    static _leaderboardDict = __MedalSystem().__leaderboardDict;
    
    var _struct = _leaderboardDict[$ _leaderboardName];
    if (not is_struct(_struct))
    {
        __MedalSoftError($"Leaderboard name \"{_leaderboardName}\" not recognised");
        return undefined;
    }
    
    return _struct;
}