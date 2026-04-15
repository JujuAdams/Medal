/// Sets the state of locally stored achievements from a struct. The struct should have been
/// created by `AllchLocalExport()`.
/// 
/// @param data

function AllchImportLocalData(_data)
{
    static _system = __AllchSystem();
    
    _system.__localChanged = false;
    
    if (_system.__local)
    {
        //TODO - Add basic encryption
        _system.__localData = variable_clone(_data);
    }
    else
    {
        if (ALLCH_RUNNING_FROM_IDE)
        {
            __AllchWarning("Cannot import, not using locally stored data");
        }
    }
}