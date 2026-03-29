{
    pkgs,
    lib,
    config,
    ...
}:
with lib;
let
    cfg = config.homeflake.browser;
in
{
    options.homeflake.browser = {
        librewolf = {
            enable = mkEnableOption "Enable Librewolf";
            features = {
                keepSiteData = mkEnableOption "Allow saving cookies & storage on close";
                webgl = mkEnableOption "Enable WebGL";
            };
        };
        floorp = {
            enable = mkEnableOption "Enable Floorp";
            extraExtensions = mkOption {
                type = types.listOf types.package;
                default = [ ];
                description = "List of additional extension packages to add";
            };
        };
        chromium = {
            enable = mkEnableOption "Enable Chromium";
        };
    };
    config = {
        programs.librewolf = mkIf cfg.librewolf.enable {
            enable = true;
            profiles.default = {
                search = {
                    default = "ddg";
                    privateDefault = "ddg";
                    force = true;
                };
                settings = {
                    "browser.theme.content-theme" = 0;
                    "browser.theme.toolbar-theme" = 0;
                    "extensions.autoDisableScopes" = 0;
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                    "extensions.activeThemeId" = "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}";
                    "privacy.clearOnShutdown_v2.cookiesAndStorage" = cfg.librewolf.features.keepSiteData;
                }
                // optionalAttrs cfg.librewolf.features.webgl {
                    "webgl.disable" = false;
                    "webgl.disabled" = false;
                    "webgl.force-enabled" = true;
                };
                extensions = {
                    packages = with pkgs.nur.repos.rycee.firefox-addons; [
                        ublock-origin
                        sidebery
                        privacy-badger
                        catppuccin-mocha-mauve
                    ];
                    force = true;
                };
                userChrome = ''
                    #TabsToolbar {
                        visibility: collapse;
                    }
                '';
            };
        };
        programs.floorp = mkIf cfg.floorp.enable {
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
                    order = [
                        "ddg"
                        "wikipedia"
                        "github"
                        "nixos-wiki"
                        "nix-packages"
                    ];
                    engines = {
                        nix-packages = {
                            name = "Nix Packages";
                            urls = [
                                {
                                    template = "https://search.nixos.org/packages";
                                    params = [
                                        {
                                            name = "type";
                                            value = "packages";
                                        }
                                        {
                                            name = "query";
                                            value = "{searchTerms}";
                                        }
                                    ];
                                }
                            ];

                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                            definedAliases = [ "@np" ];
                        };

                        nixos-wiki = {
                            name = "NixOS Wiki";
                            urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
                            definedAliases = [ "@nw" ];
                        };

                        wikipedia = {
                            name = "Wikipedia";
                            urls = [ { template = "https://en.wikipedia.org/w/index.php?search={searchTerms}"; } ];
                            iconMapObj."16" = "https://en.wikipedia.org/favicon.ico";
                            definedAliases = [ "@w" ];
                        };

                        github = {
                            name = "GitHub";
                            urls = [ { template = "https://github.com/search?q={searchTerms}"; } ];
                            iconMapObj."16" = "https://github.com/favicon.ico";
                            definedAliases = [ "@gh" ];
                        };

                        bing.metaData.hidden = true;
                        google.metaData.hidden = true;
                    };
                };
                settings = {
                    "browser.theme.content-theme" = 0;
                    "browser.theme.toolbar-theme" = 0;
                    "extensions.autoDisableScopes" = 0;
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                    "extensions.activeThemeId" = "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}";
                    "browser.startup.homepage" = "moz-extension://7c610911-d844-4f0e-af33-70b3ac4b4e05/index.html";
                    "browser.startup.homepage_override.extensionControlled" = true;
                    "browser.startup.homepage_override.privateAllowed" = false;
                    "services.sync.declinedEngines" = "prefs,passwords,addons,addresses,creditcards";
                    "privacy.resistFingerprinting" = true;
                };
                extensions = {
                    packages =
                        with pkgs.nur.repos.rycee.firefox-addons;
                        [
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
                        ]
                        ++ cfg.floorp.extraExtensions;
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
        programs.chromium.enable = cfg.chromium.enable;
    };
}
