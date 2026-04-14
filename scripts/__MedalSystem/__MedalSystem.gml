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
        __gameCenterAvailable   = false;
        __playServicesAvailable = false;
        
        var _fallback = true;
        
        if (MEDAL_FORCE_LOCAL)
        {
            __MedalTrace($"Forcing local data use via `MEDAL_FORCE_LOCAL`, using `__MedalDefinitionsLocal`");
            
            _fallback = false;
            
            __local = true;
            __MedalDefinitionsLocal();
        }
        else if ((os_type == os_windows) || (os_type == os_macosx) || (os_type == os_linux))
        {
            ///////
            // Steam
            ///////
            
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
                __MedalTrace(_steamPresent? "Steam extension is present" : "Steam extension is not present");
            }
            
            if (_steamPresent)
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
        else if (os_type == os_ios)
        {
            ///////
            // GameCenter
            ///////
            
            try
            {
                var _gameCenterPresent = GameCenter_LocalPlayer_IsAuthenticated;
            }
            catch(_error)
            {
                var _gameCenterPresent = false;
            }
            
            if (MEDAL_VERBOSE)
            {
                __MedalTrace(_gameCenterPresent? "GameCenter extension is present" : "GameCenter extension is not present");
            }
            
            if (_gameCenterPresent)
            {
                _fallback = false;
                
                try
                {
                    GameCenter_LocalPlayer_IsAuthenticated(); //We don't care about the return value
                    __gameCenterAvailable = true;
                }
                catch(_error)
                {
                    __gameCenterAvailable = false;
                }
                
                if (__gameCenterAvailable)
                {
                    __MedalTrace("GameCenter extension initialized and available");
                    
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace("Using GameCenter remote service with `__MedalDefinitionsGameCenter`");
                    }
                }
                else
                {
                    if (MEDAL_RUNNING_FROM_IDE)
                    {
                        __MedalError("GameCenter extension present in game but failed to initialize. Please check your GameCenter extension settings");
                    }
                    else
                    {
                        __MedalTrace("Warning! GameCenter extension present in game but failed to initialize. Please check your GameCenter extension settings");
                    }
                }
                
                __local = false;
                __MedalDefinitionsGameCenter();
            }
        }
        else if (os_type == os_android)
        {
            ///////
            // Google Play Services
            ///////
            
            try
            {
                var _playServicesPresent = GooglePlayServices_IsAvailable;
            }
            catch(_error)
            {
                var _playServicesPresent = false;
            }
            
            if (MEDAL_VERBOSE)
            {
                __MedalTrace(_playServicesPresent? "Googe Play Services extension is present" : "Googe Play Services extension is not present");
            }
            
            if (_playServicesPresent)
            {
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
        else if (os_type == os_ps5)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace("Using PlayStation remote service with `__MedalDefinitionsLocal`");
            }
            
            _fallback = false;
            
            __local = false;
            __MedalDefinitionsPlayStation();
        }
        else if (os_type == os_xboxseriesxs)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace("Using Xbox remote service with `__MedalDefinitionsLocal`");
            }
            
            _fallback = false;
            
            __local = false;
            __MedalDefinitionsXbox();
        }
        else if (os_type == os_switch)
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