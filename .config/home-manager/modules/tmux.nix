{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    prefix = "C-Space";

    plugins = [
      pkgs.tmuxPlugins.better-mouse-mode
      pkgs.tmuxPlugins.sensible
      pkgs.tmuxPlugins.tilish
      pkgs.tmuxPlugins.resurrect
      pkgs.tmuxPlugins.vim-tmux-navigator
      # pkgs.tmuxPlugins.dracula
      pkgs.tmuxPlugins.catppuccin
      # pkgs.tmuxPlugins.rose-pine
    ];

    extraConfig = ''
      # set -g default-terminal "tmux-256color"
      # set -ag terminal-overrides ",xterm-256color:RGB"
      # set-option -sa terminal-overrides ",xterm*:Tc"
      set -g mouse on
      set -g prefix C-Space
      set -g @tilish-navigator 'on'
      set -g @catppuccin_status_background "none"
      set -g @catppuccin_status_justify "centre"
      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_number_position "right"
      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"
      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W"
      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator ""
      set -g @catppuccin_status_right_separator_inverse "no"
      set -g @catppuccin_status_fill "all"
      set -g @catppuccin_status_connect_separator "no"
      # set -g @catppuccin_directory_text "#{pane_current_path}"
      # set -g @catppuccin_status_modules_right "directory session"
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
      bind -n M-H previous-window
      bind -n M-L next-window
    '';
  };
}

