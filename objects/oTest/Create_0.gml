gamepad = -1;

if (MEDAL_ON_XBOX_SERIES)
{
    var _activatingUser = xboxone_get_activating_user();
    if (_activatingUser != 0)
    {
        MedalSetXboxUser(_activatingUser);
        
        if (MEDAL_USING_PLAYFAB_LEADERBOARDS)
        {
            __MedalPlayFabOnXboxRequestToken();
        }
    }
}

__playFabRequestToken          = undefined;
__playFabRequestGetLeaderboard = undefined;
__playFabRequestGetStatistic   = undefined;
__playFabRequestSetStatistic   = undefined;