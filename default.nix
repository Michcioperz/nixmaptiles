{ pkgs ? import <nixpkgs> {} }:
rec {
  lubelskie = pkgs.fetchurl {
    url = "http://download.geofabrik.de/europe/poland/lubelskie-latest.osm.pbf";
    sha256 = "08h187vfzy6bbd44yp1zicv3hjl1n8h2jwjxzkm6a72idvwhzjfm";
  };
  imposm3 = pkgs.callPackage ./imposm3.nix {};
  postgres-shenanigans = pkgs.callPackage ./postgres-shenanigans.nix {};
  tileserver-gl-light = (import ./tileserver-gl { inherit pkgs; }).package;
  osmborder = pkgs.callPackage ./osmborder.nix {};
  tiles = name: osm-pbf: "todo";
}
