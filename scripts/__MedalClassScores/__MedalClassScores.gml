/// @param scoresID
/// @param formattedServiceRef
/// @param range
/// @param refreshPeriod

function __MedalClassScores(_scoresID, _formattedServiceRef, _range, _refreshPeriod) constructor
{
    static _system = __MedalSystem();
    
    __scoresID            = _scoresID;
    __formattedServiceRef = _formattedServiceRef;
    __range               = _range;
    __refreshPeriod       = _refreshPeriod;
    __state               = MEDAL_LB_STATE_NO_DATA;
    __lastRequestTime     = -infinity;
    __asyncID             = undefined;
    __data                = [];
    
    
    
    static __GetScoresContinuous = function()
    {
        if (not MEDAL_LB_DISRESPECT_RATE_LIMITS)
        {
            if (current_time - __lastRequestTime < 5*60_000) //Every five minutes
            {
                //Requested too soon, on cooldown
                return;
            }
        }
        
        return __GetScoresInternal(false);
    }
    
    static __Refresh = function()
    {
        if (not MEDAL_LB_DISRESPECT_RATE_LIMITS)
        {
            if (current_time - __lastRequestTime < 5_000) //Every five seconds
            {
                if (MEDAL_VERBOSE)
                {
                    __MedalTrace($"Cannot refresh, service ref \"{__formattedServiceRef}\" on cooldown ({5_000 - (current_time - __lastRequestTime)}ms left)");
                }
                
                //Requested too soon, on cooldown
                return;
            }
        }
        
        return __GetScoresInternal(true);
    }
    
    static __GetScoresInternal = function(_refresh)
    {
        if (__asyncID != undefined)
        {
            //Pending
            return;
        }
        
        if (_system.__local)
        {
            //TODO
        }
        else
        {
            if (_system.__steamAvailable)
            {
                ///////
                // Steam
                ///////
                
                if (__range == MEDAL_RANGE_TOP)
                {
                    __asyncID = steam_download_scores(__formattedServiceRef, 1, 10);
                }
                else if (__range == MEDAL_RANGE_FRIENDS)
                {
                    __asyncID = steam_download_friends_scores(__formattedServiceRef);
                }
                else if (__range == MEDAL_RANGE_AROUND)
                {
                    __asyncID = steam_download_scores_around_user(__formattedServiceRef, -5, 5);
                }
                
                __MedalRegisterAsyncID(__asyncID, function(_aborted)
                {
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                    }
                    
                    __asyncID = undefined;
                    
                    if (async_load[? "event_type"] != "leaderboard_download")
                    {
                        __MedalTrace($"Warning! Received unexpected leaderboard event type \"{async_load[? "event_type"]}\", aborting");
                        _aborted = true;
                    }
                    
                    if (async_load[? "status"] != 0)
                    {
                        __MedalTrace($"Warning! Received unexpected leaderboard status `{async_load[? "status"]}`, aborting");
                        _aborted = true;
                    }
                    
                    var _json = undefined;
                    try
                    {
                        _json = json_parse(async_load[? "entries"]);
                        if (not is_array(_json.entries)) throw -123;
                    }
                    catch(_error)
                    {
                        __MedalTrace($"Warning! Failed to parse returned leaderboard data");
                        
                        _json = undefined;
                        _aborted = true;
                    }
                    
                    if (_aborted)
                    {
                        __state = MEDAL_LB_STATE_ERROR;
                    }
                    else
                    {
                        __state = MEDAL_LB_STATE_SUCCESS;
                        __data = _json.entries;
                        
                        if (MEDAL_VERBOSE)
                        {
                            __MedalTrace($"Leaderboard data for \"{__formattedServiceRef}\" using range `{__range}` has {array_length(__data)} entries");
                        }
                    }
                });
            }
            else if (MEDAL_USING_GAMECENTER)
            {
                ///////
                // GameCenter
                ///////
                
                if (__refreshPeriod == MEDAL_REFRESH_NEVER)
                {
                    var _timeScope = GameCenter_Leaderboard_TimeScope_AllTime;
                }
                else if (__refreshPeriod == MEDAL_REFRESH_DAILY)
                {
                    var _timeScope = GameCenter_Leaderboard_TimeScope_Today;
                }
                else if (__refreshPeriod == MEDAL_REFRESH_WEEKLY)
                {
                    var _timeScope = GameCenter_Leaderboard_TimeScope_Week;
                }
                
                if ((__range == MEDAL_RANGE_TOP) || (__range == MEDAL_RANGE_AROUND))
                {
                    __asyncID = GameCenter_Leaderboard_LoadGlobal(__formattedServiceRef, _timeScope, 1, 10);
                }
                else if (__range == MEDAL_RANGE_FRIENDS)
                {
                    __asyncID = GameCenter_Leaderboard_LoadFriendsOnly(__formattedServiceRef, _timeScope, 1, 10);
                }
                
                __MedalRegisterAsyncID(__asyncID, function(_aborted)
                {
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                    }
                    
                    __asyncID = undefined;
                    
                    //TODO
                    
                    if (_aborted)
                    {
                        __state = MEDAL_LB_STATE_ERROR;
                    }
                    else
                    {
                        __state = MEDAL_LB_STATE_SUCCESS;
                    }
                });
            }
            else if (_system.__playServicesAvailable)
            {
                ///////
                // Google Play Services
                ///////
                
                if (__refreshPeriod == MEDAL_REFRESH_NEVER)
                {
                    var _timeScope = Leaderboard_TIME_SPAN_ALL_TIME;
                }
                else if (__refreshPeriod == MEDAL_REFRESH_DAILY)
                {
                    var _timeScope = Leaderboard_TIME_SPAN_DAILY;
                }
                else if (__refreshPeriod == MEDAL_REFRESH_WEEKLY)
                {
                    var _timeScope = Leaderboard_TIME_SPAN_WEEKLY;
                }
                
                if (__range == MEDAL_RANGE_TOP)
                {
                    __asyncID = GooglePlayServices_Leaderboard_LoadTopScores(__formattedServiceRef, _timeScope, Leaderboard_COLLECTION_PUBLIC, 10, _refresh);
                }
                else if (__range == MEDAL_RANGE_FRIENDS)
                {
                    __asyncID = GooglePlayServices_Leaderboard_LoadTopScores(__formattedServiceRef, _timeScope, Leaderboard_COLLECTION_SOCIAL, 10, _refresh);
                }
                else if (__range == MEDAL_RANGE_AROUND)
                {
                    __asyncID = GooglePlayServices_Leaderboard_LoadPlayerCenteredScores(__formattedServiceRef, _timeScope, Leaderboard_COLLECTION_PUBLIC, 10, _refresh);
                }
                
                __MedalRegisterAsyncID(__asyncID, function(_aborted)
                {
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                    }
                    
                    __asyncID = undefined;
                    
                    //TODO
                    
                    if (_aborted)
                    {
                        __state = MEDAL_LB_STATE_ERROR;
                    }
                    else
                    {
                        __state = MEDAL_LB_STATE_SUCCESS;
                    }
                });
            }
            else if (MEDAL_USING_GDK)
            {
                ///////
                // Xbox & Windows GDK
                ///////
                
                __state = MEDAL_LB_STATE_ERROR;
            }
            else if (MEDAL_ON_PS5)
            {
                ///////
                // PS5
                ///////
                
                if (__range == MEDAL_RANGE_TOP)
                {
                    __asyncID = psn_get_leaderboard_score(_system.__psGamepad, __formattedServiceRef);
                }
                else if (__range == MEDAL_RANGE_FRIENDS)
                {
                    __asyncID = psn_get_friends_scores(_system.__psGamepad, __formattedServiceRef, 1, 10);
                }
                else if (__range == MEDAL_RANGE_AROUND)
                {
                    __asyncID = psn_get_leaderboard_score_range(_system.__psGamepad, __formattedServiceRef, 1, 10);
                }
                
                __MedalRegisterAsyncID(__asyncID, function(_aborted)
                {
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                    }
                    
                    __asyncID = undefined;
                    
                    //TODO
                    
                    if (_aborted)
                    {
                        __state = MEDAL_LB_STATE_ERROR;
                    }
                    else
                    {
                        __state = MEDAL_LB_STATE_SUCCESS;
                    }
                });
            }
            else if (MEDAL_ON_SWITCH)
            {
                ///////
                // Switch
                ///////
                
                __state = MEDAL_LB_STATE_ERROR;
            }
            else
            {
                if (MEDAL_RUNNING_FROM_IDE)
                {
                    __MedalError($"Unhandled OS {os_type}. Please report this error");
                }
                else
                {
                    __MedalTrace($"Warning! Unhandled OS {os_type}");
                }
            }
            
            if (__asyncID != undefined)
            {
                if (__state != MEDAL_LB_STATE_ERROR)
                {
                    __MedalTrace($"Started leaderboard fetch for \"{__formattedServiceRef}\" using range `{__range}`");
                    
                    __state = MEDAL_LB_STATE_PENDING;
                    __lastRequestTime = current_time;
                }
            }
        }
        
        return undefined;
    }
}