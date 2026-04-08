{ ... }:
{
    wayland.windowManager.niri.settings = {
        outputs = {
            "eDP-1" = {
                mode = "1920x1080@60";
                scale = 1;
                position = {
                    x = 0;
                    y = 0;
                };
            };
        };
        window-rules = {
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
