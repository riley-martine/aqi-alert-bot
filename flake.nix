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
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = pkgs.callPackage naersk { };
      in {
        defaultPackage = naersk-lib.buildPackage ./.;
        # buildInputs = [ openssl libiconv ];
        # nativeBuildInputs = with pkgs; [ pkg-config ];

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt.enable = true;
              rustfmt.enable = true;
            };
          };
        };

        devShell = with pkgs;
          mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            packages = [
              nixfmt
              rustfmt
              rustPackages.clippy
              rust-analyzer
              pre-commit
              cargo
              rustc
            ];
            RUST_SRC_PATH = rustPlatform.rustLibSrc;
          };
      });
}
