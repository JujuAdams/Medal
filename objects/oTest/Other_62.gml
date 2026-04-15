show_debug_message($"HTTP: {json_encode(async_load, true)}");

if (MEDAL_USING_PLAYFAB_LEADERBOARDS)
{
    var _id                = async_load[? "id"              ];
    var _responseHeaderMap = async_load[? "response_headers"];
    var _httpStatus        = async_load[? "http_status"     ];
    var _url               = async_load[? "url"             ];
    var _status            = async_load[? "status"          ];
    var _resultString      = async_load[? "result"          ];
    
    if (_status == 0)
    {
        var _resultJSON = __MedalPlayFabJSONParse(_resultString);
        if (_resultJSON == undefined) return;
        
        if (_id == __MedalSystem().__playFabRequestToken)
        {
            if (_httpStatus == 200)
            {
                var _sessionTicket = undefined;
                var _playFabID     = undefined;
                var _entityType    = undefined;
                
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
                
                __MedalSystem().__playFabSessionTicket = _sessionTicket;
                __MedalSystem().__playFabEntityToken   = _entityToken;
                
                if (MEDAL_VERBOSE)
                {
                    __MedalTrace("Received PlayFab session ticket and entity token successfully");
                }
                
                __MedalPlayFabSetDisplayName(xboxone_modern_gamertag_for_user(__MedalSystem().__xboxUser));
                
                __MedalPlayFabSetStatistic("testStatistic", 7);
                __MedalPlayFabSetStatistic("testHourlyStatistic", 7);
                __MedalPlayFabSetStatistic("testDailyStatistic", 7);
                
                __MedalPlayFabGetStatistic("testStatistic");
                __MedalPlayFabGetStatistic("testHourlyStatistic");
                __MedalPlayFabGetStatistic("testDailyStatistic");
                
                __MedalPlayFabGetLeaderboard("testLeaderboard", 1, 10);
                __MedalPlayFabGetLeaderboard("testHourlyLeaderboard", 1, 10);
                __MedalPlayFabGetLeaderboard("testDailyLeaderboard", 1, 10);
            }
        }
        //else if (_id == __playFabRequestSetStatistic)
        //{
        //    show_debug_message(json_stringify(_resultJSON, true));
        //}
        //else if (_id = __playFabRequestGetStatistic)
        //{
        //    show_debug_message(json_stringify(_resultJSON, true));
        //}
        //else if (_id == __playFabRequestGetLeaderboard)
        //{
        //    show_debug_message(json_stringify(_resultJSON, true));
        //}
    }
}