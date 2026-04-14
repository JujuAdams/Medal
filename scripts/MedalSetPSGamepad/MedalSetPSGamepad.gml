/// Sets the gamepad for the user that has unlocked a trophy. You should call this function at
/// least once before calling `MedalAward()`.
/// 
/// @param gamepad

function MedalSetPSGamepad(_gamepad)
{
    static _system = __MedalSystem();
    _system.__psGamepad = _gamepad;
}