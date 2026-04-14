__MedalSystem();

function __MedalSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    
    if (MEDAL_RUNNING_FROM_IDE)
    {
        global.medalSystem = _system;
    }
    
    with(_system)
    {
        __MedalTrace($"Welcome to Medal by Juju Adams! This is version {MEDAL_VERSION}, {MEDAL_DATE}");
        
        __localChanged = false;
        __localData = {};
        
        __psGamepad = -1;
        __xboxUser = pointer_null;
        
        __medalToRefMap = ds_map_create();
        
        try
        {
            var _steamPresent = steam_initialized;
        }
        catch(_error)
        {
            var _steamPresent = false;
        }
        
        if (MEDAL_VERBOSE)
        {
            __MedalTrace(_steamPresent? "Steam SDK is present" : "Steam SDK is not present");
        }
        
        try
        {
            __steamAvailable = steam_initialized();
        }
        catch(_error)
        {
            __steamAvailable = false;
        }
        
        if ((os_type == os_windows) || (os_type == os_macosx) || (os_type == os_linux))
        {
            __MedalTrace(__steamAvailable? "Steam SDK is initialized and available" : "Steam SDK has not initialized successfully or is not present");
        }
        
        if (MEDAL_FORCE_LOCAL)
        {
            __MedalTrace($"Forcing local data use, using `__MedalConfigShared`");
            
            __local = true;
            __MedalConfigShared();
        }
        else if ((os_type == os_windows) || (os_type == os_macosx) || (os_type == os_linux))
        {
            if (_steamPresent)
            {
                if (__steamAvailable)
                {
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace("Using Steam remote service with `__MedalConfigSteam`");
                    }
                }
                else
                {
                    if (MEDAL_RUNNING_FROM_IDE)
                    {
                        __MedalError("Steam SDK present in game but failed to initialize. Please check your Steam SDK settings");
                    }
                    else
                    {
                        __MedalTrace("Warning! Steam SDK present in game but failed to initialize. Please check your Steam SDK settings");
                    }
                }
                
                __local = false;
                __MedalConfigSteam();
            }
            else
            {
                if (MEDAL_VERBOSE)
                {
                    __MedalTrace("Steam SDK not present, using locally stored data with `__MedalConfigShared`");
                }
                
                __local = true;
                __MedalConfigShared();
            }
        }
        else if (os_type == os_ps5)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace("Using PlayStation remote service with `__MedalConfigShared`");
            }
            
            __local = false;
            __MedalConfigPlayStation();
        }
        else if (os_type == os_xboxseriesxs)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace("Using Xbox remote service with `__MedalConfigShared`");
            }
            
            __local = false;
            __MedalConfigXbox();
        }
        else if (os_type == os_switch)
        {
            __local = false;
            __MedalConfigShared();
        }
        else
        {
            __MedalTrace($"Platform ({os_type}) has no explicit support, falling back on locally stored data with `__MedalConfigShared`");
            
            __local = true;
            __MedalConfigShared();
        }
    }
    
    return _system;
}