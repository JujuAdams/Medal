/// Sets the gamepad for the user that has unlocked a trophy. You should call this function at
/// least once before calling `AllchAward()`.
/// 
/// When running on PlayStation, this function will call `psn_init_trophy()` for you.
/// 
/// @param gamepad

function AllchSetPSGamepad(_gamepad)
{
    static _system = __AllchSystem();
    
    if (ALLCH_ON_PS5)
    {
        psn_init_trophy(_gamepad);
        _system.__psGamepad = _gamepad;
        
        if (ALLCH_VERBOSE)
        {
            __AllchTrace($"Set PlayStation gamepad to {_gamepad}");
        }
    }
}