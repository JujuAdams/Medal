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
        
        __steamAvailable        = false;
        __playServicesAvailable = false;
        
        var _fallback = true;
        
        if (MEDAL_FORCE_LOCAL)
        {
            __MedalTrace($"Forcing local data use via `MEDAL_FORCE_LOCAL`, using `__MedalDefinitionsLocal`");
            
            _fallback = false;
            
            __local = true;
            __MedalDefinitionsLocal();
        }
        else if (MEDAL_ON_DESKTOP)
        {
            ///////
            // Steam
            ///////
            
            __MedalTrace(MEDAL_USING_STEAMWORKS? "Steam extension is present" : "Steam extension is not present");
            __MedalTrace(MEDAL_USING_WINDOWS_GDK? "Windows GDK extension is present" : "Windows GDK extension is not present");
            
            if (MEDAL_USING_WINDOWS_GDK)
            {
                if (MEDAL_USING_STEAMWORKS)
                {
                    __MedalError("Cannot use Steam extension and Windows GDK extension together");
                }
                
                if (MEDAL_VERBOSE)
                {
                    __MedalTrace("Using Xbox remote service with `__MedalDefinitionsXbox`");
                }
                
                _fallback = false;
                
                __local = false;
                __MedalDefinitionsXbox();
            }
            else if (MEDAL_USING_STEAMWORKS)
            { 
                _fallback = false;
                
                try
                {
                    __steamAvailable = steam_initialized();
                }
                catch(_error)
                {
                    __steamAvailable = false;
                }
                
                if (__steamAvailable)
                {
                    __MedalTrace("Steam extension is initialized and available");
                    
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace("Using Steam remote service with `__MedalDefinitionsSteam`");
                    }
                }
                else
                {
                    if (MEDAL_RUNNING_FROM_IDE)
                    {
                        __MedalError("Steam extension present in game but failed to initialize. Please check your Steam extension settings");
                    }
                    else
                    {
                        __MedalTrace("Warning! Steam extension present in game but failed to initialize. Please check your Steam extension settings");
                    }
                }
                
                __local = false;
                __MedalDefinitionsSteam();
            }
        }
        else if (MEDAL_ON_IOS)
        {
            ///////
            // GameCenter
            ///////
            
            if (not MEDAL_USING_GAMECENTER)
            {
                __MedalTrace("GameCenter extension is not present");
            }
            else
            {
                __MedalTrace("GameCenter extension is present");
                
                _fallback = false;
                
                if (MEDAL_VERBOSE)
                {
                    __MedalTrace("Using GameCenter remote service with `__MedalDefinitionsGameCenter`");
                }
                
                __local = false;
                __MedalDefinitionsGameCenter();
            }
        }
        else if (MEDAL_ON_ANDROID)
        {
            ///////
            // Google Play Services
            ///////
            
            if (not MEDAL_USING_PLAY_SERVICES)
            {
                __MedalTrace("Googe Play Services extension is not present");
            }
            else
            {
                __MedalTrace("Googe Play Services extension is present");
                
                _fallback = false;
                
                try
                {
                    __playServicesAvailable = GooglePlayServices_IsAvailable();
                }
                catch(_error)
                {
                    __playServicesAvailable = false;
                }
                
                if (__playServicesAvailable)
                {
                    __MedalTrace("Googe Play Services extension initialized and available");
                    
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace("Using Googe Play Services with `__MedalDefinitionsPlayServices`");
                    }
                    
                    _fallback = false;
                    
                    __local = false;
                    __MedalDefinitionsPlayServices();
                }
                else
                {
                    __MedalTrace("Warning! Googe Play Services extension failed to initialize. Player may not have Google Play installed");
                }
            }
        }
        else if (MEDAL_ON_PS5)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace("Using PlayStation remote service with `__MedalDefinitionsPlayStation`");
            }
            
            _fallback = false;
            
            __local = false;
            __MedalDefinitionsPlayStation();
        }
        else if (MEDAL_ON_XBOX_SERIES)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace("Using Xbox remote service with `__MedalDefinitionsXbox`");
            }
            
            _fallback = false;
            
            __local = false;
            __MedalDefinitionsXbox();
        }
        else if (MEDAL_ON_SWITCH)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace("No remote service available on Switch, using locally stored data with `__MedalDefinitionsLocal`");
            }
            
            _fallback = false;
            
            __local = false;
            __MedalDefinitionsLocal();
        }
        else
        {          
            __MedalTrace($"Platform ({os_type}) has no explicit support, falling back on locally stored data with `__MedalDefinitionsLocal`");
            
            _fallback = false;
            
            __local = true;
            __MedalDefinitionsLocal();
        }
        
        if (_fallback)
        {
            __MedalTrace($"Remote service not available, falling back on locally stored data with `__MedalDefinitionsLocal`");
            
            __local = true;
            __MedalDefinitionsLocal();
        }
    }
    
    return _system;
}