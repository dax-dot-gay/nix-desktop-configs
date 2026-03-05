{pkgs, ...}: {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    environment.systemPackages = [
      pkgs.pwvucontrol
    ];
    services.playerctld = {
      enable = true;
    };
    services.mpris-proxy.enable = true;
}