function __MedalPlayFabGetLeaderboard(_leaderboardName, _position, _count)
{
    static _system = __MedalSystem();
    static _headerMap = ds_map_create();
    
    _headerMap[? "Content-Type" ] = "application/json";
    _headerMap[? "X-EntityToken"] = _system.__playFabEntityToken;
    
    var _bodyString = __MedalPlayFabJSONStringify({
        StartingPosition: int64(_position),
        PageSize: int64(_count),
        LeaderboardName: _leaderboardName,
    });
    
    var _result = http_request($"https://{MEDAL_PLAYFAB_TITLE_ID}.playfabapi.com/Leaderboard/GetLeaderboard", "POST", _headerMap, _bodyString);
    
    ds_map_clear(_headerMap);
    return _result;
}