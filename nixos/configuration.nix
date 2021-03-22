# Welcome to the official Liam NixOS config with XMonad
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # replace this with your hdd mount point
  boot.loader.grub.device = "/dev/nvme0n1"; # or "nodev" for efi only
  
  # Networking 
  networking.hostName = "tpad"; # Define your hostname.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp58s0.useDHCP = true;


############### REPLACE FROM HERE UP WITH INFORMATION SPECIFIC TO EACH BUILD ###################


  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
 
  # power
  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.tlp.enable = true;
  services.thermald.enable = true; 
  services.undervolt = {
	enable = true;
 	coreOffset = -50; 
	};

 # Splash screen
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";


 # Trackpad settings
  services.xserver.libinput= {
    enable = true;
    touchpad.naturalScrolling = true;
    touchpad.tapping = true;
    touchpad.tappingDragLock = false;
    touchpad.middleEmulation = true;
    touchpad.accelSpeed = "0.5";
  };


  # Graphics
  services.xserver.videoDrivers = [ "modsetting" ];
  services.xserver.useGlamor = true;
  services.xserver.deviceSection = ''Option 
    "TearFree"
    "DRI"
    "2"
    "true"'';
  programs.light.enable = true;
 
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  sound.mediaKeys.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.liam = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # Enable doas instead of sudo
    security.sudo.enable = false;
    security.doas.enable = true;
    security.doas.extraRules = [{
	users = [ "liam" ];
	keepEnv = true;
        persist = true;
     }];

  # Compositor and session manager 
    services.picom = {
       enable = true;
       fade = true; 
       #inactiveOpacity = 1;
       shadow = true;
       fadeDelta = 1; 
       vSync = true;
      };
    services.xserver.enable = true;
    services.xserver.displayManager.gdm = {
	enable = true;
	wayland = false;
	};



  # Enable XMonad
    services.xserver.windowManager.xmonad = {
	enable = true;
	extraPackages = hpkgs: [
   	  hpkgs.xmonad
	  hpkgs.xmonad-contrib
	  hpkgs.xmonad-extras
	  ];
      };

  # Set Fish as shell
   programs.zsh.enable = true;
   users.users.liam = {
   shell = pkgs.zsh;
   };

  # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
    wget
    vim
   # Window Management
    rofi
    autorandr
    xmobar
    nitrogen
   # System Applications
    pkgs.kitty
    pkgs.python39
    xorg.xmodmap
    gotop
    pkgs.arandr
    pciutils
    brightnessctl
   # File management
    pkgs.gitAndTools.gitFull
    pkgs.lf
    pkgs.zathura
    unzip
    feh
   # Misc
    scrot
    pfetch
   ];
 
 # Fonts
  fonts.fonts = with pkgs; [
	(nerdfonts.override {fonts = [ "Terminus" ]; })
	cozette
	inconsolata
      ];
 # Use most up to date Linux Kernals 
    boot.kernelPackages = pkgs.linuxPackages_latest;

 # NixOS Configuration 
  system.stateVersion = "20.09"; # Did you read the comment?
  #system.autoUpgrade = {
  #     enable = true;
  #     channel = https://nixos.org/channels/nixos-unstable;
  #     };

}

