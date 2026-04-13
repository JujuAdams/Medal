/// Returns if Medal is using locally stored achievement data. This will happen if your game is
/// running on a platform without a native achievement system (e.g. Switch) or if you're running
/// on desktop and the Steam SDK either isn't enabled or has not initialized correctly.

function MedalLocalGetUsing()
{
    static _system = __MedalSystem();
    return _system.__local;
}