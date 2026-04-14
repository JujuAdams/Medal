/// @param asyncID
/// @param callbackFunction

function __MedalRegisterAsyncID(_asyncID, _callbackFunction)
{
    static _asyncIDMap = __MedalSystem().__asyncIDMap;
    
    if (not is_callable(_callbackFunction))
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalError("Callback must be a valid function or script");
        }
        else
        {
            __MedalTrace("Warning! Callback must be a valid function or script");
        }
        
        return;
    }
    
    __MedalEnsureControllerInstance();
    
    if (ds_map_exists(_asyncIDMap, _callbackFunction))
    {
        __MedalTrace($"Warning! Redefining async ID {_asyncID}");
        
        var _oldCallbackFunction = _asyncIDMap[? _asyncID];
        _oldCallbackFunction(true);
    }
    
    _asyncIDMap[? _asyncID] = _callbackFunction;
}