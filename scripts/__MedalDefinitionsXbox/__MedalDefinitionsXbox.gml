/// This function is called on boot by Medal's system if the game is running on an Xbox Series X
/// or Xbox Series S console. Xbox One is not supported.

function __MedalDefinitionsXbox()
{
    MedalAchDefine(MEDAL_ACH.SHINY_MACGUFFIN,          "0");
    MedalAchDefine(MEDAL_ACH.SLAY_FIFTY_THOUSAND_RATS, "1");
    MedalAchDefine(MEDAL_ACH.OBNOXIOUS_JUMPING_PUZZLE, "2");
    MedalAchDefine(MEDAL_ACH.WACKY_NPC_INTERACTION,    "3", true);
}