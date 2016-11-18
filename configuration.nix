# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
  	  initrd.luks.devices = [{
	  	name = "cryptVG";
		device = "/dev/sda6";
		preLVM = true;
	  }];
	  loader = {
		  efi.canTouchEfiVariables = true;
		  systemd-boot.enable = true;
	  };
  };


  networking.hostName = "nixos-nathan"; # Define your hostname.
  #networking.wireless.enable = true;    # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  services.xserver.displayManager.sessionCommands = "${pkgs.networkmanagerapplet}/bin/nm-applet &";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    python3
    clisp
    cryptsetup
    wget
    vim
    git
    gdb
    valgrind
    cowsay
    tmux
    neovim
    silver-searcher
    gcc
    gnumake
    cmake
    firefox
    chromium
    google-chrome
    i3status
    dmenu
    pavucontrol
    sakura
    gparted
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;
  services.xserver.synaptics.horizontalScroll = true;
  services.xserver.synaptics.buttonsMap = [1 3 2];
  #services.xserver.displayManager.kdm.enable = true;
  #services.xserver.desktopManager.kde4.enable = true;
  services.xserver.windowManager.i3.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

  users.extraUsers.nathan = {
	  name = "nathan";
	  group = "users";
	  extraGroups = [ "wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" "networkmanager" ];
	  createHome = true;
	  home = "/home/nathan";
	  shell = "/run/current-system/sw/bin/bash";
  };

  hardware = {
	  pulseaudio.enable = true;
	  pulseaudio.support32Bit = true;
  };
  
  nixpkgs.config = {
    allowUnfree = true;
    chromium.enableWideVine = true;
  };

}
