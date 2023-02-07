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
      in
        {
          defaultPackage = py.buildPythonPackage{ 
            pname = "hello";
            src = ./.;  
            version = "0.0.1";
            propagatedBuildInputs = [ py.flask ];
          };

          devShell = pkgs.mkShell {
            buildInputs = [ py.ipython ] ;
          };
        }
      
    );
}
