{ lib, pkgs, ... }:
{
    programs.fastfetch.enable = true;
    programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
        installBatSyntax = true;
        installVimSyntax = true;
        systemd.enable = true;
        settings = {
            confirm-close-surface = false;
        };
    };
    programs.zsh = {
        enable = true;
        autocd = true;
        autosuggestion = {
            enable = true;
            strategy = [
                "completion"
                "history"
            ];
        };
        defaultKeymap = "emacs";
        enableCompletion = true;
        history.append = true;
        initContent =
            let
                zshRunCommands = lib.mkOrder 1500 ''
                    bindkey  "^[[H"   beginning-of-line
                    bindkey  "^[[F"   end-of-line
                    bindkey  "^[[3~"  delete-char
                    hyfetch
                '';
            in
            lib.mkMerge [
                zshRunCommands
            ];
        syntaxHighlighting.enable = true;
    };
    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
    };
    programs.oh-my-posh = {
        enable = true;
        enableZshIntegration = true;
        useTheme = "catppuccin_mocha";
    };
    programs.hyfetch = {
        enable = true;
        settings = {
            preset = "transgender";
            mode = "rgb";
            auto_detect_light_dark = true;
            light_dark = "dark";
            lightness = 0.65;
            color_align.mode = "vertical";
            backend = "fastfetch";
            args = null;
            distro = null;
            pride_month_disable = false;
            custom_ascii_path = null;
        };
    };
    home.packages = with pkgs; [
        devenv
        nixd
        nixfmt
    ];
    programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv = {
            enable = true;
        };
    };
    programs.git = {
        enable = true;
        settings = {
            user = {
                email = "git@dax.gay";
                name = "Dax Harris";
            };
            safe.directory = [
                "/etc/nixos"  
            ];
        };
    };
}
