function __MedalLeaderboardsSteam()
{
    MedalLbCreate("all time score", "all time score");
    MedalLbCreate("best time", "best time", false);
    MedalLbCreate("daily", "daily", true, MEDAL_REFRESH_DAILY);
}