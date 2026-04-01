{
  lib,
  stdenv,
  bun2nix,
  basePath ? "/",
  ...
}:
stdenv.mkDerivation {
  pname = "surrealist-web";
  version = "3.7.3";

  src = lib.cleanSourceWith {
    src = ./..;
    filter = path: type: let
      baseName = baseNameOf path;
    in
      !(builtins.elem baseName [
        "node_modules"
        "dist"
        ".devenv"
        ".direnv"
        "target"
        "src-tauri"
        ".git"
        "result"
        ".claude"
      ]);
  };

  nativeBuildInputs = [
    bun2nix.hook
  ];

  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ../bun.nix;
  };

  dontUseBunBuild = true;
  dontUseBunInstall = true;

  buildPhase = ''
    export HOME=$TMPDIR
    export VITE_SURREALIST_DOCKER=true
    export VITE_BASE_PATH="${basePath}"
    bun run build
  '';

  installPhase = ''
    mkdir -p $out
    cp -r dist/* $out/
  '';

  meta = with lib; {
    description = "Surrealist - SurrealDB web interface";
    homepage = "https://github.com/surrealdb/surrealist";
  };
}
