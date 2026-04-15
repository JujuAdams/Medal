/// Sets the user that has unlocked an achievement. You should call this function at least once
/// before calling `MedalAward()`.
/// 
/// @param xboxUser

function MedalSetXboxUser(_xboxUser)
{
    static _system = __MedalSystem();
    
    if (MEDAL_USING_GDK)
    {
        _system.__xboxUser = int64(_xboxUser);
        
        if (MEDAL_VERBOSE)
        {
            __MedalTrace($"Set Xbox user to {_xboxUser}");
        }
    }
}