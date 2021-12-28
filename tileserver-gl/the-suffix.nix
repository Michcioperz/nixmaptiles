{ args, sources, nodejs, nodeEnv, stdenvNoCC, nix-gitignore, lib, fetchFromGitHub, rsync }:
let
  original-src = fetchFromGitHub {
    owner = "maptiler";
    repo = "tileserver-gl";
    rev = "v3.1.1";
    sha256 = "1yjxcxwshxj7mkjqgf2ajq52anzm8v9x3i7m2ybn1xd40k59bj4l";
  };
  light-src = stdenvNoCC.mkDerivation {
    name = "tileserver-gl-light-source";
    src = original-src;
    buildInputs = [ rsync ];
    buildPhase = ''
      ${nodejs}/bin/node publish.js --no-publish
    '';
    installPhase = ''
      mkdir $out
      cp -r light/* $out
    '';
  };
  aargs = args // {
    src = light-src;
  };
in let args = aargs; in
{
  args = aargs;
  sources = sources;
  tarball = nodeEnv.buildNodeSourceDist args;
  package = nodeEnv.buildNodePackage args;
  shell = nodeEnv.buildNodeShell args;
  nodeDependencies = nodeEnv.buildNodeDependencies (lib.overrideExisting args {
    src = stdenvNoCC.mkDerivation {
      name = args.name + "-package-json";
      src = nix-gitignore.gitignoreSourcePure [
        "*"
        "!package.json"
        "!package-lock.json"
      ] args.src;
      dontBuild = true;
      installPhase = "mkdir -p $out; cp -r ./* $out;";
    };
  });
}
