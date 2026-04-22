{ pkgs, nix-obsidian-plugins, currentSystem, ... }:
let
    plugins = nix-obsidian-plugins.plugins.${currentSystem};
    themes = nix-obsidian-plugins.themes.${currentSystem};
in
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
                            pkg = themes.catppuccin;
                        }
                    ];
                    communityPlugins = [
                        {
                            enable = true;
                            pkg = plugins.obsidian-style-settings;
                        }
                    ];
                };
            };
        };
    };
}
