/// Sets the state of locally stored achievements from a struct. The struct should have been
/// created by `MedalLocalExport()`.
/// 
/// @param data

function MedalImportLocalData(_data)
{
    static _system = __MedalSystem();
    
    _system.__localChanged = false;
    
    if (_system.__local)
    {
        //TODO - Add basic encryption
        _system.__localData = variable_clone(_data);
    }
    else
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalTrace($"Warning! Cannot import, not using locally stored data          {debug_get_callstack()}");
        }
    }
}