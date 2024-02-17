{ lib
, fetchFromGitHub
, rustPlatform
, copyDesktopItems
, wrapGAppsHook
, pkg-config
, openssl
, dbus
, glib
, glib-networking
, libayatana-appindicator
, webkitgtk
, makeDesktopItem
}:

rustPlatform.buildRustPackage rec {
  pname = "gitbutler";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    rev = "release/${version}";
    hash = "sha256-v5D0/EHVQ2xo7TGo+jZoRDBVFczkaZu2ka6QpwV4dpw=";
  };

  sourceRoot = "${src.name}";

  # modififying $cargoDepsCopy requires the lock to be vendored
  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

/*
  postInstall = ''
    install -DT icons/128x128@2x.png $out/share/icons/hicolor/256x256@2/apps/cinny.png
    install -DT icons/128x128.png $out/share/icons/hicolor/128x128/apps/cinny.png
    install -DT icons/32x32.png $out/share/icons/hicolor/32x32/apps/cinny.png
  '';
*/

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook
    pkg-config
  ];

  buildInputs = [
    openssl
    dbus
    glib
    glib-networking
    libayatana-appindicator
    webkitgtk
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "GitButler";
      exec = "git-butler-nightly";
      icon = "gitbutler";
      desktopName = "GitButler";
      genericName = "Git Client";
      comment = meta.description;
      categories = [ "Development" ];
    })
  ];

  meta = with lib; {
    description = " The GitButler version control client, backed by Git";
    homepage = "https://gitbutler.com/";
    maintainers = [ ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "git-butler-nightly";
  };
}
