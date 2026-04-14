/// Gets the current gamepad that Medal will target when unlocking achievements.

function MedalGetXboxUser()
{
    static _system = __MedalSystem();
    return _system.__xboxUser;
}