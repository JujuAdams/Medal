function __MedalLeaderboardsPlayFab()
{
    MedalLbCreate("testLeaderboard",       "testLeaderboard");
    MedalLbCreate("testHourlyLeaderboard", "testHourlyLeaderboard", true);
    MedalLbCreate("testDailyLeaderboard",  "testDailyLeaderboard", true, MEDAL_REFRESH_DAILY);
}