/// Unlocks the achievement associated with the given medal index. You should first have defined
/// the medal with `MedalDefine()` in the configuration scripts.
/// 
/// N.B. You must call `MedalSetPSGamepad()` or `MedalSetXboxUser()` before unlocking achievements
///      on PlayStation or Xbox.
/// 
/// If locally stored achievements are being used (as indicated by `MedalLocalGetUsing()`) then
/// this function will return `true` if an achievement is newly unlocked. This positive return
/// value might be used to trigger an in-game notification etc.
/// 
/// @param medalIndex

function MedalAward(_medalIndex)
{
    static _system       = __MedalSystem();
    static _medalToRefMap = _system.__medalToRefMap;
    
    var _struct = _medalToRefMap[? _medalIndex];
    if (_struct == undefined)
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalError($"Medal index {_medalIndex} not recognised");
        }
        else
        {
            __MedalTrace($"Warning! Medal index {_medalIndex} not recognised          {debug_get_callstack()}");
        }
        
        return false;
    }
    
    var _ref = _struct.__serviceRef;
    
    if (_system.__local)
    {
        //Set local values
        
        if (_system.__localData[$ _ref] != true)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace($"Awarding medal {_medalIndex} (service reference `{_ref}`)");
            }
            
            _system.__localData[$ _ref] = true;
            _system.__localChanged = true;
            
            return true;
        }
        else
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace($"Awarding medal {_medalIndex} but player already has it (service reference `{_ref}`)");
            }
        }
    }
    else
    {
        //Send off unlock command to remote service
        
        if (_system.__steamAvailable)
        {
            steam_set_achievement(_ref);
        }
        else if (_system.__gameCenterAvailable)
        {
            GameCenter_Achievement_Report(_ref, 100, true);
        }
        else if (_system.__playServicesAvailable)
        {
            GooglePlayServices_Achievements_Unlock(_ref);
        }
        else if (os_type == os_ps5)
        {
            if (_system.__psGamepad < 0)
            {
                if (MEDAL_RUNNING_FROM_IDE)
                {
                    __MedalError("PlayStation gamepad not set or invalid. Please set the gamepad with `MedalSetPSGamepad()` before calling `MedalAward()`");
                }
                else
                {
                    __MedalTrace($"Warning! PlayStation gamepad not set or invalid");
                }
            }
            else
            {
                psn_unlock_trophy(_system.__psGamepad, _ref);
            }
        }
        else if (os_type == os_xboxseriesxs)
        {
            if (_system.__xboxUser <= 0)
            {
                if (MEDAL_RUNNING_FROM_IDE)
                {
                    __MedalError("Xbox user not set or invalid. Please set the user with `MedalSetXboxUser()` before calling `MedalAward()`");
                }
                else
                {
                    __MedalTrace($"Warning! Xbox user not set or invalid");
                }
            }
            else
            {
                xboxone_achievements_set_progress(_system.__xboxUser, _ref, 100);
            }
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
    
    return false;
}