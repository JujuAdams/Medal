var _string = $"Medal {MEDAL_VERSION}, {MEDAL_DATE}\n";
_string += $"\n";
_string += $"Using local data = {MedalLocalGetUsing()? "true" : "false"}\n";
_string += $"Local changed = {MedalLocalGetChanged()? "true" : "false"}\n";
_string += $"\n";

if (MedalLocalGetUsing())
{
    _string += $"[E] / [start]  = Export local data\n";
    _string += $"[I] / [select] = Import local data\n";
    _string += $"[C] / [face4]  = Unaward all medals\n";
    _string += $"\n";
}

_string += $"[1] / [up]    = Award MEDAL.SHINY_MACGUFFIN\n";
_string += $"[2] / [right] = Award MEDAL.SLAY_FIFTY_THOUSAND_RATS\n";
_string += $"[3] / [down]  = Award MEDAL.OBNOXIOUS_JUMPING_PUZZLE\n";
_string += $"[4] / [left]  = Award MEDAL.WACKY_NPC_INTERACTION\n";

if (MedalLocalGetUsing())
{
    _string += $"\n";
    _string += $"MEDAL.SHINY_MACGUFFIN state          = {MedalLocalGetState(MEDAL.SHINY_MACGUFFIN         )? "true" : "false"}\n";
    _string += $"MEDAL.SLAY_FIFTY_THOUSAND_RATS state = {MedalLocalGetState(MEDAL.SLAY_FIFTY_THOUSAND_RATS)? "true" : "false"}\n";
    _string += $"MEDAL.OBNOXIOUS_JUMPING_PUZZLE state = {MedalLocalGetState(MEDAL.OBNOXIOUS_JUMPING_PUZZLE)? "true" : "false"}\n";
    _string += $"MEDAL.WACKY_NPC_INTERACTION state    = {MedalLocalGetState(MEDAL.WACKY_NPC_INTERACTION   )? "true" : "false"}\n";
}

draw_set_font(fntConsolas);
draw_text(10, 10, _string);