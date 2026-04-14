/// N.B. You must call `MedalSetPSGamepad()` or `MedalSetXboxUser()` before pushing scores to
///      leaderboards on PlayStation or Xbox.
/// 
/// N.B. Medal does not call `steam_update()` for you when using Steam. You must call this function
///      yourself.
/// 
/// N.B. Medal does not call `psn_tick()` or `psn_init_leaderboard()` for you when running on
///      PlayStation. You must call these functions yourself.
/// 
/// N.B. Medal does not call `gdk_init()`, `gdk_update()`, or `gdk_quit()` for you when running on
///      Xbox. You must call these functions yourself.
///
/// @param name
/// @param serviceRef
/// @param [higherValueIsBetter=true]
/// @param [refreshPeriod=never]

function MedalLbCreate(_name, _serviceRef, _higherValueIsBetter = true, _refreshPeriod = MEDAL_REFRESH_NEVER)
{
    static _leaderboardDict = __MedalSystem().__leaderboardDict;
    
    if (struct_exists(_leaderboardDict, _name))
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalError($"Overwriting leaderboard \"{_name}\" (service reference \"{_serviceRef}\"). Please ensure that `MedalLbCreate()` is called once and once only per leaderboard name\nIf you are using `game_restart()`, don't");
        }
        
        return;
    }
    
    var _struct = new __MedalClassLeaderboard(_name, _serviceRef, _higherValueIsBetter, _refreshPeriod);
    _leaderboardDict[$ _name] = _struct;
    
    return _struct;
}