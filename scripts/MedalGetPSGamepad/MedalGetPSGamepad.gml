/// Gets the current gamepad that Medal will target when unlocking trophies.

function MedalGetPSGamepad()
{
    static _system = __MedalSystem();
    return _system.__psGamepad;
}