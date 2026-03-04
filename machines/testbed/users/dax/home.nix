{ ... }:
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
            gestures.hot-corners = [ ];
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
                    { proportion = 0.33333; }
                    { proportion = 0.5; }
                    { proportion = 0.66667; }
                ];
                default-column-width = {
                    proportion = 0.5;
                };
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
                        open-on-output = "DP-2";
                        open-floating = true;
                        default-column-width = {proportion = 0.6;};
                        default-window-height = {proportion = 0.6;};
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
                ghostty = {
                    match = [
                        {app-id = "com.mitchellh.ghostty";}
                    ];
                    dynamic.opacity = 0.95;
                };
                always-fullscreen = {
                    match = [
                        {app-id = "floorp";}
                        {app-id = "org.mozilla.Thunderbird";}
                    ];
                    exclude = [
                        {title = "Message Filters";}
                    ];
                    on-open.open-maximized = true;
                };
                chat-windows = {
                    match = [
                        {app-id = "equibop";}
                        {app-id = "cinny";}
                    ];
                    on-open = {
                        open-maximized = true;
                        open-on-output = "DP-3";
                    };
                };
                password-managers = {
                    match = [
                        {app-id = "org.keepassxc.KeePassXC";}
                    ];
                    dynamic.block-out-from = "screen-capture";
                };
                rounded-corners = {
                    dynamic = {
                        geometry-corner-radius = 4;
                        clip-to-geometry = true;
                    };
                };
            };
            layer-rules = {
                awww-daemon = {
                    match = [
                        {namespace = "awww-daemon";}
                    ];
                    place-within-backdrop = true;
                };
            };
            binds = {
                "Mod+Return" = {
                    hotkey-overlay-title = "Open a Terminal";
                    action.spawn.args = ["ghostty"];
                };
                "Mod+D" = {
                    hotkey-overlay-title = "Open App Launcher";
                    action.spawn.args = ["vicinae" "toggle"];
                };
                "Super+L" = {
                    hotkey-overlay-title = "Lock the Screen";
                    action.spawn.args = ["dms" "ipc" "lock" "lock"];
                };
                "Mod+N" = {
                    action.spawn.args = ["nemo"];
                };
                XF86AudioRaiseVolume = {
                    action.spawn-sh = {
                        allow-when-locked = true;
                        command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
                    };
                };
                XF86AudioLowerVolume = {
                    action.spawn-sh = {
                        allow-when-locked = true;
                        command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
                    };
                };
                XF86AudioMute = {
                    action.spawn-sh = {
                        allow-when-locked = true;
                        command = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                    };
                };
                XF86AudioMicMute = {
                    action.spawn-sh = {
                        allow-when-locked = true;
                        command = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
                    };
                };
                XF86AudioPlay = {
                    action.spawn-sh = {
                        allow-when-locked = true;
                        command = "playerctl play-pause";
                    };
                };
                XF86AudioStop = {
                    action.spawn-sh = {
                        allow-when-locked = true;
                        command = "playerctl stop";
                    };
                };
                XF86AudioPrev = {
                    action.spawn-sh = {
                        allow-when-locked = true;
                        command = "playerctl previous";
                    };
                };
                XF86AudioNext = {
                    action.spawn-sh = {
                        allow-when-locked = true;
                        command = "playerctl next";
                    };
                };
                XF86MonBrightnessUp = {
                    action.spawn-sh = {
                        allow-when-locked = true;
                        command = "brightnessctl --class=backlight set +10%";
                    };
                };
                XF86MonBrightnessDown = {
                    action.spawn-sh = {
                        allow-when-locked = true;
                        command = "brightnessctl --class=backlight set 10%-";
                    };
                };
                "Mod+O" = {
                    repeat = false;
                    action.toggle-overview = {};
                };
                "Mod+C" = {
                    repeat = false;
                    action.close-window = {};
                };
            };
        };
    };
}
