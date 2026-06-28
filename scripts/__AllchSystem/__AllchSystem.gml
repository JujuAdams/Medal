#macro __ALLCH_SAVE_VERSION  1

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
        
        __playerMap = ds_map_create();
        
        __localToIdentifierDict = {};
        
        __psStartedActivityDict = {};
        
        __xboxReferenceToIdent = ds_map_create();
        __xboxQueue = [];
        __xboxLastRequest = -infinity;
        
        __configMap   = ds_map_create();
        __configOrder = [];
        
        __steamAvailable        = false;
        __playServicesAvailable = false;
        
        __currentPlayer = (ALLCH_ON_PS5 || ALLCH_USING_GDK)? undefined : new __AllchClassPlayer();
        
        var _fallback = true;
        
        if (ALLCH_ON_DESKTOP)
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
                    __AllchTrace("Using Xbox achivements");
                }
                
                _fallback = false;
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
                        __AllchTrace("Using Steam remote service");
                    }
                }
                else
                {
                    __AllchSoftError("Steam extension present in game but failed to initialize\nPlease check your Steam extension settings and that Steam is running");
                }
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
                __AllchTrace("Using PlayStation remote service");
            }
            
            _fallback = false;
        }
        else if (ALLCH_ON_XBOX_SERIES)
        {
            if (ALLCH_VERBOSE)
            {
                __AllchTrace("Using Xbox remote service");
            }
            
            _fallback = false;
        }
        else if (ALLCH_ON_SWITCH_X)
        {
            _fallback = false;
            
            if (ALLCH_VERBOSE)
            {
                __AllchTrace("No remote service available on Switch");
            }
        }
        else
        {          
            __AllchTrace($"Platform ({os_type}) has no explicit support");
            
            _fallback = false;
        }
        
        if (_fallback)
        {
            __AllchTrace($"Remote service not available");
        }
        
        __onBoot = true;
        __AllchConfigOnBoot();
        __onBoot = false;
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            //Ensure existance of our controller object
            if (not instance_exists(AllchControllerObject))
            {
                //Try to detect deactivation of the controller object
                instance_activate_object(AllchControllerObject);
                if (instance_exists(AllchControllerObject))
                {
                    //Be nasty when running from the IDE >:(
                    __AllchSoftError("`AllchControllerObject` has been deactivated\nPlease ensure that `AllchControllerObject` is never deactivated\nYou may need to use `instance_activate_object(AllchControllerObject)`");
                }
                else
                {
                    static _created = false;
                    if (_created) __AllchSoftError("`AllchControllerObject` has been destroyed\nPlease ensure that `AllchControllerObject` is never destroyed");
                    _created = true;
                    
                    instance_create_depth(0, 0, 0, AllchControllerObject);
                }
            }
        
            //Detect if the controller object has been set to non-persistent
            if (!AllchControllerObject.persistent)
            {
                __AllchSoftError("`AllchControllerObject` has been set as non-persistent\nPlease ensure that `AllchControllerObject` is always persistent");
                AllchControllerObject.persistent = true;
            }
            
            if (ALLCH_USING_GDK)
            {
                if (current_time - __xboxLastRequest > ALLCH_GDK_PROGRESS_PERIOD)
                {
                    var _queueTop = array_pop(__xboxQueue);
                    if (is_struct(_queueTop))
                    {
                        xboxone_achievements_set_progress(_queueTop.__userID, _queueTop.__ref, _queueTop.__percentage);
                        __xboxLastRequest = current_time;
                    }
                }
            }
        },
        [], -1));
    }
    
    return _system;
}