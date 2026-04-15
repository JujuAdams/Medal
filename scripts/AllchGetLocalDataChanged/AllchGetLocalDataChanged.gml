/// Returns whether the state of locally stored achievements has changed. If this function returns
/// `true` then you should save achievements data using `AllchLocalExport()`.

function AllchGetLocalDataChanged()
{
    static _system = __AllchSystem();
    return (_system.__local && _system.__localChanged);
}