{ lib, pkgs, ... }:
{
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    boot.loader.limine = {
        enable = true;
        efiSupport = true;
        maxGenerations = 3;
    };
    boot.loader.timeout = null;
    boot.loader.efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
    };
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.initrd.systemd.enable = true;
    environment.systemPackages = [pkgs.sbctl];
    boot.consoleLogLevel = 3;
    boot.initrd.verbose = false;
    boot.kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
        "kms"
    ];
}
