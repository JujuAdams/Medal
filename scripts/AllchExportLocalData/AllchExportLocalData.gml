/// Returns a struct containing the state of locally stored achievements.

function AllchExportLocalData()
{
    static _system = __AllchSystem();
    
    _system.__localChanged = false;
    
    if (_system.__local)
    {
        //TODO - Add basic encryption
        return variable_clone(_system.__localData);
    }
    else
    {
        if (ALLCH_RUNNING_FROM_IDE)
        {
            __AllchTrace("Cannot export, not using locally stored data");
        }
        
        return {};
    }
}