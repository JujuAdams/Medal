function __AllchWarning(_string)
{
    _string = $"Warning! {string_replace_all(_string, "\n", " ")}";
    
    if (ALLCH_WARNINGS_HAVE_CALLSTACKS)
    {
        _string += $"          {debug_get_callstack()}";
    }
    
    __AllchTrace(_string);
}