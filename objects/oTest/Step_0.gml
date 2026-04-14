psn_tick();

if (keyboard_check_pressed(ord("1")) || gamepad_button_check_pressed(0, gp_padu))
{
    MedalAchUnlock(MEDAL_ACH.SHINY_MACGUFFIN);
}

if (keyboard_check_pressed(ord("2")) || gamepad_button_check_pressed(0, gp_padr))
{
    MedalAchUnlock(MEDAL_ACH.SLAY_FIFTY_THOUSAND_RATS);
}

if (keyboard_check_pressed(ord("3")) || gamepad_button_check_pressed(0, gp_padd))
{
    MedalAchUnlock(MEDAL_ACH.OBNOXIOUS_JUMPING_PUZZLE);
}

if (keyboard_check_pressed(ord("4")) || gamepad_button_check_pressed(0, gp_padl))
{
    MedalAchUnlock(MEDAL_ACH.WACKY_NPC_INTERACTION);
}

if (keyboard_check_pressed(ord("C")) || gamepad_button_check_pressed(0, gp_face4))
{
    MedalAchLocalLockAll();
}

if (keyboard_check_pressed(ord("E")) || gamepad_button_check_pressed(0, gp_start))
{
    var _data = MedalExportLocalData();
    
    var _string = json_stringify(_data);
    var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _string);
    buffer_save(_buffer, "medal.json");
    buffer_delete(_buffer);
    
    show_debug_message("Saved `medal.json`");
}

if (keyboard_check_pressed(ord("I")) || gamepad_button_check_pressed(0, gp_select))
{
    if (not file_exists("medal.json"))
    {
        show_debug_message("`medal.json` does not exist");
    }
    else
    {
        var _buffer = buffer_load("medal.json");
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        MedalImportLocalData(json_parse(_string));
    }
}