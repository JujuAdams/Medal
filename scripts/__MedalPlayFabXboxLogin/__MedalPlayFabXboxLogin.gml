function __MedalPlayFabXboxLogin()
{
    static _system = __MedalSystem();
    static _headerMap = ds_map_create();
    
    _headerMap[? "Content-Type"   ] = "application/json";
    _headerMap[? "X-Authorization"] = _system.__playFabSessionTicket;
      
    var _bodyString = __MedalPlayFabJSONStringify({
        TitleId: MEDAL_PLAYFAB_TITLE_ID,
        CreateAccount: true,
        XboxToken: _system.__playFabToken,
    });
    
    _system.__playFabRequestToken = http_request($"https://{MEDAL_PLAYFAB_TITLE_ID}.playfabapi.com/Client/LoginWithXbox", "POST", _headerMap, _bodyString);
    
    ds_map_clear(_headerMap);
}