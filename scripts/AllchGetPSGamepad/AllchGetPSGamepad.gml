/// Gets the current gamepad that Allch will target when unlocking trophies.

function AllchGetPSGamepad()
{
    static _system = __AllchSystem();
    return _system.__psGamepad;
}