{ config, pkgs, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ── Boot ──────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Kernel recente para melhor suporte a hardware moderno
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ── Rede ──────────────────────────────────────────────────────────────────
  networking.hostName                  = "nixos";
  networking.networkmanager.enable     = true;

  # ── Localização ───────────────────────────────────────────────────────────
  time.timeZone                        = "America/Sao_Paulo";
  i18n.defaultLocale                   = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "pt_BR.UTF-8";
    LC_MONETARY       = "pt_BR.UTF-8";
    LC_PAPER          = "pt_BR.UTF-8";
    LC_TELEPHONE      = "pt_BR.UTF-8";
    LC_TIME           = "pt_BR.UTF-8";
  };

  # ── Áudio (PipeWire) ──────────────────────────────────────────────────────
  security.rtkit.enable                = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };

  # ── Bluetooth ─────────────────────────────────────────────────────────────
  hardware.bluetooth.enable            = true;
  hardware.bluetooth.powerOnBoot       = true;
  services.blueman.enable              = true;

  # ── GPU ───────────────────────────────────────────────────────────────────
  # Descomente o bloco do seu hardware:

  # Intel:
  # hardware.opengl.extraPackages = with pkgs; [ intel-media-driver ];

  # AMD:
  # hardware.opengl.enable = true;

  # NVIDIA (troque pela versão correta do driver):
  # hardware.nvidia.modesetting.enable = true;
  # services.xserver.videoDrivers = [ "nvidia" ];

  # ── Wayland / Hyprland ────────────────────────────────────────────────────
  programs.hyprland = {
    enable         = true;
    package        = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
  };

  # Variáveis de ambiente para Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL  = "1";   # Electron apps usam Wayland
    WLR_NO_HARDWARE_CURSORS = "1";  # remove se o cursor aparecer
  };

  # ── XDG portals (compartilhamento de tela, file picker) ───────────────────
  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # ── Fontes ────────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    inter
    noto-fonts
    noto-fonts-emoji
  ];

  # ── Usuário ───────────────────────────────────────────────────────────────
  users.users.vila = {
    isNormalUser = true;
    description  = "Vila";
    extraGroups  = [ "networkmanager" "wheel" "video" "audio" "bluetooth" ];
    shell        = pkgs.fish;
  };

  # ── Pacotes de sistema ────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    unzip
    ripgrep
    fd
  ];

  # ── Fish (precisa estar habilitado no sistema também) ─────────────────────
  programs.fish.enable = true;

  # ── Polkit (necessário para apps que pedem elevação) ──────────────────────
  security.polkit.enable = true;

  # ── Flakes ────────────────────────────────────────────────────────────────
  nix.settings = {
    experimental-features  = [ "nix-command" "flakes" ];
    auto-optimise-store    = true;
  };

  # Limpeza automática de gerações antigas
  nix.gc = {
    automatic  = true;
    dates      = "weekly";
    options    = "--delete-older-than 7d";
  };

  system.stateVersion = "24.11";
}
