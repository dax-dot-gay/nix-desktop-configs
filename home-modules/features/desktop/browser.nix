{ nur, pkgs, ... }:
{
    nixpkgs.overlays = [ nur.overlays.default ];
    programs.librewolf = {
        enable = true;
        profiles.default = {
            containers = {
                RIT = {
                    id = 1;
                    color = "orange";
                    icon = "circle";
                };
            };
            containersForce = true;
            search = {
                default = "ddg";
                privateDefault = "ddg";
                force = true;
            };
            settings = {
                "webgl.disable" = false;
                "identity.fxaccounts.enabled" = true;
                "media.eme.enabled" = true;
                "browser.urlbar.suggest.searches" = true;
                "browser.search.suggest.enabled" = true;
                "browser.urlbar.quicksuggest.enabled" = true;
                "browser.download.useDownloadDir" = true;
            };
            extensions = {
                packages = with pkgs.nur.repos.rycee.firefox-addons; [
                    ublock-origin
                    sidebery
                    keepassxc-browser
                    privacy-badger
                    sponsorblock
                    stylus
                    web-developer
                    react-devtools
                ];
                settings."uBlock0@raymondhill.net".settings = {
                    selectedFilterLists = [
                        "ublock-filters"
                        "ublock-badware"
                        "ublock-privacy"
                        "ublock-unbreak"
                        "ublock-quick-fixes"
                    ];
                };
            };
        };
    };
}
