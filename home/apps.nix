{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # ── Terminal utils ──────────────────────────────────────────────────────
    ripgrep          # grep moderno (rg)
    fd               # find moderno
    bat              # cat com syntax highlighting
    eza              # ls moderno
    btop             # monitor de sistema
    fastfetch        # neofetch rápido
    unzip
    p7zip
    jq               # processar JSON no terminal

    # ── Wayland essentials ──────────────────────────────────────────────────
    swww             # wallpaper com transições
    mako             # notificações
    wofi             # launcher
    grimblast        # screenshots (wraper do grim)
    wl-clipboard     # wl-copy / wl-paste
    cliphist         # histórico de clipboard
    brightnessctl    # controle de brilho
    playerctl        # controle de mídia
    pavucontrol      # controle de áudio (GUI)

    # ── Apps ────────────────────────────────────────────────────────────────
    firefox
    thunar           # file manager
    gnome-calculator
    evince           # PDF viewer

    # ── Dev ─────────────────────────────────────────────────────────────────
    git
    gh               # GitHub CLI
    neovim
    docker-compose
    nodejs_22
    # php83            # descomente se usar PHP globalmente
    # composer         # descomente se usar PHP globalmente

    # ── Fontes extras ───────────────────────────────────────────────────────
    nerd-fonts.jetbrains-mono
  ];

  # ── Kitty — terminal ────────────────────────────────────────────────────
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };
    settings = {
      # Catppuccin Mocha
      foreground            = "#cdd6f4";
      background            = "#1e1e2e";
      selection_foreground  = "#1e1e2e";
      selection_background  = "#f5e0dc";

      color0  = "#45475a"; color8  = "#585b70";
      color1  = "#f38ba8"; color9  = "#f38ba8";
      color2  = "#a6e3a1"; color10 = "#a6e3a1";
      color3  = "#f9e2af"; color11 = "#f9e2af";
      color4  = "#89b4fa"; color12 = "#89b4fa";
      color5  = "#f5c2e7"; color13 = "#f5c2e7";
      color6  = "#94e2d5"; color14 = "#94e2d5";
      color7  = "#bac2de"; color15 = "#a6adc8";

      cursor              = "#f5e0dc";
      cursor_text_color   = "#1e1e2e";
      url_color           = "#f5e0dc";

      background_opacity  = "0.92";
      confirm_os_window_close = 0;

      window_padding_width   = 12;
      scrollback_lines       = 10000;

      tab_bar_style          = "powerline";
      tab_powerline_style    = "slanted";
      active_tab_foreground  = "#1e1e2e";
      active_tab_background  = "#cba6f7";
      inactive_tab_foreground = "#cdd6f4";
      inactive_tab_background = "#313244";
    };

    keybindings = {
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+enter" = "new_window_with_cwd";
    };
  };

  # ── Wofi — launcher ─────────────────────────────────────────────────────
  programs.wofi = {
    enable = true;
    settings = {
      width             = 600;
      height            = 400;
      location          = "center";
      show              = "drun";
      prompt            = "Buscar...";
      filter_rate       = 100;
      allow_markup      = true;
      no_actions        = true;
      halign            = "fill";
      orientation       = "vertical";
      content_halign    = "fill";
      insensitive       = true;
      allow_images      = true;
      image_size        = 32;
      gtk_dark          = true;
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Inter";
        font-size: 14px;
      }

      window {
        background-color: #1e1e2e;
        border:           2px solid #313244;
        border-radius:    12px;
        color:            #cdd6f4;
      }

      #input {
        background-color: #313244;
        border:           none;
        border-radius:    8px;
        padding:          10px 16px;
        color:            #cdd6f4;
        margin:           8px;
      }

      #input:focus { border: 1px solid #cba6f7; }

      #entry {
        padding:       8px 12px;
        border-radius: 8px;
      }

      #entry:selected {
        background-color: #313244;
        color:            #cba6f7;
      }

      #text:selected { color: #cba6f7; }
    '';
  };

  # ── Mako — notificações ─────────────────────────────────────────────────
  services.mako = {
    enable            = true;
    font              = "JetBrainsMono Nerd Font 12";
    backgroundColor   = "#1e1e2e";
    textColor         = "#cdd6f4";
    borderColor       = "#cba6f7";
    borderRadius      = 10;
    borderSize        = 2;
    padding           = "12,16";
    margin            = "8";
    defaultTimeout    = 5000;
    ignoreTimeout     = false;
    width             = 350;

    extraConfig = ''
      [urgency=high]
      border-color=#f38ba8
      default-timeout=0
    '';
  };

  # ── Git ─────────────────────────────────────────────────────────────────
  programs.git = {
    enable      = true;
    userName    = "Guilherme Vila Nova";
    userEmail   = "guilhercraft@gmail.com";
    extraConfig = {
      init.defaultBranch = "develop";
      pull.rebase        = false;
      push.autoSetupRemote = true;
      core.editor        = "nvim";
    };
  };

  # ── btop ─────────────────────────────────────────────────────────────────
  programs.btop = {
    enable   = true;
    settings = {
      color_theme      = "catppuccin_mocha";
      theme_background = false;
      vim_keys         = true;
    };
  };
}
