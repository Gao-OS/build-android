{ pkgs, lib, config, inputs, ... }:

let
  pkgs-stable = import inputs.nixpkgs-stable { system = pkgs.stdenv.system; };
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; };
in {
  dotenv.enable = true;

  env.GREET = "GaoOS Android";

  env.USE_CCACHE = "1"; 

  packages = with pkgs-stable; [
    figlet	
    lolcat

    git
    gitRepo
    gnupg
    curl
    procps
    openssl
    gnumake
    nettools
    jdk
    schedtool
    util-linux
    m4
    gperf
    perl
    libxml2
    zip
    unzip
    bison
    flex
    lzop
    python3
    ccache
    zlib
    ncurses5
  ];

  android.enable = true;

  scripts.hello.exec = ''
    figlet -w 120 $GREET | lolcat
  '';

  enterShell = ''
    hello
  '';

}
