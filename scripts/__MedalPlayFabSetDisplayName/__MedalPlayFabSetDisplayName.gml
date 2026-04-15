/// @param name

function __MedalPlayFabSetDisplayName(_name)
{
    static _system = __MedalSystem();
    static _headerMap = ds_map_create();
    
    if (not _system.__playFabLoggedIn)
    {
        __MedalWarning("Cannot set display name, not logged into PlayFab");
    }
    
    __MedalEnsureControllerInstance();
    
    _headerMap[? "Content-Type"   ] = "application/json";
    _headerMap[? "X-Authorization"] = _system.__playFabSessionTicket;
      
    var _bodyString = __MedalPlayFabJSONStringify({
        DisplayName: _name,
    });
    
    if (MEDAL_VERBOSE)
    {
        __MedalTrace($"Updating PlayFab display name to \"{_name}\" from Xbox gamertag");
    }
    
    var _result = http_request($"https://{MEDAL_PLAYFAB_TITLE_ID}.playfabapi.com/Client/UpdateUserTitleDisplayName", "POST", _headerMap, _bodyString);
    ds_map_clear(_headerMap);
    
    if (MEDAL_VERBOSE)
    {
        __MedalRegisterHTTPAsyncID(_result, function(_abort)
        {
            var _responseHeaderMap = async_load[? "response_headers"];
            var _httpStatus        = async_load[? "http_status"     ];
            var _url               = async_load[? "url"             ];
            var _resultString      = async_load[? "result"          ];
            
            var _resultJSON = __MedalPlayFabJSONParse(_resultString);
            if (_resultJSON == undefined) return;
            
            if (_httpStatus != 200)
            {
                __MedalWarning($"PlayFab display name set received unexpected HTTP status {_httpStatus}");
            }
            else
            {
                __MedalTrace($"PlayFab display name set received HTTP 200 response");
            }
            
            show_debug_message("Result JSON = \n" + json_stringify(_resultJSON, true));
        });
    }
    
    return _result;
}