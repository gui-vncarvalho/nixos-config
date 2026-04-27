{ inputs, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./fish.nix
    ./apps.nix
  ];

  # Versão do Home Manager — mantenha em sync com o nixpkgs
  home.stateVersion = "24.11";

  home.username    = "vila";
  home.homeDirectory = "/home/vila";

  # Permite Home Manager gerenciar ele mesmo
  programs.home-manager.enable = true;

  # GTK — tema escuro global
  gtk = {
    enable = true;
    theme = {
      name    = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name    = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name    = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size    = 24;
    };
  };

  # Variáveis de ambiente do usuário
  home.sessionVariables = {
    EDITOR  = "nvim";
    BROWSER = "firefox";
    TERM    = "kitty";
  };
}
