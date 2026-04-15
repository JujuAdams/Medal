/// Global enum used for achievement indexes within the project. This enum is mapped to identifiers
/// per service in each of the `__AllchDefinitions*` scripts. You should edit this enum and the
/// achievement definition scripts.
enum ALLCH_ACH
{
    SHINY_MACGUFFIN,
    SLAY_FIFTY_THOUSAND_RATS,
    OBNOXIOUS_JUMPING_PUZZLE,
    WACKY_NPC_INTERACTION,
}

/// Whether to report lots of information messages to the console. This can be helpful to diagnose
/// problems. You will likely want to set this macro to `false` for production builds.
#macro ALLCH_VERBOSE  (ALLCH_RUNNING_FROM_IDE)

#macro ALLCH_WARNINGS_HAVE_CALLSTACKS  true

/// Whether to force use of local data storage. This will ignore any remote or per-platform
/// services.
#macro ALLCH_FORCE_LOCAL_DATA  false