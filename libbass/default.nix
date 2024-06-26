{ lib, stdenv, unzip, fetchurl }:

# Upstream changes files in-place, to update:
# 1. Check latest version at http://www.un4seen.com/
# 2. Update `version`s and `sha256` sums.
# See also http://www.un4seen.com/forum/?topic=18614.0

let
  allBass = {
    bass = {
      h = "bass.h";
      version = "2.4.15";
      so = {
        i686_linux = "libbass.so";
        x86_64-linux = "libs/x86_64/libbass.so";
      };
      urlpath = "bass24-linux.zip";
      # nix-prefetch-url https://www.un4seen.com/files/bass24-linux.zip
      sha256 = "0yjb1g8zvywl014i5l6fa9jkki2garyxxcimcsrkp7vdssz2b47w";
    };

    bass_fx = {
      h = "C/bass_fx.h";
      version = "2.4.12.1";
      so = {
        i686_linux = "libbass_fx.so";
        x86_64-linux = "libs/x86_64/libbass_fx.so";
      };
      urlpath = "z/0/bass_fx24-linux.zip";
      # nix-prefetch-url https://www.un4seen.com/files/z/0/bass_fx24-linux.zip
      sha256 = "0fs1pmi4fr7pvhgkjk40a7gmxjca0mx0sk1l9iy3as17ph87ds8y";
    };
  };

  dropBass = name: bass: stdenv.mkDerivation {
    pname = "lib${name}";
    inherit (bass) version;

    src = fetchurl {
      url = "https://www.un4seen.com/files/${bass.urlpath}";
      inherit (bass) sha256;
    };
    unpackCmd = ''
      mkdir out
      ${unzip}/bin/unzip $curSrc -d out
    '';

    lpropagatedBuildInputs = [ unzip ];
    dontBuild = true;
    installPhase =
      let so =
            if bass.so ? ${stdenv.hostPlatform.system} then bass.so.${stdenv.hostPlatform.system}
            else throw "${name} not packaged for ${stdenv.hostPlatform.system} (yet).";
      in ''
        mkdir -p $out/{lib,include}
        install -m644 -t $out/lib/ ${so}
        install -m644 -t $out/include/ ${bass.h}
      '';

    meta = with lib; {
      description = "Shareware audio library";
      homepage = "https://www.un4seen.com/";
      license = licenses.unfreeRedistributable;
      platforms = builtins.attrNames bass.so;
      # until upstream has stable URLs, this package is prone to always being broken
      broken = true;
    };
  };

in lib.mapAttrs dropBass allBass
