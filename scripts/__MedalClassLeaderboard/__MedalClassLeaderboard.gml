/// @param name
/// @param serviceRef
/// @param [higherValueIsBetter=true]
/// @param [refreshPeriod=never]

function __MedalClassLeaderboard(_name, _serviceRef, _higherValueIsBetter = true, _refreshPeriod = MEDAL_REFRESH_NEVER) constructor
{
    static _system = __MedalSystem();
    
    __name                = _name;
    __serviceRef          = _serviceRef;
    __refreshPeriod       = _refreshPeriod;
    __higherValueIsBetter = _higherValueIsBetter;
    __scoresDict          = {};
    
    
    
    static Push = function(_value)
    {
        if (_system.__local)
        {
            //TODO
        }
        else if (_system.__steamAvailable)
        {
            steam_upload_score(__GetFormattedServiceRef(), _value);
        }
        else if (MEDAL_USING_GAMECENTER)
        {
            GameCenter_Leaderboard_Submit(__GetFormattedServiceRef(), _value, 0);
        }
        else if (_system.__playServicesAvailable)
        {
            GooglePlayServices_Leaderboard_SubmitScore(GetFormattedServiceRef(), _value, "");
        }
        else if (MEDAL_ON_PS5)
        {
            if (_system.__psGamepad < 0)
            {
                __MedalSoftError("PlayStation gamepad not set or invalid. Please set the gamepad with `MedalSetPSGamepad()` before pushing leaderboard scores");
            }
            else
            {
                psn_post_leaderboard_score(_system.__psGamepad, GetFormattedServiceRef(), _value);
            }
        }
        else if (MEDAL_USING_XBOX_LEADERBOARDS)
        {
            if (_system.__xboxUser < 0)
            {
                __MedalSoftError("Xbox user not set or invalid. Please set the gamepad with `MedalSetXboxUser()` before pushing leaderboard scores");
            }
            else
            {
                xboxone_stats_set_stat_int(_system.__xboxUser, GetFormattedServiceRef(), _value);
            }
        }
        else if (MEDAL_USING_PLAYFAB_LEADERBOARDS)
        {
            if (_system.__xboxUser < 0)
            {
                __MedalSoftError("Xbox user not set or invalid. Please set the gamepad with `MedalSetXboxUser()` before pushing leaderboard scores");
            }
            else
            {
                __MedalPlayFabSetStat(GetFormattedServiceRef(), _value);
            }
        }
        else if (MEDAL_ON_SWITCH)
        {
            if (_system.__switchNPLNUserHandle == undefined)
            {
                __MedalSoftError("Switch NPLN user handle not set or invalid. Please set the NPLN user handle with `MedalSetSwitchNPLNUserHandle()` before pushing leaderboard scores");
            }
            else
            {
                switch_npln_leaderboard_set_score(_system.__switchNPLNUserHandle, __serviceRef.categoryTypeName, __serviceRef.categoryID, _value);
            }
        }
        else
        {
            __MedalSoftError($"Unhandled OS {os_type}. Please report this error");
        }
    }
    
    static GetScores = function(_range)
    {
        if ((_range != MEDAL_RANGE_TOP) && (_range != MEDAL_RANGE_FRIENDS) && (_range != MEDAL_RANGE_AROUND))
        {
            __MedalSoftError($"Unhandled range `{_range}`");
            return undefined;
        }
        
        return __EnsureScoresStruct(__GetFormattedServiceRef(), _range).__GetScoresContinuous();
    }
    
    static Refresh = function(_range)
    {
        if ((_range != MEDAL_RANGE_TOP) && (_range != MEDAL_RANGE_FRIENDS) && (_range != MEDAL_RANGE_AROUND))
        {
            __MedalSoftError($"Unhandled range `{_range}`");
            return undefined;
        }
        
        return __EnsureScoresStruct(__GetFormattedServiceRef(), _range).__Refresh();
    }
    
    static GetState = function(_range)
    {
        return __EnsureScoresStruct(__GetFormattedServiceRef(), _range).__state;
    }
    
    static __GetFormattedServiceRef = function()
    {
        if (_system.__steamAvailable)
        {
            var _serviceRefFormatted = __serviceRef;
            
            if (__refreshPeriod != MEDAL_REFRESH_NEVER)
            {
                var _currentDate = date_current_datetime();
                _serviceRefFormatted += $"_y{date_get_year(_currentDate)}";
                
                if (__refreshPeriod == MEDAL_REFRESH_DAILY)
                {
                    _serviceRefFormatted += $"_d{date_get_day_of_year(_currentDate)}";
                }
                else if (__refreshPeriod == MEDAL_REFRESH_WEEKLY)
                {
                    _serviceRefFormatted += $"_w{date_get_week(_currentDate)}";
                }
                else if (__refreshPeriod == MEDAL_REFRESH_MONTHLY)
                {
                    _serviceRefFormatted += $"_m{date_get_month(_currentDate)}";
                }
            }
            
            return _serviceRefFormatted;
        }
        
        return __serviceRef;
    }
    
    static __EnsureScoresStruct = function(_formattedServiceRef, _range)
    {
        var _scoresID = $"{_formattedServiceRef}_range{_range}";
        
        var _struct = __scoresDict[$ _scoresID];
        if (not is_struct(_struct))
        {
            _struct = new __MedalClassScores(_scoresID, _formattedServiceRef, _range, __refreshPeriod);
            __scoresDict[$ _scoresID] = _struct;
        }
        
        return _struct;
    }
}