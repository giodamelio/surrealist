{
  description = "Surrealist - SurrealDB web UI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    bun2nix = {
      url = "github:nix-community/bun2nix?ref=2.0.8";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = inputs: let
    eachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
    pkgsFor = eachSystem (
      system:
        import inputs.nixpkgs {
          inherit system;
          overlays = [inputs.bun2nix.overlays.default];
        }
    );
  in {
    packages = eachSystem (system: {
      default = pkgsFor.${system}.callPackage ./nix/package.nix {};
    });

    devShells = eachSystem (system: {
      default = pkgsFor.${system}.mkShell {
        packages = with pkgsFor.${system}; [
          # JS
          bun
          bun2nix

          # Rust (for tauri dev)
          rustc
          cargo

          # Nix
          alejandra

          # Native deps for tauri
          pkg-config
          glib
          pango
          libsoup_3
          webkitgtk_4_1
        ];
      };
    });
  };
}
