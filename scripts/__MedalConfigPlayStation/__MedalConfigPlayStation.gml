/// This function is called on boot by Medal's system if the game is running on a PlayStation 5.
/// PlayStation 4 is not supported.
/// 
/// N.B. You do not need to include your platinum trophy in this list.

function __MedalConfigPlayStation()
{
    MedalDefine(MEDAL.SHINY_MACGUFFIN,          1);
    MedalDefine(MEDAL.SLAY_FIFTY_THOUSAND_RATS, 2);
    MedalDefine(MEDAL.OBNOXIOUS_JUMPING_PUZZLE, 3);
    MedalDefine(MEDAL.WACKY_NPC_INTERACTION,    4, true);
}