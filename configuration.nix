# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      extraEntries = ''
        menuentry "Reboot" {
          reboot
	      }
	      menuentry "Poweroff" {
	        halt
	      }
      '';
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking = {
    hostName = "nixvm";
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.utf8";

  services = {
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.gnome.enable = true;
      layout = "us";
      xkbVariant = "";
    };
    printing = {
      enable = true;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
	      support32Bit = true;
      };
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  virtualisation.docker.enable = true;

  users.users = {
    mazy = {
      isNormalUser = true;
      description = "Landon Porter";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import "${fetchTarball "https://github.com/nix-community/fenix/archive/main.tar.gz"}/overlay.nix")
    ];
  };

  environment.systemPackages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly
    neovim
    yarn
    nodejs
    neofetch
    pfetch
    vim
    wget
    curlFull
    firefox
    alacritty
    git
    gh
    github-desktop
    gnumake
    libgnurl
    gcc
    clang
    discord-canary
    vscode
    btop
    chromium
  ];
  
  system = {
    stateVersion = "22.05";
    autoUpgrade = {
      enable = true;
      allowReboot = false;
    };
  };
}
