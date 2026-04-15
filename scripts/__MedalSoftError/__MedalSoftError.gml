function __MedalSoftError(_string)
{
    if (MEDAL_RUNNING_FROM_IDE)
    {
        __MedalError(_string);
    }
    else
    {
        __MedalWarning(_string);
    }
}