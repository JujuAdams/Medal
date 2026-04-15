function __MedalPlayFabSetStatistic(_statisticName, _value)
{
    static _system = __MedalSystem();
    static _headerMap = ds_map_create();
    
    _headerMap[? "Content-Type" ] = "application/json";
    _headerMap[? "X-EntityToken"] = _system.__playFabEntityToken;
      
    var _bodyString = __MedalPlayFabJSONStringify({
        Statistics: [
            {
                Name: _statisticName,
                Scores: [
                    int64(_value),
                ],
            },
        ],
    });
    
    var _result = http_request($"https://{MEDAL_PLAYFAB_TITLE_ID}.playfabapi.com/Statistic/UpdateStatistics", "POST", _headerMap, _bodyString);
    
    ds_map_clear(_headerMap);
    return _result;
}