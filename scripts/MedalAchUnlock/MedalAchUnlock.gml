/// Unlocks the achievement associated with the given medal index. You should first have defined
/// the medal with `MedalDefine()` in the configuration scripts.
/// 
/// N.B. You must call `MedalSetPSGamepad()` or `MedalSetXboxUser()` before unlocking achievements
///      on PlayStation or Xbox.
/// 
/// N.B. Medal does not call `psn_tick()` for you when running on PlayStation. You must call these
///      functions yourself.
/// 
/// N.B. Medal does not call `gdk_init()`, `gdk_update()`, or `gdk_quit()` for you when running on
///      Xbox. You must call these functions yourself.
/// 
/// If locally stored achievements are being used (as indicated by `MedalLocalGetUsing()`) then
/// this function will return `true` if an achievement is newly unlocked. This positive return
/// value might be used to trigger an in-game notification etc.
/// 
/// @param medalIndex

function MedalAchUnlock(_medalIndex)
{
    static _system       = __MedalSystem();
    static _medalToRefMap = _system.__medalToRefMap;
    
    var _struct = _medalToRefMap[? _medalIndex];
    if (_struct == undefined)
    {
        __MedalSoftError($"Medal index {_medalIndex} not recognised");
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
        
        if (MEDAL_VERBOSE)
        {
            __MedalTrace($"Awarding medal {_medalIndex} using remote service");
        }
        
        if (_system.__steamAvailable)
        {
            steam_set_achievement(_ref);
        }
        else if (MEDAL_USING_GAMECENTER)
        {
            GameCenter_Achievement_Report(_ref, 100, true);
        }
        else if (_system.__playServicesAvailable)
        {
            GooglePlayServices_Achievements_Unlock(_ref);
        }
        else if (MEDAL_USING_GDK)
        {
            if (_system.__xboxUser <= int64(0))
            {
                __MedalSoftError("Xbox user not set or invalid. Please set the user with `MedalSetXboxUser()` before calling `MedalAchUnlock()`");
            }
            else
            {
                xboxone_achievements_set_progress(_system.__xboxUser, _ref, 100);
            }
        }
        else if (MEDAL_ON_PS5)
        {
            if (_system.__psGamepad < 0)
            {
                __MedalSoftError("PlayStation gamepad not set or invalid. Please set the gamepad with `MedalSetPSGamepad()` before calling `MedalAchUnlock()`");
            }
            else
            {
                psn_unlock_trophy(_system.__psGamepad, _ref);
            }
        }
        else
        {
            __MedalSoftError($"Unhandled OS {os_type}. Please report this error");
        }
    }
    
    return false;
}