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
#macro MEDAL_VERBOSE  MEDAL_RUNNING_FROM_IDE

/// Whether to force use of local data storage. This will ignore any remote or per-platform
/// services.
#macro MEDAL_FORCE_LOCAL_DATA  false

#macro MEDAL_REFRESH_OFFSET  60 //minutes