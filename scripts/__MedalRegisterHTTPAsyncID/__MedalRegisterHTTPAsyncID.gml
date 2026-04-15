/// @param asyncID
/// @param callbackFunction

function __MedalRegisterHTTPAsyncID(_asyncID, _callbackFunction)
{
    static _asyncIDMap = __MedalSystem().__httpAsyncIDMap;
    
    if (_asyncID == undefined)
    {
        __MedalSoftError("Async ID must be an integer. Please report this error");
        return;
    }
    
    if (not is_callable(_callbackFunction))
    {
        __MedalSoftError("Callback must be a valid function or script");
        return;
    }
    
    __MedalEnsureControllerInstance();
    
    if (ds_map_exists(_asyncIDMap, _callbackFunction))
    {
        __MedalWarning($"Redefining async ID {_asyncID}");
        
        var _oldCallbackFunction = _asyncIDMap[? _asyncID];
        _oldCallbackFunction(true);
    }
    
    _asyncIDMap[? _asyncID] = _callbackFunction;
}