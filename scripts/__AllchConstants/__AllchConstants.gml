#macro ALLCH_VERSION  "1.0.0"
#macro ALLCH_DATE     "2026-04-13"

#macro ALLCH_RUNNING_FROM_IDE  (GM_build_type == "run")

#macro ALLCH_ON_WINDOWS                  (os_type == os_windows)
#macro ALLCH_ON_MACOS                    (os_type == os_macosx)
#macro ALLCH_ON_LINUX                    (os_type == os_linux)
#macro ALLCH_ON_DESKTOP                  (ALLCH_ON_WINDOWS || ALLCH_ON_MACOS || ALLCH_ON_LINUX)
#macro ALLCH_ON_IOS                      (os_type == os_ios)
#macro ALLCH_ON_ANDROID                  (os_type == os_android)
#macro ALLCH_ON_XBOX_SERIES              (os_type == os_xboxseriesxs)
#macro ALLCH_ON_PS5                      (os_type == os_ps5)
#macro ALLCH_ON_SWITCH                   (os_type == os_switch)

#macro ALLCH_USING_STEAMWORKS     (ALLCH_ON_DESKTOP && extension_exists("Steamworks"))
#macro ALLCH_USING_GAMECENTER     (ALLCH_ON_IOS && extension_exists("GameCenter"))
#macro ALLCH_USING_PLAY_SERVICES  (ALLCH_ON_ANDROID && extension_exists("GooglePlayServices"))
#macro ALLCH_USING_GDK            (ALLCH_ON_XBOX_SERIES || ALLCH_USING_WINDOWS_GDK)
#macro ALLCH_USING_WINDOWS_GDK    (ALLCH_ON_WINDOWS && extension_exists("GDKExtension"))

#macro ALLCH_REFRESH_NEVER    0
#macro ALLCH_REFRESH_DAILY    1
#macro ALLCH_REFRESH_WEEKLY   2
#macro ALLCH_REFRESH_MONTHLY  3

#macro ALLCH_RANGE_TOP      0
#macro ALLCH_RANGE_FRIENDS  1
#macro ALLCH_RANGE_AROUND   2

#macro ALLCH_LB_STATE_ERROR     -1
#macro ALLCH_LB_STATE_NO_DATA    0
#macro ALLCH_LB_STATE_PENDING    1
#macro ALLCH_LB_STATE_SUCCESS    2