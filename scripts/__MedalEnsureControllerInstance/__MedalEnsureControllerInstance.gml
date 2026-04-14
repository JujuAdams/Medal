function __MedalEnsureControllerInstance()
{
    static _created = false;
    
    if (not _created)
    {
        _created = true;
        instance_create_depth(0, 0, 0, __MedalController);
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            __MedalEnsureControllerInstance();
        },
        [], -1));
    }
    else
    {
        if (not instance_exists(__MedalController))
        {
            __MedalError("`__MedalController` has been destroyed or deactivated");
        }
        else if (not __MedalController.persistent)
        {
            __MedalError("`__MedalController` has been set to not persistent");
        }
    }
}