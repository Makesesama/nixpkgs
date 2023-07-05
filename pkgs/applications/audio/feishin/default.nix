{ lib
, fetchurl
, appimageTools
}:

let
  pname = "feishin";
  version = "0.2.0";
  src = fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/v${version}/Feishin-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-BvdndYr6RiqsOSgNcL70x9smZVQU5nDFx+wxGdRy//k=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Full-featured Subsonic/Jellyfin compatible desktop music player";
    homepage = "https://github.com/jeffvli/feishin";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Makesesama ];
    platforms = [ "x86_64-linux" ];
  };
}
