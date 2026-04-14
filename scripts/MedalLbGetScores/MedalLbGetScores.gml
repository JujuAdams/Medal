/// N.B. You must call `MedalSetPSGamepad()` or `MedalSetXboxUser()` before getting scores from
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
/// @param leaderboardName
/// @param [range=top]

function MedalLbGetScores(_leaderboardName, _range = MEDAL_RANGE_TOP)
{
    with(MedalLbFind(_leaderboardName))
    {
        return GetScores(_range);
    }
    
    return undefined;
}