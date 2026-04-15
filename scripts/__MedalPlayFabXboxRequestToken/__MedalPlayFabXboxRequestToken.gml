function __MedalPlayFabXboxRequestToken()
{
    static _system = __MedalSystem();
    
    __MedalEnsureControllerInstance();
    
    with(_system)
    {
        if (MEDAL_USING_WINDOWS_GDK)
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace($"Requesting token and signature from PlayFab for user `{__xboxUser}` (Windows)");
            }
            
            var _return = xboxone_get_token_and_signature(__xboxUser, "https://playfabapi.com/", "POST", "{}", "", false);
        }
        else
        {
            if (MEDAL_VERBOSE)
            {
                __MedalTrace($"Requesting token and signature from PlayFab for user `{__xboxUser}` (Xbox)");
            }
            
            //Function isn't in fnames ( ͡° ͜ʖ ͡°)
            var _return = xboxlive_get_token_and_signature(__xboxUser, "https://playfabapi.com/", "POST", "{}", "", false);
        }
        
        if (_return < 0)
        {
            __MedalSoftError($"Failed to get Xbox token and signature for user `{__xboxUser}`"); 
        }
    }
}