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
        
        __runningDefinitions = true;
        
        __localChanged = false;
        __localData = {};
        
        __psGamepad = -1;
        __xboxUser = int64(0);
        
        __medalToRefMap   = ds_map_create();
        __leaderboardDict = {};
        __steamAsyncIDMap = ds_map_create();
        __httpAsyncIDMap  = ds_map_create();
        
        __steamAvailable        = false;
        __playServicesAvailable = false;
        
        __switchNPLNUserHandle = undefined;
        
        __playFabLoggedIn      = false;
        __playFabSessionTicket = undefined;
        __playFabEntityToken   = undefined;
        
        
        var _fallback = true;
        
        if (MEDAL_FORCE_LOCAL_DATA)
        {
            __MedalTrace($"Forcing local data use via `MEDAL_FORCE_LOCAL_DATA` (__MedalAchievementsLocal / __MedalLeaderboardsLocal)");
            
            _fallback = false;
            
            __local = true;
            __MedalAchievementsLocal();
            __MedalLeaderboardsLocal();
        }
        else if (MEDAL_ON_DESKTOP)
        {
            ///////
            // Desktop
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
                    __MedalTrace("Using Xbox achivements (__MedalAchievementsXbox)");
                }
                
                _fallback = false;
                
                __local = false;
                __MedalAchievementsXbox();
                
                if (MEDAL_USING_PLAYFAB_LEADERBOARDS)
                {
                    __MedalTrace("Using PlayFab leaderboards with (__MedalLeaderboardsPlayFab)");
                    __MedalLeaderboardsPlayFab();
                }
                else if (MEDAL_USING_XBOX_LEADERBOARDS)
                {
                    __MedalTrace("Using Xbox leaderboards with (__MedalLeaderboardsXbox)");
                    __MedalLeaderboardsXbox();
                }
            }
            else if (MEDAL_USING_STEAMWORKS)
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
                    __MedalTrace("Steam extension is initialized and available");
                    
                    if (MEDAL_VERBOSE)
                    {
                        __MedalTrace("Using Steam remote service with `__MedalAchievementsSteam`");
                    }
                }
                else
                {
                    __MedalSoftError("Steam extension present in game but failed to initialize\nPlease check your Steam extension settings and that Steam is running");
                }
                
                __local = false;
                __MedalAchievementsSteam();
                __MedalLeaderboardsSteam();
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
                    __MedalTrace("Using GameCenter remote service with `__MedalAchievementsGameCenter`");
                }
                
                __local = false;
                __MedalAchievementsGameCenter();
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
                        __MedalTrace("Using Googe Play Services with `__MedalAchievementsPlayServices`");
                    }
                    
                    _fallback = false;
                    
                    __local = false;
                    __MedalAchievementsPlayServices();
                }
                else
                {
                    __MedalWarning("Googe Play Services extension failed to initialize. Player may not have Google Play installed");
                }
            }
        }
        else if (MEDAL_ON_PS5)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace("Using PlayStation remote service with `__MedalAchievementsPlayStation`");
            }
            
            _fallback = false;
            
            __local = false;
            __MedalAchievementsPlayStation();
        }
        else if (MEDAL_ON_XBOX_SERIES)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace("Using Xbox remote service with `__MedalAchievementsXbox`");
            }
            
            _fallback = false;
            
            __local = false;
            __MedalAchievementsXbox();
            
            if (MEDAL_USING_PLAYFAB_LEADERBOARDS)
            {
                __MedalLeaderboardsXbox();
            }
            else if (MEDAL_USING_XBOX_LEADERBOARDS)
            {
                __MedalLeaderboardsPlayFab();
            }
        }
        else if (MEDAL_ON_SWITCH)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace("No remote service available on Switch, using locally stored data with `__MedalAchievementsLocal`");
            }
            
            _fallback = false;
            
            __local = false;
            __MedalAchievementsLocal();
            __MedalLeaderboardsLocal();
        }
        else
        {          
            __MedalTrace($"Platform ({os_type}) has no explicit support, falling back on locally stored data with `__MedalAchievementsLocal`");
            
            _fallback = false;
            
            __local = true;
            __MedalAchievementsLocal();
            __MedalLeaderboardsLocal();
        }
        
        if (_fallback)
        {
            __MedalTrace($"Remote service not available, falling back on locally stored data with `__MedalAchievementsLocal`");
            
            __local = true;
            __MedalAchievementsLocal();
            __MedalLeaderboardsLocal();
        }
        
        __runningDefinitions = false;
    }
    
    return _system;
}