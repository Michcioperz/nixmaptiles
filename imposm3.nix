{ buildGoModule, fetchFromGitHub, geos, leveldb }:
buildGoModule rec {
  pname = "imposm3";
  version = "0.11.1";
  src = fetchFromGitHub {
    owner = "omniscale";
    repo = "imposm3";
    rev = "v${version}";
    sha256 = "1ifniw57l3s0sl7nb3zwxxm86i46451yrhfqnnkxr46cnpbzmwxr";
  };
  vendorSha256 = null;
  subPackages = [ "cmd/imposm" ];
  buildInputs = [ geos leveldb ];
}
