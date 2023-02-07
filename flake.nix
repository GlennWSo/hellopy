{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        # supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
        # forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
        # pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
        pkgs = import nixpkgs {
          inherit system;
        };
        py = pkgs.python39Packages;
        mypackage = py.buildPythonPackage{ 
            pname = "hello";
            name = "hello";
            src = ./py/.;  
            # version = "0.0.1";
            propagatedBuildInputs = [  py.numpy ];
          };
      in
        {
          defaultPackage = mypackage;
          devShell = pkgs.mkShell {
            name = "hello-dev";
            buildInputs = [ 
              pkgs.nil
              py.ipython
              mypackage  
            ] ;
          };
        }
      
    );
}
