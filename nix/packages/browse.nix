{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "browse";
  version = "0.7.3";

  src = fetchurl {
    url = "https://registry.npmjs.org/browse/-/browse-${version}.tgz";
    hash = "sha256-tjj8H1YhgG4suKTtLKEUYyehfHtA/GwuQpyeWK9rZjo=";
  };

  postPatch = ''
    cp ${./browse-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-rTtSy97v+UlrVSsBEH7HZ1kiXulYXg9gUcNqxnnvq/o=";

  dontNpmBuild = true;

  meta = {
    description = "Unified Browserbase CLI for browser automation and cloud APIs";
    homepage = "https://github.com/browserbase/skills";
    license = lib.licenses.mit;
    mainProgram = "browse";
    platforms = lib.platforms.all;
  };
}