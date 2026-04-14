#macro MEDAL_VERSION  "1.0.0"
#macro MEDAL_DATE     "2026-04-13"

#macro MEDAL_RUNNING_FROM_IDE  (GM_build_type == "run")

#macro MEDAL_ON_WINDOWS           (os_type == os_windows)
#macro MEDAL_ON_MACOS             (os_type == os_macosx)
#macro MEDAL_ON_LINUX             (os_type == os_linux)
#macro MEDAL_ON_DESKTOP           (MEDAL_ON_WINDOWS || MEDAL_ON_MACOS || MEDAL_ON_LINUX)
#macro MEDAL_ON_IOS               (os_type == os_ios)
#macro MEDAL_ON_ANDROID           (os_type == os_android)
#macro MEDAL_ON_XBOX_SERIES       (os_type == os_xboxseriesxs)
#macro MEDAL_ON_PS5               (os_type == os_ps5)
#macro MEDAL_ON_SWITCH            (os_type == os_switch)
#macro MEDAL_USING_STEAMWORKS     (MEDAL_ON_DESKTOP && extension_exists("Steamworks"))
#macro MEDAL_USING_GAMECENTER     (MEDAL_ON_IOS && extension_exists("GameCenter"))
#macro MEDAL_USING_PLAY_SERVICES  (MEDAL_ON_ANDROID && extension_exists("GooglePlayServices"))
#macro MEDAL_USING_WINDOWS_GDK    (MEDAL_ON_WINDOWS && extension_exists("GDKExtension"))
#macro MEDAL_USING_GDK            (MEDAL_ON_XBOX_SERIES || MEDAL_USING_WINDOWS_GDK)