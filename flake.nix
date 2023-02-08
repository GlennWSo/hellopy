{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay}:

    flake-utils.lib.eachDefaultSystem (system:
      let
        # supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
        # forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
        # pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
        overlays = [(import rust-overlay)];
        pkgs = import nixpkgs {
          inherit overlays system;
        };
        py = pkgs.python39Packages;
        setupRust = py.setuptools-rust;
        rust = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        # rustPlatfrom = pkgs.rustPlatform;

        rustPkg = pkgs.rustPlatform.buildRustPackage{
            name = "hellorust";
            src = ./.;
            cargoLock = {
              lockFile = ./Cargo.lock;
            };
            
            nativeBuildInputs = [
              pkgs.python39
            ];
            doCheck = false;
        };
        cargoDeps = pkgs.rustPlatform.importCargoLock {
          lockFile = ./Cargo.lock;
        }; 
        
        pypackage = py.buildPythonPackage{ 
            pname = "hello";
            name = "hello";
            src = ./.;  
            propagatedBuildInputs = [  py.numpy ]; # these will be availble both during build and runtime
            cargoDeps = cargoDeps;

            nativeBuildInputs = [ setupRust ] ++  [
              pkgs.rustPlatform.cargoSetupHook
              pkgs.rustPlatform.rust.cargo
              pkgs.rustPlatform.rust.rustc
            ];

            
          };
      in
        {
          packages.default = pypackage;
          packages.rhello = rustPkg;
          

          devShell = pkgs.mkShell {
            name = "hello-dev";
            buildInputs = [ # the default package ++ dev tool
              pkgs.nil
              py.ipython
              py.setuptools
              py.setuptools-rust
              pypackage  
              rust
              rustPkg
            ] ;
          };
        }
      
    );
}
