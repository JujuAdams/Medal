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
    
    static __SetErrorState = function()
    {
        array_resize(__data, 0);
        __state = MEDAL_LB_STATE_ERROR;
    }
    
    static __GetScoresInternal = function(_refresh)
    {
        if (__asyncID != undefined)
        {
            //Pending
            return;
        }
        
        __lastRequestTime = current_time;
        
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
                
                __MedalRegisterSteamAsyncID(__asyncID, function(_aborted)
                {
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                    }
                    
                    __asyncID = undefined;
                    array_resize(__data, 0);
                    
                    if (async_load[? "event_type"] != "leaderboard_download")
                    {
                        __MedalWarning($"Received unexpected leaderboard event type \"{async_load[? "event_type"]}\", aborting");
                        _aborted = true;
                    }
                    
                    if (async_load[? "status"] != 0)
                    {
                        __MedalWarning($"Received unexpected leaderboard status `{async_load[? "status"]}`, aborting");
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
                        __MedalWarning($"Failed to parse returned leaderboard data");
                        
                        _json = undefined;
                        _aborted = true;
                    }
                    
                    if (_aborted)
                    {
                        __SetErrorState();
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
                
                __MedalRegisterSteamAsyncID(__asyncID, function(_aborted)
                {
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                    }
                    
                    __asyncID = undefined;
                    array_resize(__data, 0);
                    
                    //TODO
                    
                    if (_aborted)
                    {
                        __SetErrorState();
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
                
                __MedalRegisterSteamAsyncID(__asyncID, function(_aborted)
                {
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                    }
                    
                    __asyncID = undefined;
                    array_resize(__data, 0);
                    
                    //TODO
                    
                    if (_aborted)
                    {
                        __SetErrorState();
                    }
                    else
                    {
                        __state = MEDAL_LB_STATE_SUCCESS;
                    }
                });
            }
            else if (MEDAL_USING_PLAYFAB_LEADERBOARDS)
            {
                ///////
                // PlayFab
                ///////
                
                if (_system.__xboxUser < 0)
                {
                    __MedalSoftError("Xbox user not set or invalid. Please set the Xbox user with `MedalSetXboxUser()` before fetching leaderboard scores");
                }
                else if (not _system.__playFabLoggedIn)
                {
                    __MedalWarning("Cannot get leaderboard, PlayFab login pending or failed");
                }
                else
                {
                    var _callbackFunction = function(_leaderboardData)
                    {
                        if (MEDAL_VERBOSE)
                        {
                            __MedalTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                        }
                        
                        __asyncID = undefined;
                        array_resize(__data, 0);
                        
                        if (_leaderboardData == undefined)
                        {
                            __SetErrorState();
                        }
                        else
                        {
                            try
                            {
                                var _dataStatus    = _leaderboardData.status;
                                var _rankingsArray = _leaderboardData.data.Rankings;
                            }
                            catch(_error)
                            {
                                if (MEDAL_VERBOSE)
                                {
                                    show_debug_message(json_stringify(_leaderboardData, true));
                                    show_debug_message(_error);
                                }
                                
                                __MedalWarning($"Failed to find expected data in returned leaderboard data \"{__formattedServiceRef}\"");
                                
                                __SetErrorState();
                                return;
                            }
                            
                            if (_dataStatus != "OK")
                            {
                                __MedalWarning($"Leaderboard data \"{__formattedServiceRef}\" returned as not \"OK\"");
                                
                                __SetErrorState();
                                return;
                            }
                            
                            try
                            {
                                var _i = 0;
                                repeat(array_length(_rankingsArray))
                                {
                                    var _ranking = _rankingsArray[_i];
                                    array_push(__data, new __MedalClassRanking(_ranking.DisplayName, _ranking.Scores[0], _ranking.Rank));
                                    ++_i;
                                }
                            }
                            catch(_error)
                            {
                                if (MEDAL_VERBOSE)
                                {
                                    show_debug_message(_error);
                                }
                                
                                __MedalWarning($"Leaderboard data \"{__formattedServiceRef}\" failed to parse");
                                
                                __SetErrorState();
                                return;
                            }
                            
                            if (MEDAL_VERBOSE)
                            {
                                show_debug_message(json_stringify(__data, true));
                                __MedalTrace($"Leaderboard data \"{__formattedServiceRef}\" parsed successfully");
                            }
                            
                            __state = MEDAL_LB_STATE_SUCCESS;
                        }
                    }
                    
                    if (__range == MEDAL_RANGE_TOP)
                    {
                        __asyncID = __MedalPlayFabGetLeaderboard(__formattedServiceRef, 1, 10, _callbackFunction);
                    }
                    else if (__range == MEDAL_RANGE_FRIENDS)
                    {
                        __asyncID = __MedalPlayFabGetLeaderboardFriends(__formattedServiceRef, 1, 10, _callbackFunction);
                    }
                    else if (__range == MEDAL_RANGE_AROUND)
                    {
                        __asyncID = __MedalPlayFabGetLeaderboardAround(__formattedServiceRef, 1, 10, _callbackFunction);
                    }
                }
            }
            else if (MEDAL_USING_GDK)
            {
                ///////
                // Xbox & Windows GDK
                ///////
                
                if (_system.__xboxUser < 0)
                {
                    __MedalSoftError("Xbox user not set or invalid. Please set the gamepad with `MedalSetXboxUser()` before fetching leaderboard scores");
                }
                else
                {
                    if (__range == MEDAL_RANGE_TOP)
                    {
                        __asyncID = xboxone_stats_get_leaderboard(_system.__xboxUser, __formattedServiceRef, 10, 1, false, not __leaderboard.__higherValueIsBetter);
                    }
                    else if (__range == MEDAL_RANGE_FRIENDS)
                    {
                        __asyncID = xboxone_stats_get_social_leaderboard(_system.__xboxUser, __formattedServiceRef, 10, 1, false, not __leaderboard.__higherValueIsBetter, false);
                    }
                    else if (__range == MEDAL_RANGE_AROUND)
                    {
                        __asyncID = xboxone_stats_get_leaderboard(_system.__xboxUser, __formattedServiceRef, 10, 0, true, not __leaderboard.__higherValueIsBetter);
                    }
                    
                    __MedalRegisterSteamAsyncID(__asyncID, function(_aborted)
                    {
                        if (MEDAL_VERBOSE)
                        {
                            __MedalTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                        }
                        
                        __asyncID = undefined;
                        array_resize(__data, 0);
                        
                        //TODO
                        
                        if (_aborted)
                        {
                            __SetErrorState();
                        }
                        else
                        {
                            __state = MEDAL_LB_STATE_SUCCESS;
                        }
                    });
                }
            }
            else if (MEDAL_ON_PS5)
            {
                ///////
                // PS5
                ///////
                
                if (_system.__psGamepad < 0)
                {
                    __MedalSoftError("PlayStation gamepad not set or invalid. Please set the gamepad with `MedalSetPSGamepad()` before fetching leaderboard scores");
                }
                else
                {
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
                    
                    __MedalRegisterSteamAsyncID(__asyncID, function(_aborted)
                    {
                        if (MEDAL_VERBOSE)
                        {
                            __MedalTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                        }
                        
                        __asyncID = undefined;
                        array_resize(__data, 0);
                        
                        //TODO
                        
                        if (_aborted)
                        {
                            __SetErrorState();
                        }
                        else
                        {
                            __state = MEDAL_LB_STATE_SUCCESS;
                        }
                    });
                }
            }
            else if (MEDAL_ON_SWITCH)
            {
                ///////
                // Switch
                ///////
                
                if (_system.__switchNPLNUserHandle < 0)
                {
                    __MedalSoftError("Switch NPLN user handle not set or invalid. Please set the gamepad with `MedalSetSwitchNPLNUserHandle()` before fetching leaderboard scores");
                }
                else
                {
                    //TODO - A lot of work to do here
                    
                    if ((__range == MEDAL_RANGE_TOP) || (__range == MEDAL_RANGE_FRIENDS))
                    {
                        __asyncID = switch_npln_leaderboard_get_scores_range(_system.__switchNPLNUserHandle,
                                                                             __formattedServiceRef.categoryTypeName, __formattedServiceRef.categoryID,
                                                                             0, //TODO - How do we calculate the season index?
                                                                             0, 10);
                    }
                    else if (__range == MEDAL_RANGE_AROUND)
                    {
                        __asyncID = switch_npln_leaderboard_get_scores_near(_system.__switchNPLNUserHandle,
                                                                             __formattedServiceRef.categoryTypeName, __formattedServiceRef.categoryID,
                                                                            0, //TODO - How do we calculate the season index?
                                                                            10);
                    }
                    
                    __MedalRegisterSteamAsyncID(__asyncID, function(_aborted)
                    {
                        if (MEDAL_VERBOSE)
                        {
                            __MedalTrace($"Received leaderboard data for \"{__formattedServiceRef}\" using range `{__range}`");
                        }
                        
                        __asyncID = undefined;
                        array_resize(__data, 0);
                        
                        //TODO
                        
                        if (_aborted)
                        {
                            __SetErrorState();
                        }
                        else
                        {
                            __state = MEDAL_LB_STATE_SUCCESS;
                        }
                    });
                }
                
                __SetErrorState();
            }
            else
            {
                __MedalSoftError($"Unhandled OS {os_type}. Please report this error");
            }
            
            if (__asyncID != undefined)
            {
                if (__state != MEDAL_LB_STATE_ERROR)
                {
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace($"Started leaderboard fetch for \"{__formattedServiceRef}\" using range `{__range}`");
                    }
                    
                    __state = MEDAL_LB_STATE_PENDING;
                }
            }
        }
        
        return undefined;
    }
}