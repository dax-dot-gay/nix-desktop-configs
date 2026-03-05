{ lib, pkgs, ... }:
let
    register =
        {
            name,
            script,
            interval ? "30s",
        }:
        {
            timers."sysinfo-${name}" = {
                wantedBy = [ "timers.target" ];
                timerConfig = {
                    OnBootSec = "${interval}";
                    OnUnitActiveSec = "${interval}";
                    Unit = "sysinfo-${name}.service";
                };
            };
            services."sysinfo-${name}" = {
                script = ''
                    SCRIPT="${pkgs.writeShellScriptBin "sysinfo-executer-${name}" script}/bin/sysinfo-executer-${name}"
                    OUTPUT=$($SCRIPT)
                    echo "$OUTPUT" > /run/sysinfo/${name}
                    chmod 755 /run/sysinfo/${name}
                '';
                path = ["/run/current-system/sw"];
                serviceConfig = {
                    Type = "oneshot";
                    User = "root";
                };
            };
        };
in
{
    systemd = (lib.mkMerge [
        {
            tmpfiles.rules = [
            "d /run/sysinfo 0755 root root"
        ];
        }
        (register {
            name = "count-generations";
            script = "nix-env --list-generations --profile /nix/var/nix/profiles/system-profiles/comin | wc -l";
        })
    ]);
}
