if (MEDAL_ON_WINDOWS && MEDAL_USING_GDK)
{
    if (async_load[? "event_type"] == "user signed in")
    {
        var _user = async_load[? "user"];
        if (_user != int64(0))
        {
            MedalSetXboxUser(_user);
        }
    }
}