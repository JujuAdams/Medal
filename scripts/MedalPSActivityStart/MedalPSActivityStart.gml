/// @param activityID

function MedalPSActivityStart(_activityID)
{
    static _system = __MedalSystem();
    
	if (MEDAL_ON_PS5)
    {
        if (_system.__psGamepad < 0)
        {
            if (MEDAL_RUNNING_FROM_IDE)
            {
                __MedalError("PlayStation gamepad not set or invalid. Please set the gamepad with `MedalSetPSGamepad()` before calling `MedalPSStartActivity()`");
            }
            else
            {
                __MedalTrace($"Warning! PlayStation gamepad not set or invalid");
            }
        }
        else
        {
            var _map = ds_map_create();
            _map[? "activityId"] = _activityID;
            psn_post_uds_event(_system.__psGamepad, "activityStart", _map);
            ds_map_destroy(_map);
        }
    }
}