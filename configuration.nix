# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

let
  sddm-astronaut = (pkgs.sddm-astronaut.override {
    embeddedTheme = "black_hole";
  });
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.limine.enable = true;
  boot.loader.limine.secureBoot.enable = true;
  boot.loader.limine.extraEntries = '' # Add Windows entry
    /Windows 11
    comment: Windows 11
    protocol: efi
    path: uuid(05aaa7d3-498d-4cfc-be77-77f1362962f1):/EFI/Microsoft/Boot/bootmgfw.efi
  '';
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."dun9" = {
    isNormalUser = true;
    description = "dun9";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Change users shell
  users.users.dun9.shell = pkgs.zsh;

  # Turn off zsh new user message
  system.userActivationScripts.zshrc = "touch .zshrc";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable polkit
  security.polkit.enable = true;

  # Env variables
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # Input method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      kdePackages.fcitx5-unikey
    ];
  };
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
     git
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     pciutils
     python3
     gcc
     uv
     sbctl
     xdg-desktop-portal-gtk
     xdg-desktop-portal-gnome
     xwayland-satellite
     kitty
     starship
     noctalia
     flatpak
     libsForQt5.qtstyleplugin-kvantum
     libsForQt5.qt5ct
     kdePackages.qt6ct
     qt5.qtwayland
     qt6.qtwayland
     kdePackages.qtmultimedia
     kdePackages.polkit-kde-agent-1
     sddm-astronaut
     tela-icon-theme
     phinger-cursors
     btop
     fastfetch
     firefox
     vscodium
     discord-ptb
     onlyoffice-desktopeditors
     pcmanfm-qt
     file-roller
     gamemode
     iw
     proton-vpn
   ];

  # Installing fonts
  fonts.packages = with pkgs; [
    roboto
    fira-code
    nerd-fonts.fira-code
  ];

  # Enable Qt
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.niri.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
  };
  programs.starship.enable = true;
  programs.steam.enable = true;
  programs.nix-ld.enable = true; # for python development

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.gvfs.enable = true;
  
  # For noctalia functions
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  
  # Nvidia drivers
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];
  hardware.graphics.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.branch = "new_feature";
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;    

    amdgpuBusId = "PCI:6@0:0:0";
    nvidiaBusId = "PCI:1@0:0:0";
  };

  # Display manager  
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
  };

  # Nix settings
  nix.settings.experimental-features = [
    "nix-command"
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
