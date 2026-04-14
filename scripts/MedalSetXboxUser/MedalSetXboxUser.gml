/// Sets the user that has unlocked a trophy. You should call this function at least once before
/// calling `MedalAward()`.
/// 
/// @param xboxUser

function MedalSetXboxUser(_xboxUser)
{
    static _system = __MedalSystem();
    _system.__xboxUser = _xboxUser;
}