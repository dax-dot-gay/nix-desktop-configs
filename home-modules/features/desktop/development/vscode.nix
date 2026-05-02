{ pkgs, nix-vscode-extensions, config, ... }:
let
    system = "x86_64-linux";
    extensions = nix-vscode-extensions.extensions.${system};
in
{
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        profiles.default = {
            extensions =
            (with extensions.open-vsx-release; [
                signageos.signageos-vscode-sops
                gavinleroy.argus
                ms-python.autopep8
                mads-hartmann.bash-ide-vscode
                washan.cargo-appraiser
                alexdauenhauer.catppuccin-noctis
                alexdauenhauer.catppuccin-noctis-icons
                llvm-vs-code-extensions.vscode-clangd
                ms-azuretools.vscode-containers
                vunguyentuan.vscode-css-variables
                mkhl.direnv
                ms-azuretools.vscode-docker
                cschlosser.doxdocgen
                usernamehw.errorlens
                dbaeumer.vscode-eslint
                waderyan.gitblame
                eamodio.gitlens
                lokalise.i18n-ally
                ms-vscode.live-server
                jnoortheen.nix-ide
                christian-kohler.path-intellisense
                esbenp.prettier-vscode
                yoavbls.pretty-ts-errors
                meta.pyrefly
                ms-python.python
                ms-python.debugpy
                ms-python.vscode-python-envs
                jscearcy.rust-doc-viewer
                rust-lang.rust-analyzer
                sibiraj-s.vscode-scss-formatter
                mrmlnc.vscode-scss
                belfz.search-crates-io
                tombi-toml.tombi
                redhat.vscode-yaml
                firefox-devtools.vscode-firefox-debug
                shd101wyy.markdown-preview-enhanced
                seyyedkhandon.firacode
                njpwerner.autodocstring
                github.vscode-github-actions
                vadimcn.vscode-lldb
                firefox-devtools.vscode-firefox-debug
                henriquebruno.github-repository-manager
                github.vscode-pull-request-github
            ])
            ++ (with extensions.vscode-marketplace-release; [
                kdl-org.kdl
                hediet.vscode-drawio
                chrisbeard.rustdocstring
            ]);
            userSettings = {
                "catppuccin-noctis-icons.hidesExplorerArrows" = false;
                "git.enableSmartCommit" = true;
                "git.confirmSync" = false;
                "git.autofetch" = true;
                "nix.enableLanguageServer" = true;
                "workbench.colorTheme" = "Catppuccin Noctis Mocha";
                "workbench.iconTheme" = "catppuccin noctis icons";
                "editor.tabSize" = 4;
                "editor.formatOnSave" = true;
                "editor.formatOnPaste" = true;
                "editor.formatOnSaveMode" = "modificationsIfAvailable";
                "nix.serverPath" = "nixd";
                "nix.serverSettings" = {
                    nixd = {
                        formatting = {
                            command = ["nixfmt"];
                        };
                    };
                };
                "[javascript]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[typescript]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[json]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[html]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[nix]" = {
                    "editor.tabSize" = 4;
                };
                "editor.fontFamily" = "'Fira Code', sans-serif";
                "terminal.integrated.fontFamily" = "'Fira Code', sans-serif";
                "terminal.integrated.fontLigatures.enabled" = true;
                "editor.fontLigatures" = true;
                "sops.defaults.ageKeyFile" = "/home/${config.homeflake.info.username}/.config/sops/age/keys.txt";
                "editor.detectIndentation" = false;
            };
        };
        
    };
}
