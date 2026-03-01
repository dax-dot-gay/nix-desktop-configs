{ pkgs, ... }:
{
    imports = [
        ./shell.nix
        ./vscode.nix
    ];
    config = {
        home.packages = with pkgs; [
            devenv
        ];
        programs.direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv = {
                enable = true;
                enableFlakes = true;
            };
        };
        programs.git = {
            enable = true;
            settings = {
                user = {
                    email = "git@dax.gay";
                    name = "Dax Harris";
                };
            };
        };
    };
}
