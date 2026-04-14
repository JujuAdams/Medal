/// @param userHandle

function MedalSetSwitchNPLNUserHandle(_userHandle)
{
    static _system = __MedalSystem();
    
    _system.__switchNPLNUserHandle = _userHandle;
}