function __MedalLeaderboardsXbox()
{
    MedalLbCreate("all time score", "all time score");
    MedalLbCreate("best time", "best time", false);
    MedalLbCreate("daily challenge", "daily", true, MEDAL_REFRESH_DAILY);
}