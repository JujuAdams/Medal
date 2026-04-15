/// Returns if Allch is using locally stored achievement data. This will happen if your game is
/// running on a platform without a native achievement system (e.g. Switch) or if a required
/// extension hasn't been installed.

function AllchGetUsingLocal()
{
    static _system = __AllchSystem();
    return _system.__local;
}