// This function is called on boot by Allch's system if the platform that the game is running on
// doesn't have a native featureset for allchs.

function __AllchDefinitionsLocal()
{
    /// N.B. The service references used for local storage must never be changed after a game has
    ///      been published. Service references must correlate between versions of the game
    ///      otherwise players will lose game progress.
    
    AllchDefine(ALLCH_ACH.SHINY_MACGUFFIN,          "shiny macguffin"              );
    AllchDefine(ALLCH_ACH.SLAY_FIFTY_THOUSAND_RATS, "slay fifty thousand rats"     );
    AllchDefine(ALLCH_ACH.OBNOXIOUS_JUMPING_PUZZLE, "obnoxious jumping puzzle"     );
    AllchDefine(ALLCH_ACH.WACKY_NPC_INTERACTION,    "wacky npc interaction",   true);
}