/// @param activityID
/// @param [outcome=completed]

function AllchPSActivityEnd(_activityID, _outcome = "completed")
{
    static _system = __AllchSystem();
    
	if (ALLCH_ON_PS5)
    {
        if (_system.__psGamepad < 0)
        {
            __AllchSoftError("PlayStation gamepad not set or invalid. Please set the gamepad with `AllchSetPSGamepad()` before calling `AllchPSActivityEnd()`");
        }
        else
        {
            var _map = ds_map_create();
            _map[? "activityId"] = _activityID;
            _map[? "outcome"   ] = _outcome;
            psn_post_uds_event(_system.__psGamepad, "activityEnd", _map);
            ds_map_destroy(_map);
        }
    }
}