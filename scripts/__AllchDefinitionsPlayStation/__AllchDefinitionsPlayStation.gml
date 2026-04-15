/// This function is called on boot by Allch's system if the game is running on a PlayStation 5.
/// PlayStation 4 is not supported.
/// 
/// N.B. You do not need to include your platinum trophy in this list.

function __AllchDefinitionsPlayStation()
{
    AllchDefine(ALLCH_ACH.SHINY_MACGUFFIN,          1);
    AllchDefine(ALLCH_ACH.SLAY_FIFTY_THOUSAND_RATS, 2);
    AllchDefine(ALLCH_ACH.OBNOXIOUS_JUMPING_PUZZLE, 3);
    AllchDefine(ALLCH_ACH.WACKY_NPC_INTERACTION,    4, true);
}