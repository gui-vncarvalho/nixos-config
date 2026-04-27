{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting  # desativa mensagem de boas-vindas

      # Integração nix-direnv: carrega .envrc automaticamente por projeto
      if type -q direnv
        direnv hook fish | source
      end
    '';

    shellAbbrs = {
      # NixOS
      nrs   = "sudo nixos-rebuild switch --flake ~/.config/nixos#nixos";
      nrt   = "sudo nixos-rebuild test --flake ~/.config/nixos#nixos";
      nfu   = "nix flake update ~/.config/nixos";
      nclean = "sudo nix-collect-garbage -d";

      # Git
      g     = "git";
      gs    = "git status";
      ga    = "git add";
      gc    = "git commit";
      gp    = "git push";
      gl    = "git log --oneline -10";
      gd    = "git diff";
      gco   = "git checkout";
      gbr   = "git branch";

      # Navegação
      ll    = "ls -la";
      ".."  = "cd ..";
      "..." = "cd ../..";

      # Dev
      dc    = "docker compose";
      k     = "kubectl";
    };

    plugins = [
      # Tema puro (prompt minimalista quando Starship não está carregado)
      {
        name = "pure";
        src  = pkgs.fishPlugins.pure.src;
      }
    ];
  };

  # ── Starship — prompt ────────────────────────────────────────────────────
  programs.starship = {
    enable         = true;
    enableFishIntegration = true;

    settings = {
      format = ''
        $os$username$directory$git_branch$git_status$nodejs$php$docker_context
        $character'';

      add_newline = true;

      character = {
        success_symbol = "[❯](bold mauve)";
        error_symbol   = "[❯](bold red)";
      };

      os = {
        disabled = false;
        style    = "bold blue";
        symbols.NixOS = " ";
      };

      username = {
        show_always = false;
        style_user  = "bold mauve";
        style_root  = "bold red";
        format      = "[$user]($style) ";
      };

      directory = {
        style              = "bold blue";
        truncation_length  = 3;
        truncate_to_repo   = true;
        format             = "[$path]($style)[$read_only]($read_only_style) ";
      };

      git_branch = {
        symbol = " ";
        style  = "bold mauve";
        format = "on [$symbol$branch]($style) ";
      };

      git_status = {
        style   = "bold yellow";
        format  = "([$all_status$ahead_behind]($style) )";
        ahead   = "⇡$count";
        behind  = "⇣$count";
        modified = "!$count";
        untracked = "?$count";
        staged  = "+$count";
      };

      nodejs = {
        symbol = " ";
        format = "[$symbol$version]($style) ";
        style  = "bold green";
      };

      php = {
        symbol = " ";
        format = "[$symbol$version]($style) ";
        style  = "bold blue";
      };

      docker_context = {
        symbol = " ";
        format = "[$symbol$context]($style) ";
        style  = "bold sapphire";
      };

      # Paleta Catppuccin Mocha
      palette = "catppuccin_mocha";
      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo  = "#f2cdcd";
        pink      = "#f5c2e7";
        mauve     = "#cba6f7";
        red       = "#f38ba8";
        maroon    = "#eba0ac";
        peach     = "#fab387";
        yellow    = "#f9e2af";
        green     = "#a6e3a1";
        teal      = "#94e2d5";
        sky       = "#89dceb";
        sapphire  = "#74c7ec";
        blue      = "#89b4fa";
        lavender  = "#b4befe";
        text      = "#cdd6f4";
        subtext1  = "#bac2de";
        overlay0  = "#6c7086";
        surface1  = "#45475a";
        surface0  = "#313244";
        base      = "#1e1e2e";
        mantle    = "#181825";
        crust     = "#11111b";
      };
    };
  };

  # ── direnv — ambientes por projeto ──────────────────────────────────────
  # Crie um .envrc em qualquer projeto com `use flake` para isolar deps
  programs.direnv = {
    enable                 = true;
    nix-direnv.enable      = true;
  };

  # ── zoxide — cd inteligente (z <nome-parcial>) ───────────────────────────
  programs.zoxide = {
    enable               = true;
    enableFishIntegration = true;
  };
}
