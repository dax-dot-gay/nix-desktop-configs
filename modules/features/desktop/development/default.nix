{ pkgs, ... }:
{
    imports = [
        ./vscode.nix
    ];
    environment.systemPackages = with pkgs; [
        android-tools
        rpi-imager
    ];
}
