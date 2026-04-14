/// This function is called on boot by Medal's system if the game is running on iOS and the
/// GameCenter extension has initialised successfully.

function __MedalDefinitionsGameCenter()
{
    MedalDefine(MEDAL.SHINY_MACGUFFIN,          "achievement00");
    MedalDefine(MEDAL.SLAY_FIFTY_THOUSAND_RATS, "achievement01");
    MedalDefine(MEDAL.OBNOXIOUS_JUMPING_PUZZLE, "achievement02");
    MedalDefine(MEDAL.WACKY_NPC_INTERACTION,    "achievement03", true);
}