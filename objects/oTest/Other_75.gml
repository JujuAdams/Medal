show_debug_message($"System: {json_encode(async_load, true)}");

if (MEDAL_USING_GDK)
{
    if (MEDAL_ON_WINDOWS)
    {
        if (async_load[? "event_type"] == "user signed in")
        {
            var _user = async_load[? "user"];
            if (_user != int64(0))
            {
                MedalSetXboxUser(_user);
            
                if (MEDAL_USING_PLAYFAB_LEADERBOARDS)
                {
                    __MedalPlayFabOnXboxRequestToken();
                }
            }
        }
    }
    
    if (MEDAL_USING_PLAYFAB_LEADERBOARDS)
    {
        if (async_load[? "event_type"] == "tokenandsignature_result")
        {
            var _status = async_load[? "status"];
            if (_status != 0)
            {
                __MedalSoftError($"Token and signature request returned unexpected status `{_status}`");
            }
            else
            {
                __MedalSystem().__playFabToken = async_load[? "token"];
                
                if (MEDAL_VERBOSE)
                {
                    __MedalTrace("Received Xbox token and signature successfully");
                }
                
                __MedalPlayFabXboxLogin();
            }
        }
    }
}