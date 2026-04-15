gamepad = -1;

if (ALLCH_ON_XBOX_SERIES)
{
    var _activatingUser = xboxone_get_activating_user();
    if (_activatingUser != 0)
    {
        AllchSetXboxUser(_activatingUser);
    }
}