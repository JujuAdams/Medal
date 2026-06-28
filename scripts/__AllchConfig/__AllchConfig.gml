/// Global enum used for achievement indexes within the project. You should edit this enum and the
/// achievement definition scripts below.
enum ALLCH_ACH
{
    SHINY_MACGUFFIN,
    SLAY_FIVE_RATS,
    OBNOXIOUS_JUMPING_PUZZLE,
    WACKY_NPC_INTERACTION,
}

/// Code to execute when Allchivements initializes on game boot. You should call `AllchCreate()`
/// in this function for each achivement you would like to implement.
function __AllchConfigOnBoot()
{
    AllchCreate(ALLCH_ACH.SHINY_MACGUFFIN,          { local: "shinyMacGuffin",  steam: "shinyMacGuffin",  playStation: undefined, xbox: undefined });
    AllchCreate(ALLCH_ACH.SLAY_FIVE_RATS,           { local: "5rats",           steam: "5rats",           playStation: undefined, xbox: undefined, target: 5 });
    AllchCreate(ALLCH_ACH.OBNOXIOUS_JUMPING_PUZZLE, { local: "obnoxiousPuzzle", steam: "obnoxiousPuzzle", playStation: undefined, xbox: undefined });
    AllchCreate(ALLCH_ACH.WACKY_NPC_INTERACTION,    { local: "wackyNPC",        steam: "wackyNPC",        playStation: undefined, xbox: undefined, hidden: true });
}

/// Whether to report lots of information messages to the console. This can be helpful to diagnose
/// problems. You will likely want to set this macro to `false` for production builds.
#macro ALLCH_VERBOSE  false

/// Whether to report async events to the console. This feature is only enabled when using GDK as
/// this is the only platform that needs async events outputted for debugging. You will likely want
/// to set this macro to `false` for production builds.
#macro ALLCH_VERBOSE_ASYC  false

/// Enables strict type checking when calling some functions. This is helpful for debugging edge
/// cases but ordinarily should be left turned off.
#macro ALLCH_STRICT  false

/// Whether warning messages should have callstacks. This will not disable callstacks on error
/// messages.
#macro ALLCH_WARNINGS_HAVE_CALLSTACKS  true

/// Milliseconds between calls to `xboxone_achievements_set_progress()`.
#macro ALLCH_GDK_PROGRESS_PERIOD  1_500