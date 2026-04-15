/// This function is called on boot by Medal's system if the game is running on a desktop platform
/// and the Steam extension has initialized.

function __MedalDefinitionsSteam()
{
    MedalAchDefine(MEDAL_ACH.SHINY_MACGUFFIN,          "achievement00");
    MedalAchDefine(MEDAL_ACH.SLAY_FIFTY_THOUSAND_RATS, "achievement01");
    MedalAchDefine(MEDAL_ACH.OBNOXIOUS_JUMPING_PUZZLE, "achievement02");
    MedalAchDefine(MEDAL_ACH.WACKY_NPC_INTERACTION,    "achievement03", true);
}