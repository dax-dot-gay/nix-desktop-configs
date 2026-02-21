{ lib, ... }:
{
  boot.loader.systemd-boot = {
    enable = true;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
