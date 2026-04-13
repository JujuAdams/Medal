/// @param data

function MedalLocalImport(_data)
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