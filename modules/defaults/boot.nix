{ lib, pkgs, ... }:
{
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    boot.loader.limine = {
        enable = true;
        efiSupport = true;
    };
    boot.loader.efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
    };
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.initrd.systemd.enable = true;
    environment.systemPackages = [pkgs.sbctl];
}
