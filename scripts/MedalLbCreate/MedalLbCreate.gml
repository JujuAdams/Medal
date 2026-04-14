
/// Exactly what the `serviceRef` is depends on the platform. Please refer to platform/SDK
/// documentation for official information. However, the following is a brief guide:
/// 
/// Local Data:
///   `serviceRef` is a string. This will be used to store the state of the leaderboard when
///   exporting/importing JSON with Medal functions.
/// 
/// Steam:
///   `serviceRef` is a string that is the name of the leaderboard, as set in the Steamworks
///   backend.
/// 
/// PlayStation:
///   `serviceRef` is an integer that is the index of the leaderboard, as set in the backend.
/// 
/// Xbox / Windows GDK:
///   `serviceRef` is a string that is the stat identifier, as set in the backend.
/// 
/// Switch:
///   `serviceRef` is a struct that contains leaderboard identifiers, as set in the backend.
///   The struct should be in this format:
///   {
///       categoryTypeName: <string>,
///       categoryID: <integer>
///   }
/// 
/// iOS / GameCenter:
///   `serviceRef` is a string that is the leaderboard identifier, as set in the GameCenter
///   backend.
/// 
/// Android / Google Play Services:
///   `serviceRef` is a string that is the leaderboard identifier, as set in the Google Play
///   Services backend.
/// 
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
    
    //TODO - Add error checking for service reference inputs
    
    var _struct = new __MedalClassLeaderboard(_name, _serviceRef, _higherValueIsBetter, _refreshPeriod);
    _leaderboardDict[$ _name] = _struct;
    
    return _struct;
}