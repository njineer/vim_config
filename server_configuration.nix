# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    cmake
    gcc
    gnumake
    htop
    tmux
    git
    vim
    wget
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  users.extraUsers.nathan = {
    name = "nathan";
    group = "users";
    createHome = true;
    home = "/home/nathan";
    uid = 1000;
    extraGroups = ["wheel"];
    useDefaultShell = true;
  };

  networking.firewall.enable = false;

  swapDevices = [{
    device = "/var/swapfile";
    size = 4096;
  }];

  services.nginx = {
    enable = true;
    httpConfig = ''
      server {
        listen *:80;
        server_name _;
        listen [::]:80;
        location /.well-known/acme-challenge {
          root /var/www/challenges;
        }
        #location / {
        #  return 301 https://$host$request_uri;
        #}
        location / {
          #root "/var/www";
          root /var/www/kraken-by-example/stage/_book;
        }
      }
      server {
        server_name kraken-lang.org;
        listen 443 ssl;
        ssl_certificate ${config.security.acme.directory}/kraken-lang.org/fullchain.pem;
        ssl_certificate_key ${config.security.acme.directory}/kraken-lang.org/key.pem;
        root /var/www/kraken-by-example/stage/_book;
      }
      server {
        server_name play.kraken-lang.org;
        listen 443 ssl;
        ssl_certificate ${config.security.acme.directory}/play.kraken-lang.org/fullchain.pem;
        ssl_certificate_key ${config.security.acme.directory}/play.kraken-lang.org/key.pem;
        root /var/www/kraken-by-example/stage/_book;
      }
    '';
  };

  security.acme.certs."kraken-lang.org" = {
    webroot = "/var/www/challenges";
    email = "miloignis@gmail.com";
    postRun = "systemctl restart nginx.service";
  };
  security.acme.certs."play.kraken-lang.org" = {
    webroot = "/var/www/challenges";
    email = "miloignis@gmail.com";
    postRun = "systemctl restart nginx.service";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

}
