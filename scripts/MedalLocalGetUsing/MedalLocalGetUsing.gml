/// Returns if Medal is using locally stored achievement data. This will happen if your game is
/// running on a platform without a native achievement system (e.g. Switch) or if a required
/// extension hasn't been installed.

function MedalLocalGetUsing()
{
    static _system = __MedalSystem();
    return _system.__local;
}