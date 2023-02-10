{ 
buildPythonPackage,
lib,
rustPlatform,
setuptools-rust,
}:

buildPythonPackage rec {
  pname = "rhello";
  version = "2.28.1";
  # disabled = pythonOlder "3.7";
  # src = fetchPypi {
  #   inherit pname version;
  #   hash = "sha256-fFWZsQL+3apmHIJsVqtP7ii/0X9avKHrvj5/GdfJeYM=";
  # };
	src = ./.;

	# extra run time deps
  propagatedBuildInputs = [
  ];

	cargoDeps = rustPlatform.importCargoLock {
	  lockFile = ./Cargo.lock;
	}; 

  nativeBuildInputs =  [
    setuptools-rust
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
  ];

  pythonImportsCheck = [
    "hello"
  ];

  # meta = with lib; {
  #   description = "HTTP library for Python";
  #   homepage = "http://docs.python-requests.org/";
  #   license = licenses.asl20;
  #   maintainers = with maintainers; [ fab ];
  # };
}
