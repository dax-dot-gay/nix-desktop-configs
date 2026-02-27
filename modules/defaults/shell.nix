{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        cargo
        rustc
        rustPlatform.bindgenHook
        pkg-config
        bashInteractive
        unar
        zip
        xz
        gzip
        file-roller
        wget
        curl
        openssl
        python3
        pnpm
        imagemagick
        ffmpeg-full
        btop
        ghostty.terminfo
        gitui
        yazi
        zellij
        bat
        lsd
    ];
    programs.git = {
        enable = true;
    };
    programs.neovim = {
        enable = true;
        defaultEditor = true;
    };
    programs.zsh = {
        enable = true;
    };
}
