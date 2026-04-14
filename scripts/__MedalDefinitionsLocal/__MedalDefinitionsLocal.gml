// This function is called on boot by Medal's system if the platform that the game is running on
// doesn't have a native featureset for medals.

function __MedalDefinitionsLocal()
{
    /// N.B. The service references used for local storage must never be changed after a game has
    ///      been published. Service references must correlate between versions of the game
    ///      otherwise players will lose game progress.
    
    MedalDefine(MEDAL.SHINY_MACGUFFIN,          "shiny macguffin"              );
    MedalDefine(MEDAL.SLAY_FIFTY_THOUSAND_RATS, "slay fifty thousand rats"     );
    MedalDefine(MEDAL.OBNOXIOUS_JUMPING_PUZZLE, "obnoxious jumping puzzle"     );
    MedalDefine(MEDAL.WACKY_NPC_INTERACTION,    "wacky npc interaction",   true);
}