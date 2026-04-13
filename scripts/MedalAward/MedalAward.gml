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
        
        return;
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
        else if (os_type == os_ps5)
        {
            //TODO
        }
        else if (os_type == os_xboxseriesxs)
        {
            //TODO
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
}