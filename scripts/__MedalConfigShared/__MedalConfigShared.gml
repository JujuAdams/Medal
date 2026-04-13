#macro MEDAL_VERBOSE  MEDAL_RUNNING_FROM_IDE

#macro MEDAL_FORCE_LOCAL  false

enum MEDAL
{
    SHINY_MACGUFFIN,
    SLAY_FIFTY_THOUSAND_RATS,
    OBNOXIOUS_JUMPING_PUZZLE,
    WACKY_NPC_INTERACTION,
}

// This function is called on boot by Medal's system if the platform that the game is running on
// doesn't have a native featureset for medals.
function __MedalConfigShared()
{
    MedalDefine(MEDAL.SHINY_MACGUFFIN,          "shiny macguffin"              );
    MedalDefine(MEDAL.SLAY_FIFTY_THOUSAND_RATS, "slay fifty thousand rats"     );
    MedalDefine(MEDAL.OBNOXIOUS_JUMPING_PUZZLE, "obnoxious jumping puzzle"     );
    MedalDefine(MEDAL.WACKY_NPC_INTERACTION,    "wacky npc interaction",   true);
}