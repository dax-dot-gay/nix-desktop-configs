{ pkgs, ... }:
{
    nixpkgs = {
         overlays = [
            (self: super: {
               thunderbird = super.symlinkJoin {
                 name = "thunderbird-gui-wrap";
                 paths = [ super.thunderbird ];
                 buildInputs = [ super.makeWrapper ];
                 postBuild = ''
                   wrapProgram $out/bin/thunderbird \
                     --run 'systemctl --user start thunderbird-gui'
                 '';
               };
            })
         ];
    };
    home.packages = with pkgs; [
        protonmail-bridge-gui
        birdtray
    ];
    programs.thunderbird = {
        enable = true;
        profiles.default = {
            isDefault = true;
            extensions = with pkgs.nur.repos.rycee.thunderbird-addons; [
                send-later
                tbkeys
                filtaquilla
                filter-manager
                manually-sort-folders
            ];
        };
    };
    systemd.user.services.thunderbird-monitor = {
         Unit = {
            Description = "Mozilla Thunderbird Monitoring service";
         };
         Service = {
            # I also use connman, so I delay starting Thunderbird-headless until WAN-connectivity is up
            ExecStart = "${pkgs.thunderbird}/bin/.thunderbird-wrapped__ --headless";
            Restart = "on-failure";
         };
         Install.WantedBy = [ "default.target" ];
      };
      systemd.user.services.thunderbird-gui = {
         Unit = {
            Description = "Mozilla Thunderbird GUI service";
            Conflicts = "thunderbird-monitor.service";
            After = "thunderbird-monitor.service";
         };
         Service = {
            Type = "notify";
            NotifyAccess = "all";
            ExecStart = let
               # Best-effort guess when Thunderbird is "ready" (i.e. started up
               # enough to reject subsequent instance starts), as subsequent
               # thunderbird invocations shouldn't spawn a new-instance but
               # can change the active instance (i.e. thunderbird -mail)
               thunderbird-gui = pkgs.writeShellScriptBin "thunderbird-gui" ''
                  ${pkgs.thunderbird}/bin/.thunderbird-wrapped__ &
                  pid="$!"
                  sleep 3
                  systemd-notify --ready
                  wait "$pid"
               '';
            in "${thunderbird-gui}/bin/thunderbird-gui";
            ExecStopPost = "systemctl --user --no-block start thunderbird-monitor";
         };
      };

      wayland.windowManager.niri.settings.spawn-at-startup = [
         "sleep 5; ${pkgs.birdtray}/bin/birdtray"
         "${pkgs.protonmail-bridge-gui}/bin/protonmail-bridge-gui"
      ];
}
