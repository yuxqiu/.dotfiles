# Modified from https://github.com/fclaeys/nix-nerd-dictation/blob/main/package.nix
{ pkgs }:

let
  inherit (pkgs)
    lib stdenv fetchFromGitHub fetchurl fetchPypi python3 python3Packages
    makeWrapper autoPatchelfHook unzip pulseaudio sox pipewire dotool
    gcc-unwrapped;

  vosk-model-en-us-lgraph = stdenv.mkDerivation {
    pname = "vosk-model-en-us-lgraph";
    version = "0.22";

    src = fetchurl {
      url =
        "https://alphacephei.com/vosk/models/vosk-model-en-us-0.22-lgraph.zip";
      hash = "sha256-2YOLSqqCp1xKF/WsowDqyhKaqrKny/lRuvu1AOucQzQ=";
    };

    nativeBuildInputs = [ unzip ];

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
      mkdir -p $out/share/vosk-models
      cp -r vosk-model-en-us-0.22-lgraph $out/share/vosk-models/
    '';

    meta = with lib; {
      description = "Medium English VOSK speech recognition model";
      homepage = "https://alphacephei.com/vosk/";
      license = licenses.asl20;
    };
  };
  vosk = python3Packages.buildPythonPackage rec {
    pname = "vosk";
    version = "0.3.45";
    format = "wheel";

    src = fetchPypi {
      inherit pname version format;
      dist = "py3";
      python = "py3";
      abi = "none";
      platform = if stdenv.isAarch64 then
        "manylinux2014_aarch64"
      else
        "manylinux_2_12_x86_64.manylinux2010_x86_64";
      hash = if stdenv.isAarch64 then
        "sha256-VO+0fdiQ5UTp4g8DFkE6zsf4aA0E7AlcYUCrTnAmJwQ="
      else
        "sha256-JeAlCTxDmdcnj1Q1aO2MxUYKw6S/SMI2c6zh4l0mYZ8=";
    };

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [ gcc-unwrapped.lib ];

    propagatedBuildInputs = with python3Packages; [ cffi requests tqdm srt ];

    doCheck = false;

    meta = with lib; {
      description = "Offline speech recognition API";
      homepage = "https://alphacephei.com/vosk/";
      license = licenses.asl20;
    };
  };

  pythonWithVosk = python3.withPackages (ps: with ps; [ vosk setuptools ]);

in stdenv.mkDerivation {
  pname = "nerd-dictation";
  version = "unstable-2025-10-10";

  src = fetchFromGitHub {
    owner = "ideasman42";
    repo = "nerd-dictation";
    rev = "41f372789c640e01bb6650339a78312661530843";
    sha256 = "1sx3s3nzp085a9qx1fj0k5abcy000i758xbapp6wd4vgaap8fdn6";
  };

  nativeBuildInputs = [ pythonWithVosk makeWrapper ];

  propagatedBuildInputs = [ pythonWithVosk vosk-model-en-us-lgraph ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/nerd-dictation

    # Copy all source files
    cp -r . $out/share/nerd-dictation/

    # Create wrapper script with model path and dependencies
    cat > $out/bin/nerd-dictation << EOF
    #!${stdenv.shell}

    # Add audio and input tools to PATH
    export PATH="${lib.makeBinPath [ pulseaudio sox pipewire dotool ]}:\$PATH"

    # Check if command needs model and input tool defaults
    needs_model=false
    model_specified=false
    input_tool_specified=false

    for arg in "\$@"; do
        if [[ "\$arg" == "begin" ]]; then
            needs_model=true
        fi
        if [[ "\$arg" == --vosk-model-dir* ]]; then
            model_specified=true
        fi
        if [[ "\$arg" == --simulate-input-tool* ]]; then
            input_tool_specified=true
        fi
    done

    # Add model path if command needs it and not already specified
    if [ "\$needs_model" = true ] && [ "\$model_specified" = false ]; then
        set -- "\$@" --vosk-model-dir="${vosk-model-en-us-lgraph}/share/vosk-models/vosk-model-en-us-0.22-lgraph"
    fi

    # Set input tool for Wayland
    if [ "\$input_tool_specified" = true ]; then
        set -- "\$@" --simulate-input-tool=DOTOOL
    fi

    exec ${pythonWithVosk}/bin/python3 $out/share/nerd-dictation/nerd-dictation "\$@"
    EOF

    chmod +x $out/bin/nerd-dictation

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple, hackable offline speech to text";
    longDescription = ''
      nerd-dictation is a tool for offline speech-to-text. It uses VOSK for
      speech recognition and provides a simple interface for converting speech
      to text input in various applications. This package includes VOSK and
      a English language model (vosk-model-en-us-0.22-lgraph).
    '';
    homepage = "https://github.com/ideasman42/nerd-dictation";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "nerd-dictation";
  };
}
