{ fetchFromGitHub, stdenv, cmake, zlib, libosmium, expat, bzip2, protozero }:
stdenv.mkDerivation {
  pname = "osmborder";
  version = "last-known";
  src = fetchFromGitHub {
    owner = "pnorman";
    repo = "osmborder";
    rev = "e3ae8f7a2dcdcd6dc80abab4679cb5edb7dc6fa5";
    sha256 = "03mkfm7wlqjr8h4bkiv47iqilmsb1fj7nsa7899gmwan51f5cxak";
  };
  buildInputs = [ cmake zlib libosmium bzip2 expat protozero ];
}
