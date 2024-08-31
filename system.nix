{
  description = "Base system configuration for Framework 13";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration.nix
          home-manager.nixosModules.home-manager
          ({ config, pkgs, ... }: {
            # Your existing configuration here...

            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            networking.hostName = "nixos";
            networking.networkmanager.enable = true;

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
              zed-editor
              vlc
            ];
          };

          # Firefox
          programs.firefox.enable = false;

          # Allow unfree packages
          nixpkgs.config.allowUnfree = true;

          # System packages
          environment.systemPackages = with pkgs; [
            git
            python310
            python310Packages.pip
            python310Packages.pipx
          ];

          # Add home-manager configuration
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.nymph = { pkgs, ... }: {
            home.stateVersion = "24.05";

            programs.bash = {
              enable = true;
              shellAliases = {
                c = "sudo nano /etc/nixos/configuration.nix";
                s = "sudo nixos-rebuild switch";
                f = "sudo nano ~/nix-flakes/system.nix";
                cf = "sudo cp system.nix /etc/nixos/flake.nix";
                cfs = "cf && s";
                nd = "nix develop";
                
                v="python3 -m venv venv && . venv/bin/activate"
                vr="v && pip install -r requirements.txt"
                va=". venv/bin/activate"
                tl="tmux list-sessions"
                ta="tmux attach -t "
                tk="tmux kill-session -t "

                o = "ssh office";
                r = "ssh reth";
              };
            };

            programs.git = {
              enable = true;
              userEmail = "quantnymph@gmail.com";
              userName = "RhizoNymph";
            };

            programs.ssh = {
              enable = true;
              matchBlocks = {
                "office" = {
                  hostname = "";
                  user = "";
                  port = 22;
                  identityFile = "~/.ssh/id_rsa";
                };
                "reth" = {
                  hostname = "";
                  user = "";
                  port = 22;
                  identityFile = "~/.ssh/id_rsa";
                };
              };
            };

          };

          # System version
          system.stateVersion = "24.05";
        })
      ];
    };
  };
}
