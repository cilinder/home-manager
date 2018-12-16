{ pkgs
, lib

  # Whether to enable module type checking.
, check ? true

  # Whether these modules are inside a NixOS submodule.
, nixosSubmodule ? false
}:

with lib;

let

  hostPlatform = pkgs.stdenv.hostPlatform;

  checkPlatform = any (meta.platformMatch pkgs.stdenv.hostPlatform);

  loadModule = { file, condition ? true }: {
    inherit file condition;
  };

  allModules = [
    (loadModule { file = ./accounts/email.nix; })
    (loadModule { file = ./files.nix; })
    (loadModule { file = ./home-environment.nix; })
    (loadModule { file = ./manual.nix; })
    (loadModule { file = ./misc/fontconfig.nix; })
    (loadModule { file = ./misc/gtk.nix; })
    (loadModule { file = ./misc/lib.nix; })
    (loadModule { file = ./misc/news.nix; })
    (loadModule { file = ./misc/nixpkgs.nix; })
    (loadModule { file = ./misc/pam.nix; })
    (loadModule { file = ./misc/qt.nix; })
    (loadModule { file = ./misc/version.nix; })
    (loadModule { file = ./misc/xdg.nix; })
    (loadModule { file = ./programs/afew.nix; })
    (loadModule { file = ./programs/alot.nix; })
    (loadModule { file = ./programs/astroid.nix; })
    (loadModule { file = ./programs/autorandr.nix; })
    (loadModule { file = ./programs/bash.nix; })
    (loadModule { file = ./programs/beets.nix; })
    (loadModule { file = ./programs/browserpass.nix; })
    (loadModule { file = ./programs/command-not-found/command-not-found.nix; })
    (loadModule { file = ./programs/direnv.nix; })
    (loadModule { file = ./programs/eclipse.nix; })
    (loadModule { file = ./programs/emacs.nix; })
    (loadModule { file = ./programs/feh.nix; })
    (loadModule { file = ./programs/firefox.nix; })
    (loadModule { file = ./programs/fish.nix; })
    (loadModule { file = ./programs/fzf.nix; })
    (loadModule { file = ./programs/git.nix; })
    (loadModule { file = ./programs/gnome-terminal.nix; })
    (loadModule { file = ./programs/go.nix; })
    (loadModule { file = ./programs/home-manager.nix; })
    (loadModule { file = ./programs/htop.nix; })
    (loadModule { file = ./programs/info.nix; })
    (loadModule { file = ./programs/jq.nix; })
    (loadModule { file = ./programs/lesspipe.nix; })
    (loadModule { file = ./programs/man.nix; })
    (loadModule { file = ./programs/mbsync.nix; })
    (loadModule { file = ./programs/mercurial.nix; })
    (loadModule { file = ./programs/msmtp.nix; })
    (loadModule { file = ./programs/neovim.nix; })
    (loadModule { file = ./programs/newsboat.nix; })
    (loadModule { file = ./programs/noti.nix; })
    (loadModule { file = ./programs/notmuch.nix; })
    (loadModule { file = ./programs/obs-studio.nix; })
    (loadModule { file = ./programs/offlineimap.nix; })
    (loadModule { file = ./programs/pidgin.nix; })
    (loadModule { file = ./programs/rofi.nix; })
    (loadModule { file = ./programs/ssh.nix; })
    (loadModule { file = ./programs/taskwarrior.nix; })
    (loadModule { file = ./programs/termite.nix; })
    (loadModule { file = ./programs/texlive.nix; })
    (loadModule { file = ./programs/tmux.nix; })
    (loadModule { file = ./programs/urxvt.nix; })
    (loadModule { file = ./programs/vim.nix; })
    (loadModule { file = ./programs/vscode.nix; })
    (loadModule { file = ./programs/zathura.nix; })
    (loadModule { file = ./programs/zsh.nix; })
    (loadModule { file = ./services/blueman-applet.nix; })
    (loadModule { file = ./services/compton.nix; })
    (loadModule { file = ./services/dunst.nix; })
    (loadModule { file = ./services/flameshot.nix; })
    (loadModule { file = ./services/gnome-keyring.nix; })
    (loadModule { file = ./services/gpg-agent.nix; })
    (loadModule { file = ./services/kbfs.nix; })
    (loadModule { file = ./services/kdeconnect.nix; })
    (loadModule { file = ./services/keepassx.nix; })
    (loadModule { file = ./services/keybase.nix; })
    (loadModule { file = ./services/mbsync.nix; })
    (loadModule { file = ./services/mpd.nix; })
    (loadModule { file = ./services/network-manager-applet.nix; })
    (loadModule { file = ./services/nextcloud-client.nix; })
    (loadModule { file = ./services/owncloud-client.nix; })
    (loadModule { file = ./services/parcellite.nix; })
    (loadModule { file = ./services/pasystray.nix; })
    (loadModule { file = ./services/polybar.nix; })
    (loadModule { file = ./services/random-background.nix; })
    (loadModule { file = ./services/redshift.nix; })
    (loadModule { file = ./services/screen-locker.nix; })
    (loadModule { file = ./services/stalonetray.nix; })
    (loadModule { file = ./services/status-notifier-watcher.nix; })
    (loadModule { file = ./services/syncthing.nix; })
    (loadModule { file = ./services/taffybar.nix; })
    (loadModule { file = ./services/tahoe-lafs.nix; })
    (loadModule { file = ./services/udiskie.nix; })
    (loadModule { file = ./services/unclutter.nix; })
    (loadModule { file = ./services/window-managers/awesome.nix; })
    (loadModule { file = ./services/window-managers/i3.nix; })
    (loadModule { file = ./services/window-managers/xmonad.nix; })
    (loadModule { file = ./services/xscreensaver.nix; })
    (loadModule { file = ./systemd.nix; })
    (loadModule { file = ./xcursor.nix; })
    (loadModule { file = ./xresources.nix; })
    (loadModule { file = ./xsession.nix; })
    (loadModule { file = <nixpkgs/nixos/modules/misc/assertions.nix>; })
    (loadModule { file = <nixpkgs/nixos/modules/misc/meta.nix>; })
  ]
  ++
  optional pkgs.stdenv.isLinux (loadModule { file = ./programs/chromium.nix; });

  modules = map (getAttr "file") (filter (getAttr "condition") allModules);

  pkgsModule = {
    options.nixosSubmodule = mkOption {
      type = types.bool;
      internal = true;
      readOnly = true;
    };

    config._module.args.baseModules = modules;
    config._module.args.pkgs = lib.mkDefault pkgs;
    config._module.check = check;
    config.lib = import ./lib { inherit lib; };
    config.nixosSubmodule = nixosSubmodule;
    config.nixpkgs.system = mkDefault pkgs.system;
  };

in

  modules ++ [ pkgsModule ]
