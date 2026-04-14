/// @param leaderboardName
/// @param value

function MedalLbPush(_leaderboardName, _value)
{
    with(MedalLbFind(_leaderboardName))
    {
        Push(_value);
    }
}