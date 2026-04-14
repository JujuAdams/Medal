/// @param gamepad

function MedalSetPSGamepad(_gamepad)
{
    static _system = __MedalSystem();
    _system.__psGamepad = _gamepad;
}