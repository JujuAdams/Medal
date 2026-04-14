/// Returns whether the state of locally stored achievements has changed. If this function returns
/// `true` then you should save achievements data using `MedalLocalExport()`.

function MedalGetLocalDataChanged()
{
    static _system = __MedalSystem();
    return (_system.__local && _system.__localChanged);
}