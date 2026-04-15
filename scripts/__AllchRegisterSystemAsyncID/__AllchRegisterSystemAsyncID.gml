/// @param asyncID
/// @param callbackFunction

function __AllchRegisterSystemAsyncID(_asyncID, _callbackFunction)
{
    static _asyncIDMap = __AllchSystem().__steamAsyncIDMap;
    
    if (_asyncID == undefined)
    {
        __AllchSoftError("Async ID must be an integer. Please report this error");
        return;
    }
    
    if (not is_callable(_callbackFunction))
    {
        __AllchSoftError("Callback must be a valid function or script");
        return;
    }
    
    __AllchEnsureControllerInstance();
    
    if (ds_map_exists(_asyncIDMap, _callbackFunction))
    {
        __AllchWarning($"Redefining async ID {_asyncID}");
        
        var _oldCallbackFunction = _asyncIDMap[? _asyncID];
        _oldCallbackFunction(true);
    }
    
    _asyncIDMap[? _asyncID] = _callbackFunction;
}