/// @param leaderboardName

function MedalLbGetState(_leaderboardName)
{
    with(MedalLbFind(_leaderboardName))
    {
        return __state;
    }
    
    return MEDAL_LB_STATE_UNKNOWN;
}