/// Sets the gamepad for the user that has unlocked a trophy. You should call this function at
/// least once before calling `MedalAward()`.
/// 
/// When running on PlayStation, this function will call `psn_init_trophy()` for you.
/// 
/// @param gamepad

function MedalSetPSGamepad(_gamepad)
{
    static _system = __MedalSystem();
    
    if (MEDAL_ON_PS5)
    {
        psn_init_trophy(_gamepad);
        _system.__psGamepad = _gamepad;
        
        if (MEDAL_VERBOSE)
        {
            __MedalTrace($"Set PlayStation gamepad to {_gamepad}");
        }
    }
}