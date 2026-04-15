/// Returns a struct containing the state of locally stored achievements.

function MedalExportLocalData()
{
    static _system = __MedalSystem();
    
    _system.__localChanged = false;
    
    if (_system.__local)
    {
        //TODO - Add basic encryption
        return variable_clone(_system.__localData);
    }
    else
    {
        if (MEDAL_RUNNING_FROM_IDE)
        {
            __MedalTrace("Cannot export, not using locally stored data");
        }
        
        return {};
    }
}