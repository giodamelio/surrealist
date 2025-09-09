{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  languages.rust.enable = true;
  languages.nix.enable = true;
  languages.javascript = {
    enable = true;
    bun = {
      enable = true;
      install.enable = true;
    };
  };

  packages = with pkgs; [
    # Formatter
    alejandra

    # Native deps
    pkg-config
    glib
    pango
    libsoup_3
	webkitgtk_4_1
  ];
}
