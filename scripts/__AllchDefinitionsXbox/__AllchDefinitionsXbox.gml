/// This function is called on boot by Allch's system if the game is running on an Xbox Series X
/// or Xbox Series S console. Xbox One is not supported.

function __AllchDefinitionsXbox()
{
    AllchDefine(ALLCH_ACH.SHINY_MACGUFFIN,          "0");
    AllchDefine(ALLCH_ACH.SLAY_FIFTY_THOUSAND_RATS, "1");
    AllchDefine(ALLCH_ACH.OBNOXIOUS_JUMPING_PUZZLE, "2");
    AllchDefine(ALLCH_ACH.WACKY_NPC_INTERACTION,    "3", true);
}