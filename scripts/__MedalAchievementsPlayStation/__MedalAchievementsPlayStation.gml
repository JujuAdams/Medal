/// This function is called on boot by Medal's system if the game is running on a PlayStation 5.
/// PlayStation 4 is not supported.
/// 
/// N.B. You do not need to include your platinum trophy in this list.

function __MedalAchievementsPlayStation()
{
    MedalAchDefine(MEDAL_ACH.SHINY_MACGUFFIN,          1);
    MedalAchDefine(MEDAL_ACH.SLAY_FIFTY_THOUSAND_RATS, 2);
    MedalAchDefine(MEDAL_ACH.OBNOXIOUS_JUMPING_PUZZLE, 3);
    MedalAchDefine(MEDAL_ACH.WACKY_NPC_INTERACTION,    4, true);
}