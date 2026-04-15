__AllchSystem();

function __AllchSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    
    if (ALLCH_RUNNING_FROM_IDE)
    {
        global.allchSystem = _system;
    }
    
    with(_system)
    {
        __AllchTrace($"Welcome to Allchievements by Juju Adams! This is version {ALLCH_VERSION}, {ALLCH_DATE}");
        
        __runningDefinitions = true;
        
        __localChanged = false;
        __localData = {};
        
        __psGamepad = -1;
        __xboxUser = int64(0);
        
        __allchToRefMap   = ds_map_create();
        __steamAsyncIDMap = ds_map_create();
        
        __steamAvailable        = false;
        __playServicesAvailable = false;
        
        var _fallback = true;
        
        if (ALLCH_FORCE_LOCAL_DATA)
        {
            __AllchTrace($"Forcing local data use via `ALLCH_FORCE_LOCAL_DATA` (__AllchDefinitionsLocal)");
            
            _fallback = false;
            
            __local = true;
            __AllchDefinitionsLocal();
        }
        else if (ALLCH_ON_DESKTOP)
        {
            ///////
            // Desktop
            ///////
            
            __AllchTrace(ALLCH_USING_STEAMWORKS? "Steam extension is present" : "Steam extension is not present");
            __AllchTrace(ALLCH_USING_WINDOWS_GDK? "Windows GDK extension is present" : "Windows GDK extension is not present");
            
            if (ALLCH_USING_WINDOWS_GDK)
            {
                if (ALLCH_USING_STEAMWORKS)
                {
                    __AllchError("Cannot use Steam extension and Windows GDK extension together");
                }
                
                if (ALLCH_VERBOSE)
                {
                    __AllchTrace("Using Xbox achivements (__AllchDefinitionsXbox)");
                }
                
                _fallback = false;
                
                __local = false;
                __AllchDefinitionsXbox();
            }
            else if (ALLCH_USING_STEAMWORKS)
            { 
                _fallback = false;
                
                try
                {
                    __steamAvailable = steam_initialised();
                }
                catch(_error)
                {
                    __steamAvailable = false;
                }
                
                if (__steamAvailable)
                {
                    __AllchTrace("Steam extension is initialized and available");
                    
                    if (ALLCH_VERBOSE)
                    {
                        __AllchTrace("Using Steam remote service with `__AllchDefinitionsSteam`");
                    }
                }
                else
                {
                    __AllchSoftError("Steam extension present in game but failed to initialize\nPlease check your Steam extension settings and that Steam is running");
                }
                
                __local = false;
                __AllchDefinitionsSteam();
            }
        }
        else if (ALLCH_ON_IOS)
        {
            ///////
            // GameCenter
            ///////
            
            if (not ALLCH_USING_GAMECENTER)
            {
                __AllchTrace("GameCenter extension is not present");
            }
            else
            {
                __AllchTrace("GameCenter extension is present");
                
                _fallback = false;
                
                if (ALLCH_VERBOSE)
                {
                    __AllchTrace("Using GameCenter remote service with `__AllchDefinitionsGameCenter`");
                }
                
                __local = false;
                __AllchDefinitionsGameCenter();
            }
        }
        else if (ALLCH_ON_ANDROID)
        {
            ///////
            // Google Play Services
            ///////
            
            if (not ALLCH_USING_PLAY_SERVICES)
            {
                __AllchTrace("Googe Play Services extension is not present");
            }
            else
            {
                __AllchTrace("Googe Play Services extension is present");
                
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
                    __AllchTrace("Googe Play Services extension initialized and available");
                    
                    if (ALLCH_VERBOSE)
                    {
                        __AllchTrace("Using Googe Play Services with `__AllchDefinitionsPlayServices`");
                    }
                    
                    _fallback = false;
                    
                    __local = false;
                    __AllchDefinitionsPlayServices();
                }
                else
                {
                    __AllchWarning("Googe Play Services extension failed to initialize. Player may not have Google Play installed");
                }
            }
        }
        else if (ALLCH_ON_PS5)
        {
            if (ALLCH_VERBOSE)
            {
                __AllchTrace("Using PlayStation remote service with `__AllchDefinitionsPlayStation`");
            }
            
            _fallback = false;
            
            __local = false;
            __AllchDefinitionsPlayStation();
        }
        else if (ALLCH_ON_XBOX_SERIES)
        {
            if (ALLCH_VERBOSE)
            {
                __AllchTrace("Using Xbox remote service with `__AllchDefinitionsXbox`");
            }
            
            _fallback = false;
            
            __local = false;
            __AllchDefinitionsXbox();
        }
        else if (ALLCH_ON_SWITCH)
        {
            if (ALLCH_VERBOSE)
            {
                __AllchTrace("No remote service available on Switch, using locally stored data with `__AllchDefinitionsLocal`");
            }
            
            _fallback = false;
            
            __local = false;
            __AllchDefinitionsLocal();
        }
        else
        {          
            __AllchTrace($"Platform ({os_type}) has no explicit support, falling back on locally stored data with `__AllchDefinitionsLocal`");
            
            _fallback = false;
            
            __local = true;
            __AllchDefinitionsLocal();
        }
        
        if (_fallback)
        {
            __AllchTrace($"Remote service not available, falling back on locally stored data with `__AllchDefinitionsLocal`");
            
            __local = true;
            __AllchDefinitionsLocal();
        }
        
        __runningDefinitions = false;
    }
    
    return _system;
}