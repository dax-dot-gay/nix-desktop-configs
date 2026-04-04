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
      pkgs.vlc
      pkgs.gimp
      pkgs.krita
      pkgs.swayimg
      pkgs.musicpod
    ];
    services.playerctld = {
      enable = true;
    };
}