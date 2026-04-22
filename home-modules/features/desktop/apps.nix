{ pkgs, nix-obsidian-plugins, ... }:
{
    home.packages = with pkgs; [
        feishin
        cinny-desktop
        equibop
        delfin
        libreoffice-fresh
    ];
    services.syncthing = {
        enable = true;
        tray.enable = true;
    };
    xdg.autostart = {
        enable = true;
        entries = [
          "${pkgs.keepassxc}/share/applications/org.keepassxc.KeePassXC.desktop"
          "${pkgs.equibop}/share/applications/equibop.desktop"
          "${pkgs.cinny-desktop}/share/applications/Cinny.desktop"
        ];
    };
    programs.obsidian = {
        enable = true;
        vaults = {
            Test = {
                enable = true;
                settings = {
                    appearance = {
                        cssTheme = "Catppuccin";
                        theme = "obsidian";
                        textFontFamily = "Inter";
                        interfaceFontFamily = "Inter";
                        monospaceFontFamily = "Source Code Pro";
                    };
                    themes = [
                        {
                            enable = true;
                            pkg = nix-obsidian-plugins.packages.theme-catppuccin;
                        }
                    ];
                    communityPlugins = [
                        {
                            enable = true;
                            pkg = nix-obsidian-plugins.packages.plugin-obsidian-style-settings;
                        }
                    ];
                };
            };
        };
    };
}
