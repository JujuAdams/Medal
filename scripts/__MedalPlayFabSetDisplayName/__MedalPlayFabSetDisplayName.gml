function __MedalPlayFabSetDisplayName(_name)
{
    static _system = __MedalSystem();
    static _headerMap = ds_map_create();
    
    _headerMap[? "Content-Type"   ] = "application/json";
    _headerMap[? "X-Authorization"] = _system.__playFabSessionTicket;
      
    var _bodyString = __MedalPlayFabJSONStringify({
        DisplayName: _name,
    });
    
    var _result = http_request($"https://{MEDAL_PLAYFAB_TITLE_ID}.playfabapi.com/Client/UpdateUserTitleDisplayName", "POST", _headerMap, _bodyString);
    
    ds_map_clear(_headerMap);
    return _result;
}