var _string = $"Medal {MEDAL_VERSION}, {MEDAL_DATE}\n";
_string += $"Gamepad = {gamepad} (press gp_face1 to choose gamepad)\n";
_string += $"\n";
_string += $"Using local data = {MedalGetUsingLocalAchievements()? "true" : "false"}\n";

if (MedalGetUsingLocalAchievements())
{
    _string += $"Local changed = {MedalGetLocalDataChanged()? "true" : "false"}\n";
}

_string += $"\n";

if (MedalGetUsingLocalAchievements())
{
    _string += $"[E] / [start]  = Export local data\n";
    _string += $"[I] / [select] = Import local data\n";
    _string += $"[C] / [face4]  = Unaward all medals\n";
    _string += $"\n";
}

_string += $"[1] / [up]    = Award MEDAL_ACH.SHINY_MACGUFFIN\n";
_string += $"[2] / [right] = Award MEDAL_ACH.SLAY_FIFTY_THOUSAND_RATS\n";
_string += $"[3] / [down]  = Award MEDAL_ACH.OBNOXIOUS_JUMPING_PUZZLE\n";
_string += $"[4] / [left]  = Award MEDAL_ACH.WACKY_NPC_INTERACTION\n";

if (MedalGetUsingLocalAchievements())
{
    _string += $"\n";
    _string += $"MEDAL_ACH.SHINY_MACGUFFIN state          = {MedalAchGetLocalState(MEDAL_ACH.SHINY_MACGUFFIN         )? "true" : "false"}\n";
    _string += $"MEDAL_ACH.SLAY_FIFTY_THOUSAND_RATS state = {MedalAchGetLocalState(MEDAL_ACH.SLAY_FIFTY_THOUSAND_RATS)? "true" : "false"}\n";
    _string += $"MEDAL_ACH.OBNOXIOUS_JUMPING_PUZZLE state = {MedalAchGetLocalState(MEDAL_ACH.OBNOXIOUS_JUMPING_PUZZLE)? "true" : "false"}\n";
    _string += $"MEDAL_ACH.WACKY_NPC_INTERACTION state    = {MedalAchGetLocalState(MEDAL_ACH.WACKY_NPC_INTERACTION   )? "true" : "false"}\n";
}

draw_set_font(fntConsolas);
draw_text(10, 10, _string);