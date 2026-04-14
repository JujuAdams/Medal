/// @param leaderboardName
/// @param [range=top]

function MedalLbGetScores(_leaderboardName, _range = MEDAL_RANGE_TOP)
{
    with(MedalLbFind(_leaderboardName))
    {
        return GetScores(_range);
    }
    
    return undefined;
}