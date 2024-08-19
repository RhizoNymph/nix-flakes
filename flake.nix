{
  description = "Base system configuration for Framework 13";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.mysystem = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; 
      modules = [
        ({ config, pkgs, ... }: {
          imports = [
            ./hardware-configuration.nix
          ];

          # Bootloader
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          # Networking
          networking.hostName = "nixos";
          networking.networkmanager.enable = true;

          # Nix settings
          nix.settings.experimental-features = [ "nix-command" "flakes" ];

          # Time zone and localization
          time.timeZone = "America/Los_Angeles";
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

          # X11 and KDE Plasma
          services.xserver.enable = true;
          services.displayManager.sddm.enable = true;
          services.desktopManager.plasma6.enable = true;
          services.xserver = {
            layout = "us";
            xkbVariant = "";
          };

          # Printing
          services.printing.enable = true;

          # Sound
          hardware.pulseaudio.enable = false;
          security.rtkit.enable = true;
          services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
          };

          # User account
          users.users.nymph = {
            isNormalUser = true;
            description = "nymph";
            extraGroups = [ "networkmanager" "wheel" ];
            packages = with pkgs; [
              kdePackages.kate
              brave
              ffmpeg
              obsidian
              slack
              pgadmin4
              discord
              vscode
              vlc
            ];
          };

          # Firefox
          programs.firefox.enable = false;

          # Allow unfree packages
          nixpkgs.config.allowUnfree = true;

          # System packages
          environment.systemPackages = with pkgs; [
            # Add any system-wide packages here
          ];

          # Shell aliases
          environment.interactiveShellInit = ''
            alias conf='sudo nano /etc/nixos/configuration.nix'
            alias switch='sudo nixos-rebuild switch'
            alias flake='nano ~/flake.nix'
          '';

          # System version
          system.stateVersion = "24.05";
        })
      ];
    };
  };
}
