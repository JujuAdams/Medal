function GDKInitFromConfig()
{
    if (extension_exists("GDKExtension"))
    {
        if (not file_exists("MicrosoftGame.config"))
        {
            show_error(" \nCould not find \"MicrosoftGame.config\"\nThis configuration file is required for the GDK extension to operate\n ", true);
        }
        else
        {
            var _buffer = buffer_load("MicrosoftGame.config");
            var _string = buffer_read(_buffer, buffer_text);
            buffer_delete(_buffer);
            
            var _searchString = "<ExtendedAttribute Name=\"Scid\" Value=\"";
            var _startPos = string_pos(_searchString, _string);
            if (_startPos <= 0)
            {
                show_error("Could not find start of SCID in \"MicrosoftGame.config\"\n ", true);
            }
            else
            {
                _startPos += string_length(_searchString);
                
                var _endPos = string_pos_ext("\"", _string, _startPos);
                if (_endPos <= 0)
                {
                    show_error("Could not find end of SCID in \"MicrosoftGame.config\"\n ", true);
                }
                else
                {
                    var _scid = string_copy(_string, _startPos, _endPos - _startPos);
                    
                    if (GM_build_type == "run")
                    {
                        show_debug_message($"Initializing GDK using SCID \"{_scid}\"");
                    }
                    
                    gdk_init(_scid);
                }
            }
        }
    }
}