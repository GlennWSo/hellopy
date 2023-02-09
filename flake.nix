{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.mach-nix.url = "mach-nix/3.5.0";
  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils,mach-nix, rust-overlay}:

    flake-utils.lib.eachDefaultSystem (system:
      let
        # supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
        # forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
        # pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
        overlays = [ (import rust-overlay)];
        pkgs = import nixpkgs {
          inherit overlays system;
        };
        py = pkgs.python39Packages;
        mach = mach-nix.lib.${system};
        setupRust = py.setuptools-rust;
        rust = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        # rustPlatfrom = pkgs.rustPlatform;
        
        cargoDeps = pkgs.rustPlatform.importCargoLock {
          lockFile = ./Cargo.lock;
        }; 

        pyEnv = mach.mkPython {
          requirements = ''
            ipython
            pyvista
          '';
          packagesExtra = [
            # pypackage
          ];
          };

        
        pypackage =py.buildPythonPackage{ 
            pname = "hello";
            name = "hello";
            version = "0.0.1";
            src = ./.;  
            # requirements = ''
            #   numpy
            #   setuptools_rust
            #   pyvista
            # '';
            propagatedBuildInputs = [  ]; # these will be availble both during build and runtime
            cargoDeps = cargoDeps;

            nativeBuildInputs =  [
              setupRust
              pkgs.rustPlatform.cargoSetupHook
              pkgs.rustPlatform.rust.cargo
              pkgs.rustPlatform.rust.rustc
            ];
          };
       
      in
        {
          packages.default = pypackage;

          devShell = pkgs.mkShell{
            name = "pyrust";
            buildInputs = [
              pypackage
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
