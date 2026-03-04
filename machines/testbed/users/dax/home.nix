{...}:
{
    wayland.windowManager.niri = {
        enable = true;
        variant = "stable";
        settings = {
            input = {
                keyboard.numlock = true;
                touchpad.enable = false;
                mouse.enable = true;
                trackball.enable = false;
                trackpoint.enable = false;
                focus-follows-mouse = {
                    max-scroll-amount = "0%";
                };
            };
            gestures.hot-corners = [];
            prefer-no-csd = true;
            outputs = {
                "DP-3" = {
                    mode = "1920x1080@60";
                    scale = 1;
                    transform = "270";
                    position = {
                        x = 0;
                        y = 0;
                    };
                };
                "DP-2" = {
                    mode = "2560x1440@59.951";
                    scale = 1;
                    transform = "normal";
                    position = {
                        x = 1080;
                        y = 480;
                    };
                };
                "HDMI-A-1" = {
                    mode = "1920x1080@60";
                    scale = 1;
                    transform = "normal";
                    position = {
                        x = 3640;
                        y = 840;
                    };
                };
            };
            layout = {
                background-color = "#00000022";
                gaps = 4;
                center-focused-column = "never";
                preset-column-widths = [
                    {proportion = 0.33333;}
                    {proportion = 0.5;}
                    {proportion = 0.66667;}
                ];
                default-column-width = {proportion = 0.5;};
                focus-ring.enable = false;
                border.enable = false;
                shadow.enable = false;
            };
            hotkey-overlay.skip-at-startup = true;
            environment = {
                XDG_CURRENT_DESKTOP = "GNOME";
                QT_QPA_PLATFORMTHEME = "gtk3";
            };
            spawn-at-startup = [
                "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
                "wl-paste --watch cliphist store"
                "vicinae server"
            ];
            screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
            window-rules = {
                "auto-float" = {
                    match = {
                        
                    };
                };
            };
        };
    };
}
