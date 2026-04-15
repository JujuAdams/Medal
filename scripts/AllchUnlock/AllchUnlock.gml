/// Unlocks the achievement associated with the given allch index. You should first have defined
/// the allch with `AllchDefine()` in the configuration scripts.
/// 
/// N.B. You must call `AllchSetPSGamepad()` or `AllchSetXboxUser()` before unlocking achievements
///      on PlayStation or Xbox.
/// 
/// N.B. Allch does not call `psn_tick()` for you when running on PlayStation. You must call these
///      functions yourself.
/// 
/// N.B. Allch does not call `gdk_init()`, `gdk_update()`, or `gdk_quit()` for you when running on
///      Xbox. You must call these functions yourself.
/// 
/// If locally stored achievements are being used (as indicated by `AllchLocalGetUsing()`) then
/// this function will return `true` if an achievement is newly unlocked. This positive return
/// value might be used to trigger an in-game notification etc.
/// 
/// @param allchIndex

function AllchUnlock(_allchIndex)
{
    static _system       = __AllchSystem();
    static _allchToRefMap = _system.__allchToRefMap;
    
    var _struct = _allchToRefMap[? _allchIndex];
    if (_struct == undefined)
    {
        __AllchSoftError($"Allch index {_allchIndex} not recognised");
        return false;
    }
    
    var _ref = _struct.__serviceRef;
    
    if (_system.__local)
    {
        //Set local values
        
        if (_system.__localData[$ _ref] != true)
        {
            if (ALLCH_VERBOSE)
            {
                __AllchTrace($"Awarding allch {_allchIndex} (service reference `{_ref}`)");
            }
            
            _system.__localData[$ _ref] = true;
            _system.__localChanged = true;
            
            return true;
        }
        else
        {
            if (ALLCH_VERBOSE)
            {
                __AllchTrace($"Awarding allch {_allchIndex} but player already has it (service reference `{_ref}`)");
            }
        }
    }
    else
    {
        //Send off unlock command to remote service
        
        if (ALLCH_VERBOSE)
        {
            __AllchTrace($"Awarding allch {_allchIndex} using remote service");
        }
        
        if (_system.__steamAvailable)
        {
            steam_set_achievement(_ref);
        }
        else if (ALLCH_USING_GAMECENTER)
        {
            GameCenter_Achievement_Report(_ref, 100, true);
        }
        else if (_system.__playServicesAvailable)
        {
            GooglePlayServices_Achievements_Unlock(_ref);
        }
        else if (ALLCH_USING_GDK)
        {
            if (_system.__xboxUser <= int64(0))
            {
                __AllchSoftError("Xbox user not set or invalid. Please set the user with `AllchSetXboxUser()` before calling `AllchUnlock()`");
            }
            else
            {
                xboxone_achievements_set_progress(_system.__xboxUser, _ref, 100);
            }
        }
        else if (ALLCH_ON_PS5)
        {
            if (_system.__psGamepad < 0)
            {
                __AllchSoftError("PlayStation gamepad not set or invalid. Please set the gamepad with `AllchSetPSGamepad()` before calling `AllchUnlock()`");
            }
            else
            {
                psn_unlock_trophy(_system.__psGamepad, _ref);
            }
        }
        else
        {
            __AllchSoftError($"Unhandled OS {os_type}. Please report this error");
        }
    }
    
    return false;
}