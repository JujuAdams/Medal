/// @param [playerID]

function __AllchClassPlayer(_playerID = undefined) constructor
{
    static _system    = __AllchSystem();
    static _configMap = _system.__configMap;
    
    __playerID = _playerID;
    __progressMap = ds_map_create();
    __dataChanged = false;
    __ready = not ALLCH_USING_GDK;
    
    if (ALLCH_ON_PS5)
    {
        psn_init_trophy(__playerID);
    }
    else if (ALLCH_USING_GDK)
    {
        xboxone_get_achievements(_playerID);
    }
    
    
    
    static __EnsureProgress = function(_identifier)
    {
        var _progressStruct = __progressMap[? _identifier];
        if (not is_struct(_progressStruct))
        {
            _progressStruct = new __AllchClassProgress();
            __progressMap[? _identifier] = _progressStruct;
        }
        
        return _progressStruct;
    }
    
    static __GetValue = function(_identifier)
    {
        var _progressStruct = __progressMap[? _identifier];
        return is_struct(_progressStruct)? _progressStruct.__value : 0;
    }
    
    static __GetUnlocked = function(_identifier)
    {
        var _progressStruct = __progressMap[? _identifier];
        return is_struct(_progressStruct)? _progressStruct.__unlocked : false;
    }
    
    static __SetValue = function(_identifier, _value)
    {
        var _config = _configMap[? _identifier];
        if (_config == undefined)
        {
            __AllchSoftError($"Achievement `{_identifier}` not recognised");
            return false;
        }
        
        var _progressStruct = __EnsureProgress(_identifier);
        
        var _oldValue = _progressStruct.__value;
        if (_value == _oldValue)
        {
            return false;
        }
        
        _progressStruct.__value = _value;
        __dataChanged = true;
        
        if (ALLCH_VERBOSE)
        {
            __AllchTrace($"Setting achievement `{_identifier}` progress to `{_value}`");
        }
        
        var _targetValue = _config.target;
        var _newlyUnlocked = false;
        var _unlocked = (_value >= _targetValue);
        
        if (_unlocked)
        {
            if (_progressStruct.__unlocked)
            {
                if (ALLCH_VERBOSE)
                {
                    __AllchTrace($"Awarding achievement `{_identifier}` but player already has it");
                }
            }
            else
            {
                if (ALLCH_VERBOSE)
                {
                    __AllchTrace($"Awarding achievement `{_identifier}`");
                }
                
                _newlyUnlocked = true;
            }
        }
        
        if (_oldValue < _targetValue)
        {
            //Resubmit
            
            var _percentage = clamp(100*_value / _targetValue, 0, 100);
            
            if (ALLCH_USING_GAMECENTER)
            {
                GameCenter_Achievement_Report(_config.gameCenter, _percentage, true);
                
                if (ALLCH_VERBOSE)
                {
                    __AllchTrace($"Setting achievement percentage for `{_identifier}` to {_percentage}% using GameCenter reference `{_config.gameCenter}`");
                }
            }
            else if (ALLCH_USING_GDK)
            {
                if (_percentage <= _progressStruct.__existingPercentage)
                {
                    if (ALLCH_VERBOSE)
                    {
                        __AllchTrace($"New percentage {_percentage}% for `{_identifier}` is not greater than existing percentage {_progressStruct.__existingPercentage}% for XBOX reference `{_config.xbox}`");
                    }
                }
                else
                {
                    if (ALLCH_VERBOSE)
                    {
                        __AllchTrace($"Setting achievement percentage for `{_identifier}` to {_percentage}% using XBOX reference `{_config.xbox}`");
                    }
                    
                    if (_newlyUnlocked)
                    {
                        //Immediately award an achievement if it's newly unlocked
                        xboxone_achievements_set_progress(__playerID, _config.xbox, 100);
                        _system.__xboxLastRequest = current_time;
                        
                        __AllchDequeueXboxAchievement(__playerID, _config.xbox);
                    }
                    else if (not _unlocked)
                    {
                        __AllchQueueXboxAchievement(__playerID, _config.xbox, _percentage);
                    }
                }
            }
        }
        
        if (_unlocked)
        {
            //Send off unlock command to remote service
            if (ALLCH_STEAM_AVAILABLE)
            {
                //TODO - Steam stats?
                steam_set_achievement(_config.steam);
                
                if (ALLCH_VERBOSE)
                {
                    __AllchTrace($"Awarding achievement `{_identifier}` using Steam reference `{_config.steam}`");
                }
            }
            else if (ALLCH_ON_PS5)
            {
                psn_unlock_trophy(__playerID, _config.playStation);
                
                if (ALLCH_VERBOSE)
                {
                    __AllchTrace($"Awarding achievement `{_identifier}` using PlayStation reference `{_config.playStation}`");
                }
            }
            else if (ALLCH_PLAY_SERVICES_AVAILABLE)
            {
                GooglePlayServices_Achievements_Unlock(_config.playServices);
                
                if (ALLCH_VERBOSE)
                {
                    __AllchTrace($"Awarding achievement `{_identifier}` using Play Services reference `{_config.playServices}`");
                }
            }
        }
        
        return _newlyUnlocked;
    }
}