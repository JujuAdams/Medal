/// @param tokenAndSignature

function __MedalPlayFabXboxLogin(_tokenAndSignature)
{
    static _system = __MedalSystem();
    static _headerMap = ds_map_create();
    
    __MedalEnsureControllerInstance();
    
    _headerMap[? "Content-Type"   ] = "application/json";
    _headerMap[? "X-Authorization"] = _system.__playFabSessionTicket;
      
    var _bodyString = __MedalPlayFabJSONStringify({
        TitleId: MEDAL_PLAYFAB_TITLE_ID,
        CreateAccount: true,
        XboxToken: _tokenAndSignature,
    });
    
    if (MEDAL_VERBOSE)
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalTrace($"Requesting PlayFab login using Xbox token \"{_tokenAndSignature}\"");
        }
        else
        {
            __MedalTrace($"Requesting PlayFab login using Xbox token");
        }
    }
    
    var _result = http_request($"https://{MEDAL_PLAYFAB_TITLE_ID}.playfabapi.com/Client/LoginWithXbox", "POST", _headerMap, _bodyString);
    ds_map_clear(_headerMap);
    
    __MedalRegisterHTTPAsyncID(_result, function(_aborted)
    {
        var _responseHeaderMap = async_load[? "response_headers"];
        var _httpStatus        = async_load[? "http_status"     ];
        var _url               = async_load[? "url"             ];
        var _resultString      = async_load[? "result"          ];
    
        var _resultJSON = __MedalPlayFabJSONParse(_resultString);
        if (_resultJSON == undefined) return;
        
        if (_httpStatus != 200)
        {
            __MedalWarning($"PlayFab login using Xbox received unexpected HTTP status {_httpStatus}");
            
            if (MEDAL_VERBOSE)
            {
                show_debug_message("Result JSON = \n" + json_stringify(_resultJSON, true));
            }
        }
        else
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace($"PlayFab login using Xbox received response");
            }
            
            try
            {
                var _sessionTicket = _resultJSON.data.SessionTicket;
                var _playFabID     = _resultJSON.data.PlayFabId;
                var _entityToken   = _resultJSON.data.EntityToken.EntityToken;
                var _entityType    = _resultJSON.data.EntityToken.Entity.Type;
                
                if (_entityType != "title_player_account")
                {
                    throw $"Entity type was \"{_entityType}\", expecting \"title_player_account\"";
                }
            }
            catch(_error)
            {
                show_debug_message(_error);
                __MedalSoftError("PlayFab HTTP response did not confirm to expected format");
                return;
            }
            
            with(__MedalSystem())
            {
                __playFabLoggedIn      = true;
                __playFabSessionTicket = _sessionTicket;
                __playFabEntityToken   = _entityToken;
            }
            
            if (MEDAL_VERBOSE)
            {
                __MedalTrace("Received PlayFab session ticket and entity token successfully");
            }
            
            __MedalPlayFabSetDisplayName(xboxone_modern_gamertag_for_user(__MedalSystem().__xboxUser));
        }
    });
}