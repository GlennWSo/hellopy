with import <nixpkgs> {};
with python39Packages;

buildPythonPackage rec {
  name = "nixhello";
  pname = "hi";
  src = ./hello;
  propagatedBuildInputs = [];
}