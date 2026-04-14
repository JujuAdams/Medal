/// Defines a link between a medal index and outside data storage. This function should only be
/// called in one of the Medal configuration scripts (`__MedalDefinitionsSteam` etc.). The medal
/// index should be a member of `MEDAL` enum defined in `__MedalConfig`.
/// 
/// N.B. When adding or modifying a medal you must propagate those changes to every configuration
///      script. Failing to update every configuration script to reflect changes made to your
///      game's achievement will result in errors.
/// 
/// Exactly what the `serviceRef` is depends on the platform. Please refer to platform/SDK
/// documentation for official information. However, the following is a brief guide:
/// 
/// Local Storage:
///   `serviceRef` is a string. This will be used to store the state of the achievement when
///   exporting/importing JSON with Medal functions.
/// 
/// Steam:
///   `serviceRef` is a string that is the name of the achievement, as set in the Steamworks
///   backend.
/// 
/// PlayStation:
///   `serviceRef` is an integer that is the index of the trophy, as set in the UDS backend. Since
///   a platinum trophy is usually index `0`, trophy indexes tend to start at `1`.
/// 
/// Xbox:
///   `serviceRef` is a string that is the achievement index but as a string. For example,
///   achievement index `12` would have the service reference `"12"`.
/// 
/// Switch:
///   Nintendo Switch has no native achievement system. Instead, Medal will fall back on using
///   local storage. Please see "Local Storage" above.
/// 
/// iOS:
///   `serviceRef` is a string that is the achievement identifier, as set in the GameCenter
///   backend.
/// 
/// Android:
///   `serviceRef` is a string that is the achievement identifier, as set in the Google Play
///   Services backend.
/// 
/// @param medalIndex
/// @param serviceRef
/// @param [hidden=false]

function MedalDefine(_medalIndex, _serviceRef, _hidden = false)
{
    static _medalToRefMap = __MedalSystem().__medalToRefMap;
    
    if (MEDAL_VERBOSE)
    {
        __MedalTrace($"Defining medal {_medalIndex} for service reference `{_serviceRef}`, hidden = {_hidden? "true" : "false"}");
    }
    
    if (ds_map_exists(_medalToRefMap, _medalIndex))
    {
        var _struct = _medalToRefMap[? _medalIndex];
        if ((_struct.__serviceRef != _serviceRef) || (_struct.__hidden != _hidden))
        {
            if (MEDAL_RUNNING_FROM_IDE)
            {
                __MedalError($"Overwriting medal {_medalIndex} (service reference `{_serviceRef}`). Please ensure that `MedalDefine()` is called once and once only per medal index\nIf you are using `game_restart()`, don't");
            }
        }
        
        return;
    }
    
    _medalToRefMap[? _medalIndex] = {
        __serviceRef: _serviceRef,
        __hidden: _hidden,
    };
}