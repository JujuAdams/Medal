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