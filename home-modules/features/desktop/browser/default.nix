{ pkgs, ... }:
{
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
                "webgl.disabled" = false;
                "webgl.force-enabled" = true;
                "identity.fxaccounts.enabled" = true;
                "media.eme.enabled" = true;
                "browser.urlbar.suggest.searches" = true;
                "browser.search.suggest.enabled" = true;
                "browser.urlbar.quicksuggest.enabled" = true;
                "browser.download.useDownloadDir" = true;
                "privacy.resistFingerprinting" = false;
                "browser.theme.content-theme" = 0;
                "browser.theme.toolbar-theme" = 0;
                "extensions.autoDisableScopes" = 0;
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
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
                    catppuccin-mocha-mauve
                    steam-database
                    mtab
                    pkgs.nur.repos.rycee.firefox-addons."2fas-two-factor-authentication"
                    zoom-redirector
                ];
                settings."contact@maxhu.dev".settings = builtins.fromJSON (builtins.readFile ./mtab.json);
                force = true;
            };
            userChrome = ''
                #TabsToolbar {
                    visibility: collapse;
                }
            '';
        };
    };
}
