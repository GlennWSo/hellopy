{
  inputs =  {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url = "mach-nix/3.5.0";

  };
  inputs.rust-overlay =  {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  outputs = { self, nixpkgs, flake-utils, mach-nix, rust-overlay }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay)];
        pkgs = import nixpkgs {
          inherit overlays system;
        };
        py = pkgs.python39Packages;
        mach = mach-nix.lib.${system};
        setupRust = py.setuptools-rust;
        rust = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;

        defaultPack = pkgs.callPackage ./default.nix { 
          buildPythonPackage= py.buildPythonPackage;
          lib = pkgs.lib;
          rustPlatform = pkgs.rustPlatform;
          setuptools-rust = py.setuptools-rust;
        };

         

        pyEnv = mach.mkPython {
          requirements = ''
            ipython
            pyvista
          '';
          providers = {
            _default = "wheel,nixpkgs,conda,sdist";
            pyvista = "wheel";
          };
          packagesExtra = [
          ];
        };
       
      in
        {
          packages.default =  defaultPack;

          devShell = pkgs.mkShell{
            name = "pyrust";
            buildInputs = [
              defaultPack
              py.ipython
              pyEnv
              pkgs.nil
              rust
              py.setuptools-rust
            ];
          };
        }
      
    );
}
