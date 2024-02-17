{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, flit-core
, setuptools
, matplotlib
, numpy
, pandas
, pythonOlder
, scipy
, seaborn
, statsmodels
}:

buildPythonPackage rec {
  pname = "pydove";
  version = "0.3.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ll/8OToP+wU8JdwoUOAo9+8sKYxebGwh4YBUeS7wj54=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
    seaborn
    setuptools
    statsmodels
  ];

  nativeCheckInputs = [
    #pytest-xdist
    #pytestCheckHook
  ];

  disabledTests = [
    # requires internet connection
    "test_load_dataset_string_error"
  ] ++ lib.optionals (!stdenv.hostPlatform.isx86) [
    # overly strict float tolerances
    "TestDendrogram"
  ];

  # All platforms should use Agg. Let's set it explicitly to avoid probing GUI
  # backends (leads to crashes on macOS).
  env.MPLBACKEND="Agg";

  pythonImportsCheck = [
    "pydove"
  ];

  meta = with lib; {
    description = "Statistical data visualization";
    homepage = "https://github.com/ttesileanu/pydove";
    changelog = "https://github.com/ttesileanu/pydovel/blob/master/doc/whatsnew/${src.rev}.rst";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fridh ];
  };
}

