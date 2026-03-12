{ ... }:
{
    wayland.windowManager.niri.settings = {
        outputs = {
            "DP-2" = {
                mode = "2560x1440@240";
                scale = 1;
                transform = "normal";
                position = {
                    x = 3640;
                    y = 480;
                };
            };
            "DP-1" = {
                mode = "2560x1440@240";
                scale = 1;
                transform = "normal";
                position = {
                    x = 1080;
                    y = 480;
                };
            };
            "HDMI-A-2" = {
                mode = "1920x1080@60";
                scale = 1;
                transform = "270";
                position = {
                    x = 0;
                    y = 0;
                };
            };
        };
        window-rules = {
            chat-windows = {
                match = [
                    { app-id = "equibop"; }
                    { app-id = "cinny"; }
                    { app-id = "Element"; }
                ];
                on-open = {
                    open-maximized = true;
                    open-on-output = "DP-2";
                };
            };
            floating-windows = {
                match = [
                    { app-id = "com.mitchellh.ghostty"; }
                    { app-id = "nemo"; }
                    { app-id = "syncthingtray-qt6"; }
                    { app-id = "KeePassXC"; }
                    { app-id = "harmonymusic"; }
                    { app-id = "feishin"; }
                    { app-id = "xdg-desktop-portal-gtk"; }
                    {
                        app-id = "org.mozilla.Thunderbird";
                        title = "Message Filters";
                    }
                ];
                on-open = {
                    open-on-output = "DP-1";
                    open-floating = true;
                    default-column-width = {
                        proportion = 0.6;
                    };
                    default-window-height = {
                        proportion = 0.6;
                    };
                    open-focused = true;
                };

                dynamic = {
                    border = {
                        enable = true;
                        width = 2;
                        active-color = "#cba6f7";
                        inactive-color = "#cba6f7aa";
                    };
                };
            };
        };
    };
}
