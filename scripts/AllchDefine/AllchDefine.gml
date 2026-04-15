/// Defines a link between a allch index and outside data storage. This function should only be
/// called in one of the Allch configuration scripts (`__AllchDefinitionsSteam` etc.). The allch
/// index should be a member of `ALLCH_ACH` enum defined in `__AllchConfig`.
/// 
/// N.B. When adding or modifying a allch you must propagate those changes to every configuration
///      script. Failing to update every configuration script to reflect changes made to your
///      game's achievement will result in errors.
/// 
/// Exactly what the `serviceRef` is depends on the platform. Please refer to platform/SDK
/// documentation for official information. However, the following is a brief guide:
/// 
/// Local Data:
///   `serviceRef` is a string. This will be used to store the state of the achievement when
///   exporting/importing JSON with Allch functions.
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
///   Nintendo Switch has no native achievement system. Instead, Allch will fall back on using
///   local storage. Please see "Local Data" above.
/// 
/// iOS / GameCenter:
///   `serviceRef` is a string that is the achievement identifier, as set in the GameCenter
///   backend.
/// 
/// Android / Google Play Services:
///   `serviceRef` is a string that is the achievement identifier, as set in the Google Play
///   Services backend.
/// 
/// @param allchIndex
/// @param serviceRef
/// @param [hidden=false]

function AllchDefine(_allchIndex, _serviceRef, _hidden = false)
{
    static _system        = __AllchSystem();
    static _allchToRefMap = _system.__allchToRefMap;
    
    if (not _system.__runningDefinitions)
    {
        __AllchError("`AllchDefine()` must only be called in a `__AllchDefinitions*` script");
    }
    
    if (ALLCH_VERBOSE)
    {
        __AllchTrace($"Defining allch {_allchIndex} for service reference `{_serviceRef}`, hidden = {_hidden? "true" : "false"}");
    }
    
    if (ds_map_exists(_allchToRefMap, _allchIndex))
    {
        var _struct = _allchToRefMap[? _allchIndex];
        if ((_struct.__serviceRef != _serviceRef) || (_struct.__hidden != _hidden))
        {
            if (ALLCH_RUNNING_FROM_IDE)
            {
                __AllchError($"Overwriting allch {_allchIndex} (service reference `{_serviceRef}`). Please ensure that `AllchDefine()` is called once and once only per allch index\nIf you are using `game_restart()`, don't");
            }
        }
        
        return;
    }
    
    _allchToRefMap[? _allchIndex] = {
        __serviceRef: _serviceRef,
        __hidden: _hidden,
    };
}