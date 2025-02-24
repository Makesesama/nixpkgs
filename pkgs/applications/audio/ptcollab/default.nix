{ mkDerivation
, lib
, stdenv
, fetchFromGitHub
, nix-update-script
, libvorbis
, pkg-config
, qmake
, qtbase
, qttools
, qtmultimedia
, rtmidi
}:

mkDerivation rec {
  pname = "ptcollab";
  version = "0.6.4.6";

  src = fetchFromGitHub {
    owner = "yuxshao";
    repo = "ptcollab";
    rev = "v${version}";
    hash = "sha256-G0QQV0mvrrBAC2LSy45/NnEbHHA8/E0SZKJXvuVidRE=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
  ];

  buildInputs = [
    libvorbis
    qtbase
    qtmultimedia
    rtmidi
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Move appbundles to Applications before wrapping happens
    mkdir $out/Applications
    mv $out/{bin,Applications}/ptcollab.app
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Link to now-wrapped binary inside appbundle
    ln -s $out/{Applications/ptcollab.app/Contents/MacOS,bin}/ptcollab
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Experimental pxtone editor where you can collaborate with friends";
    homepage = "https://yuxshao.github.io/ptcollab/";
    license = licenses.mit;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
