{ hm_args, ... }:
let
    inputs = hm_args.inputs;
in
{
    imports = [
        inputs.catppuccin.homeModules.catppuccin
        inputs.dms.homeModules.dank-material-shell
        ./style
    ];
}
