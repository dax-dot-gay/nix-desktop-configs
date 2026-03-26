{
    lib,
    stdenv,
    fetchgit,
    qtbase,
    wrapQtAppsHook,
    knotifications,
    zip,
    which,
    git,
    x11extras
}:
stdenv.mkDerivation rec {
    name = "systray-x";

    src = fetchgit {
        url = "https://github.com/Ximi1970/systray-x.git";
        rev = "0.9.11";
        sha256 = "sha256-xB1zPHHBQXW4c6klpFxzIUciKkFADZ+kCJOIyu2tDWs=";
        leaveDotGit = true;
    };

    buildInputs = [
        qtbase
        knotifications
        x11extras
    ];
    nativeBuildInputs = [
        zip
        wrapQtAppsHook
        which
        git
    ];

    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/lib/mozilla/native-messaging-hosts
        mkdir -p $out/lib/mozilla/thunderbird-addons/extensions
        mv systray-x@Ximi1970.xpi $out/lib/mozilla/thunderbird-addons/extensions
        mv SysTray-X $out/bin
        sed -i s@/path/to/native-messaging/app@$out/bin@ app/SysTray_X.json
        mv app/SysTray_X.json $out/lib/mozilla/native-messaging-hosts
    '';

    meta = with lib; {
        description = "A system tray extension for Thunderbird 68+";
        longDescription = ''
            The addon uses the WebExtension API's to control an external system dependent system tray application.
            Needs both the addon AND the companion app installed to work.
            Will not work with full wayland desktops.
        '';
        homepage = "https://github.com/Ximi1970/systray-x";
        license = licenses.mpl20;
        maintainers = [ maintainers.zahrun ];
        platforms = platforms.all;
    };
}
