{ pkgs, config, ... }:
{
    environment.systemPackages = [
        pkgs.hydroxide
    ];
}
