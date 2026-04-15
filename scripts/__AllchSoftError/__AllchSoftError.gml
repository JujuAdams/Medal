function __AllchSoftError(_string)
{
    if (ALLCH_RUNNING_FROM_IDE)
    {
        __AllchError(_string);
    }
    else
    {
        __AllchWarning(_string);
    }
}