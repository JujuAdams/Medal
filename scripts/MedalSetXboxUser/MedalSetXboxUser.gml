/// @param xboxUser

function MedalSetXboxUser(_xboxUser)
{
    static _system = __MedalSystem();
    _system.__xboxUser = _xboxUser;
}