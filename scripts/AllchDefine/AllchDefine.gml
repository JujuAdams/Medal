/// Defines a link between an achievement index and outside data storage. This function should only
/// be called in one of the definitions scripts (`__AllchDefinitionsSteam` etc.). The achievement
/// index should be a member of `ALLCH_ACH` enum defined in `__AllchConfig`.
/// 
/// N.B. When adding a new definition or modifying an existing definition you must propagate those
///      changes to every configuration script. Failing to update every configuration script to
///      reflect changes made to your game's achievement will result in errors.
/// 
/// Exactly what the `serviceRef` is depends on the platform. Please refer to platform/SDK
/// documentation for official information. However, the following is a brief guide:
/// 
/// Local Data:
///   `serviceRef` is a string. This will be used to store the state of the achievement when
///   exporting/importing JSON with Allchievements functions.
/// 
/// Steam:
///   `serviceRef` is a string that is the name of the achievement, as set in the Steamworks
///   backend.
/// 
/// PlayStation:
///   `serviceRef` is an integer that is the index of the trophy, as set in the UDS backend. Since
///   a platinum trophy is usually index `0`, trophy indexes tend to start at `1`.
/// 
/// Xbox / Windows GDK:
///   `serviceRef` is a string that is the achievement index but as a string. For example,
///   achievement index `12` would have the service reference `"12"`.
/// 
/// Switch:
///   Nintendo Switch has no native achievement system. Instead, Allchievements will fall back on
///   using local storage. Please see "Local Data" above.
/// 
/// iOS / GameCenter:
///   `serviceRef` is a string that is the achievement identifier, as set in the GameCenter
///   backend.
/// 
/// Android / Google Play Services:
///   `serviceRef` is a string that is the achievement identifier, as set in the Google Play
///   Services backend.
/// 
/// @param achievementIndex
/// @param serviceRef
/// @param [hidden=false]

function AllchDefine(_achievementIndex, _serviceRef, _hidden = false)
{
    static _system        = __AllchSystem();
    static _allchToRefMap = _system.__allchToRefMap;
    
    if (not _system.__runningDefinitions)
    {
        __AllchError("`AllchDefine()` must only be called in a `__AllchDefinitions*` script");
    }
    
    if (ALLCH_VERBOSE)
    {
        __AllchTrace($"Defining achievement {_achievementIndex} for service reference `{_serviceRef}`, hidden = {_hidden? "true" : "false"}");
    }
    
    if (ds_map_exists(_allchToRefMap, _achievementIndex))
    {
        var _struct = _allchToRefMap[? _achievementIndex];
        if ((_struct.__serviceRef != _serviceRef) || (_struct.__hidden != _hidden))
        {
            if (ALLCH_RUNNING_FROM_IDE)
            {
                __AllchError($"Overwriting achievement {_achievementIndex} (service reference `{_serviceRef}`). Please ensure that `AllchDefine()` is called once and once only per achievement index\nIf you are using `game_restart()`, don't");
            }
        }
        
        return;
    }
    
    _allchToRefMap[? _achievementIndex] = {
        __serviceRef: _serviceRef,
        __hidden: _hidden,
    };
}