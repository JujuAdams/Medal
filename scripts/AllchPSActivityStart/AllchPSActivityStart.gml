/// @param activityID

function AllchPSActivityStart(_activityID)
{
    static _system = __AllchSystem();
    
	if (ALLCH_ON_PS5)
    {
        if (_system.__psGamepad < 0)
        {
            __AllchSoftError("PlayStation gamepad not set or invalid. Please set the gamepad with `AllchSetPSGamepad()` before calling `AllchPSStartActivity()`");
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