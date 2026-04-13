/// This function is called on boot by Medal's system if the game is running on an Xbox Series X
/// or Xbox Series S console. Xbox One is not supported.

function __MedalConfigXbox()
{
    MedalDefine(MEDAL.SHINY_MACGUFFIN,          0);
    MedalDefine(MEDAL.SLAY_FIFTY_THOUSAND_RATS, 1);
    MedalDefine(MEDAL.OBNOXIOUS_JUMPING_PUZZLE, 2);
    MedalDefine(MEDAL.WACKY_NPC_INTERACTION,    3, true);
}