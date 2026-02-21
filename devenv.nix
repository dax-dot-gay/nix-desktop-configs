{
    pkgs,
    ...
}:

{
    packages = with pkgs; [
        git
        nixos-anywhere
        openssh
        ssh-to-age
        sops
        nixd
        nixfmt-rfc-style
    ];
}
