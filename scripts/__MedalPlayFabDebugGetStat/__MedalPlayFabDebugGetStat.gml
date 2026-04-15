/// @param statName
/// @param [callback]

function __MedalPlayFabDebugGetStat(_statisticName, _callback = undefined)
{
    static _system = __MedalSystem();
    static _headerMap = ds_map_create();
    
    if (not _system.__playFabLoggedIn)
    {
        __MedalWarning("Cannot get statistic, not logged into PlayFab");
    }
    
    __MedalEnsureControllerInstance();
    
    _headerMap[? "Content-Type" ] = "application/json";
    _headerMap[? "X-EntityToken"] = _system.__playFabEntityToken;
      
    var _bodyString = __MedalPlayFabJSONStringify({
        StatisticNames: [_statisticName],
    });
    
    var _result = http_request($"https://{MEDAL_PLAYFAB_TITLE_ID}.playfabapi.com/Statistic/GetStatistics", "POST", _headerMap, _bodyString);
    ds_map_clear(_headerMap);
    
    __MedalRegisterHTTPAsyncID(_result, method({
        __callback: _callback,
    },
    function(_abort)
    {
        var _responseHeaderMap = async_load[? "response_headers"];
        var _httpStatus        = async_load[? "http_status"     ];
        var _url               = async_load[? "url"             ];
        var _resultString      = async_load[? "result"          ];
    
        var _resultJSON = __MedalPlayFabJSONParse(_resultString);
        if (_resultJSON == undefined)
        {
            if (is_callable(__callback))
            {
                __callback(undefined);
            }
            
            return;
        }
        
        if (_httpStatus != 200)
        {
            __MedalWarning($"PlayFab statistics get received unexpected HTTP status {_httpStatus}");
            
            if (MEDAL_VERBOSE)
            {
                show_debug_message("Result JSON = \n" + json_stringify(_resultJSON, true));
            }
        }
        else
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace($"PlayFab statistics get received response");
            }
            
            if (is_callable(__callback))
            {
                __callback(_resultJSON);
            }
        }
    }));
    
    return _result;
}