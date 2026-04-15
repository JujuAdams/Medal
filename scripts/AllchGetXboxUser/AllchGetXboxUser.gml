/// Gets the current gamepad that Allch will target when unlocking achievements.

function AllchGetXboxUser()
{
    static _system = __AllchSystem();
    return _system.__xboxUser;
}