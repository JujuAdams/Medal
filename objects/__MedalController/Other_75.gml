//FIXME - It's possible for tokens to get confused if you set the Xbox user rapidly
if (async_load[? "event_type"] == "tokenandsignature_result")
{
    var _status = async_load[? "status"];
    if (_status != 0)
    {
        __MedalSoftError($"Token and signature request returned unexpected status `{_status}`");
    }
    else
    {
        if (MEDAL_VERBOSE)
        {
            __MedalTrace("Received Xbox token and signature successfully");
        }
        
        __MedalPlayFabXboxLogin(async_load[? "token"]);
    }
}