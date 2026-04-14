/// @param userHandle

function MedalGetSwitchNPLNUserHandle(_userHandle)
{
    static _system = __MedalSystem();
    
    return _system.__switchNPLNUserHandle;
}