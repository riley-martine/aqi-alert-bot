{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, naersk, pre-commit-hooks }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) { inherit system; };
        naersk' = pkgs.callPackage naersk { };
        libs = with pkgs;
          [ openssl ] ++ lib.optionals stdenv.isDarwin [
            libiconv
            darwin.apple_sdk.frameworks.SystemConfiguration
          ];
      in {
        packages = {
          default = naersk'.buildPackage {
            src = ./.;
            nativeBuildInputs = with pkgs; [ pkg-config ];
            buildInputs = libs;
          };
        };

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt.enable = true;
              rustfmt.enable = true;
              cargo-check.enable = true;
            };
          };
        };

        devShell = with pkgs;
          mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            packages = [
              rustc
              cargo
              rustfmt
              rustPackages.clippy
              nixfmt
              rust-analyzer
              pre-commit
              direnv
            ] ++ libs;

            RUST_SRC_PATH = rustPlatform.rustLibSrc;
          };
      });
}
