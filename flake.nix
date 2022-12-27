{
  description = "Build a cargo project without extra checks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, crane, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        craneLib = crane.lib.${system};
        rust-flake-test = craneLib.buildPackage {
          src = craneLib.cleanCargoSource ./.;

          buildInputs = [
            # Add additional build inputs here
          ];
        };
      in
      {
        checks = {
          inherit rust-flake-test;
        };

        packages.default = rust-flake-test;

        apps.default = flake-utils.lib.mkApp {
          drv = rust-flake-test;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = builtins.attrValues self.checks;

          # Extra inputs can be added here
          nativeBuildInputs = with pkgs; [
            cargo
            rustc
          ];
        };
      }
    );
}