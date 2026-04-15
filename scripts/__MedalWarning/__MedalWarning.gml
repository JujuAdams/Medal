function __MedalWarning(_string)
{
    _string = $"Warning! {string_replace_all(_string, "\n", " ")}";
    
    if (MEDAL_WARNINGS_HAVE_CALLSTACKS)
    {
        _string += $"          {debug_get_callstack()}";
    }
    
    __MedalTrace(_string);
}