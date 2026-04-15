function __AllchEnsureControllerInstance()
{
    static _created = false;
    
    if (not _created)
    {
        _created = true;
        instance_create_depth(0, 0, 0, __AllchController);
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            __AllchEnsureControllerInstance();
        },
        [], -1));
    }
    else
    {
        if (not instance_exists(__AllchController))
        {
            __AllchError("`__AllchController` has been destroyed or deactivated");
        }
        else if (not __AllchController.persistent)
        {
            __AllchError("`__AllchController` has been set to not persistent");
        }
    }
}