/// Returns if Allchievements is using locally stored achievement data. This will happen if your
/// game is running on a platform without a native achievement system (e.g. Switch).

function AllchGetUsingLocal()
{
    static _system = __AllchSystem();
    return _system.__local;
}