if (async_load[? "status"] == 0)
{
    var _asyncIDMap = __MedalSystem().__httpAsyncIDMap;
    
    var _id = async_load[? "id"];
    if (ds_map_exists(_asyncIDMap, _id))
    {
        var _callback = _asyncIDMap[? _id];
        ds_map_delete(_asyncIDMap, _id);
        
        _callback(false);
    }
}