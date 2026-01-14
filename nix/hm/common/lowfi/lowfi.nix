# Modified from https://github.com/NixOS/nixpkgs/pull/476944/
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  alsa-lib,
  alsa-plugins,
  makeWrapper,
  pipewire,
}:
rustPlatform.buildRustPackage rec {
  pname = "lowfi";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "lowfi";
    tag = version;
    hash = "sha256-RSdfZ0GrNhPcqDWutJW0VlplbpBNBCpSvw91fpl0d4E=";
  };

  cargoHash = "sha256-OAg3ZpBmuINkc6KZJGKvYFnpv9hVbwlnOEP5ICtYh28=";

  buildFeatures = lib.optionals stdenv.hostPlatform.isLinux [ "mpris" ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    alsa-plugins
  ];

  # fix non-nixos: wrap the binary to make it find the Pulse plugin + PipeWire compat reliably
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/lowfi \
      --set ALSA_PLUGIN_DIR "${alsa-plugins}/lib/alsa-lib" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          pipewire
          alsa-lib
        ]
      }"
  '';

  checkFlags = [
    # Skip this test as it doesn't work in the nix sandbox
    "--skip=tests::tracks::list::download"
  ];

  meta = {
    description = "Extremely simple lofi player";
    homepage = "https://github.com/talwat/lowfi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zsenai ];
    mainProgram = "lowfi";
  };
}
