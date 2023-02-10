#!/usr/bin/env bash
echo bulding ...
nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {
    buildPythonPackage=python39Packages.buildPythonPackage;
    setuptools-rust=python39Packages.setuptools-rust;
    }'