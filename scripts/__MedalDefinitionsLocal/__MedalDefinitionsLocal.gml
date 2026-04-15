// This function is called on boot by Medal's system if the platform that the game is running on
// doesn't have a native featureset for medals.

function __MedalDefinitionsLocal()
{
    /// N.B. The service references used for local storage must never be changed after a game has
    ///      been published. Service references must correlate between versions of the game
    ///      otherwise players will lose game progress.
    
    MedalAchDefine(MEDAL_ACH.SHINY_MACGUFFIN,          "shiny macguffin"              );
    MedalAchDefine(MEDAL_ACH.SLAY_FIFTY_THOUSAND_RATS, "slay fifty thousand rats"     );
    MedalAchDefine(MEDAL_ACH.OBNOXIOUS_JUMPING_PUZZLE, "obnoxious jumping puzzle"     );
    MedalAchDefine(MEDAL_ACH.WACKY_NPC_INTERACTION,    "wacky npc interaction",   true);
}