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
    __state               = MEDAL_LB_STATE_NO_DATA;
    __lastRequestTime     = current_time;
    
    __cachedData = {
        __top:     [],
        __friends: [],
        __around:  [],
    };
    
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
    }
    
    static GetScores = function(_range)
    {
        if (_system.__local)
        {
            //TODO
        }
        else if (_system.__steamAvailable)
        {
            steam_upload_score(__GetFormattedServiceRef(), _value);
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
        
        return undefined;
    }
}