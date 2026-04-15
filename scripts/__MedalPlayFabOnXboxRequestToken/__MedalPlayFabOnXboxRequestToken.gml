function __MedalPlayFabOnXboxRequestToken()
{
    static _system = __MedalSystem();
    
    if (MEDAL_USING_WINDOWS_GDK)
    {
        __MedalTrace($"Requesting token and signature from PlayFab for user `{_system.__xboxUser}` (Windows)");
        var _return = xboxone_get_token_and_signature(_system.__xboxUser, "https://playfabapi.com/", "POST", "{}", "", false);
    }
    else
    {
        __MedalTrace($"Requesting token and signature from PlayFab for user `{_system.__xboxUser}` (Xbox)");
        //Function isn't in fnames ( ͡° ͜ʖ ͡°)
        var _return = xboxlive_get_token_and_signature(_system.__xboxUser, "https://playfabapi.com/", "POST", "{}", "", false);
    }
    
    if (_return < 0)
    {
        __MedalSoftError($"Failed to get Xbox token and signature for user `{_system.__xboxUser}`"); 
    }
}