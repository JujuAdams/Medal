function __MedalPlayFabJSONParse(_string)
{
    var _json = undefined;
    
    try
    {
        _json = json_parse(_string);
    }
    catch(_error)
    {
        show_debug_message(_error);
        __MedalSoftError("Failed to parse PlayFab HTTP response");
    }
    
    return _json;
}