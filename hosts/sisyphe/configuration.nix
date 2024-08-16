{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./server-configuration.nix
    ../../features/server/default.nix
    ../../features/shared/ssh.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.kernelParams = [ "console=ttyS0" ];

  services.qemuGuest.enable = true;
  networking.hostName = "sisyphe"; # Define your hostname.

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  users.users.homelab = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "dialout"
      "docker"
    ];

    packages = with pkgs; [
      btop
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8sdToNavEQv7PTMJ97HIGM6UlChwGS3x9O8hFilzui harryh@ik.me"
    ];

    initialHashedPassword = "$y$j9T$H0D6NpMw1EU.oDhbMWrwL.$wDGGBKKGQdzeDRTzq0gWhoLdyUpQ2w6PMmGl.nuQ11/";
  };

  users.users.root.initialHashedPassword = "$y$j9T$99/NEnBGoewbrl5eHvTw7/$87rjPrvqs0Ys72338SxZJDibi8p7Fe8Can37rJyhcQ.";

  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
  ];

  environment.variables.EDITOR = "nvim";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    8080
  ];

  # reducing disk usage
  boot.loader.systemd-boot.configurationLimit = 10;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
