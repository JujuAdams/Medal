/// This function is called on boot by Allch's system if the game is running on a desktop platform
/// and the Steam extension has initialized.

function __AllchDefinitionsSteam()
{
    AllchDefine(ALLCH_ACH.SHINY_MACGUFFIN,          "achievement00");
    AllchDefine(ALLCH_ACH.SLAY_FIFTY_THOUSAND_RATS, "achievement01");
    AllchDefine(ALLCH_ACH.OBNOXIOUS_JUMPING_PUZZLE, "achievement02");
    AllchDefine(ALLCH_ACH.WACKY_NPC_INTERACTION,    "achievement03", true);
}