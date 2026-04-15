/// @param struct/array

function __MedalPlayFabJSONStringify(_data)
{
    static _buffer = buffer_create(1024, buffer_grow, 1);
    
    buffer_seek(_buffer, buffer_seek_start, 0);
    __MedalJSONStringifyInner(_data, _buffer);
    
    buffer_write(_buffer, buffer_u8, 0x00);
    buffer_seek(_buffer, buffer_seek_start, 0);
    return buffer_read(_buffer, buffer_string);
}

function __MedalJSONStringifyInner(_data, _buffer)
{
    if (is_array(_data))
    {
        buffer_write(_buffer, buffer_u8, ord("["));
        
        if (array_length(_data) > 0)
        {
            var _i = 0;
            repeat(array_length(_data))
            {
                __MedalJSONStringifyInner(_data[_i], _buffer);
                buffer_write(_buffer, buffer_u8,   ord(","));
                ++_i;
            }
            
            buffer_seek(_buffer, buffer_seek_relative, -1);
        }
        
        buffer_write(_buffer, buffer_u8, ord("]"));
    }
    else if (is_struct(_data))
    {
        buffer_write(_buffer, buffer_u8, ord("{"));
        
        var _variableArray = struct_get_names(_data);
        if (array_length(_variableArray) > 0)
        {
            var _i = 0;
            repeat(array_length(_variableArray))
            {
                var _variableName = _variableArray[_i];
                
                buffer_write(_buffer, buffer_u8,   ord("\""));
                buffer_write(_buffer, buffer_text, _variableName);
                buffer_write(_buffer, buffer_u8,   ord("\""));
                buffer_write(_buffer, buffer_u8,   ord(":"));
                __MedalJSONStringifyInner(_data[$ _variableName], _buffer);
                buffer_write(_buffer, buffer_u8,   ord(","));
                
                ++_i;
            }
            
            buffer_seek(_buffer, buffer_seek_relative, -1);
        }
        
        buffer_write(_buffer, buffer_u8, ord("}"));
    }
    else if (is_bool(_data))
    {
        buffer_write(_buffer, buffer_text, _data? "true" : "false");
    }
    else if (is_string(_data))
    {
        //TODO - Add more string escapes
        buffer_write(_buffer, buffer_u8,   ord("\""));
        buffer_write(_buffer, buffer_text, string_replace_all(_data, "\"", "\\\""));
        buffer_write(_buffer, buffer_u8,   ord("\""));
    }
    else if (is_int32(_data) || is_int64(_data))
    {
        buffer_write(_buffer, buffer_text, string(_data));
    }
    else if (is_real(_data))
    {
        buffer_write(_buffer, buffer_text, string_format(_data, 0, 7));
    }
    else
    {
        //TODO
        show_error($"Datatype \"{typeof(_data)}\" not supported", true);
    }
}