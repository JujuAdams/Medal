/// Global enum used for achievement indexes within the project. This enum is mapped to identifiers
/// per service in each of the `__MedalAchievements*` scripts. You should edit this enum and the
/// achievement definition scripts.
enum MEDAL_ACH
{
    SHINY_MACGUFFIN,
    SLAY_FIFTY_THOUSAND_RATS,
    OBNOXIOUS_JUMPING_PUZZLE,
    WACKY_NPC_INTERACTION,
}

/// Whether to report lots of information messages to the console. This can be helpful to diagnose
/// problems. You will likely want to set this macro to `false` for production builds.
#macro MEDAL_VERBOSE  (MEDAL_RUNNING_FROM_IDE)

#macro MEDAL_WARNINGS_HAVE_CALLSTACKS  true

/// Whether to force use of local data storage. This will ignore any remote or per-platform
/// services.
#macro MEDAL_FORCE_LOCAL_DATA  false

#macro MEDAL_LB_DISRESPECT_RATE_LIMITS  false

///////
// PlayFab
///////

//You must tick the "Allow client to post player statistics" box in the PlayFab backend. This can
//be found in the product / Settings / API Features.
#macro MEDAL_GDK_USES_PLAYFAB_LEADERBOARDS  true

//Found on PlayFab backend
#macro MEDAL_PLAYFAB_TITLE_ID  ""

//Found on PlayFab backend in the product / Settings / Secret Keys
#macro MEDAL_PLAYFAB_TITLE_SECRET  ""