{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    "${
      fetchTarball {
        url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
        sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";
      }
    }/nextcloud-extras.nix"
    ./nextcloud-network.nix
  ]; # adding caddy support

  sops.secrets.adminNextcloudPass = {
    owner = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    hostName = "cloud.hypervirtual.world";
    database.createLocally = true;
    webserver = "caddy";
    configureRedis = true;
    package = pkgs.nextcloud30;
    config = {
      dbtype = "pgsql";
      adminpassFile = config.sops.secrets.adminNextcloudPass.path;
    };

    settings = {
      enabledPreviewProviders = [
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\HEIC"
      ];

      trustedDomains = [ "cloud.hypervirtual.world" ];
      overwriteprotocol = "https";
      log_type = "file"; # temporary fix for https://nixos.org/manual/nixos/stable/#module-services-nextcloud-warning-logreader
      default_phone_region = "FR";
      default_locale = "fr_FR";
      default_language = "fr";
      default_timezone = "Europe/Paris";
      "memories.exiftool" = "${lib.getExe pkgs.exiftool}";
    };

    phpExtraExtensions = all: [
      all.pdlib
      all.redis
      all.bz2
    ];

    phpOptions."opcache.interned_strings_buffer" = "23";
    extraApps = {
      inherit (pkgs.nextcloud30Packages.apps)
        contacts
        calendar
        previewgenerator
        ;

      memories = pkgs.fetchNextcloudApp {
        sha256 = "sha256-tzxeffvwMwthvBRG+/cLCXZkVS32rlf5v7XOKTbGoOo=";
        url = "https://github.com/pulsejet/memories/releases/download/v7.3.1/memories.tar.gz";
        license = "agpl3Only";
      };
      /*
        not useful for me
           registration = pkgs.fetchNextcloudApp {
             sha256 = "sha256-dDaQHyHdkkd8ZammLdck2HNGqqfEaunwevdPzbWzB8Y=";
             url = "https://github.com/nextcloud-releases/registration/releases/download/v2.4.0/registration-v2.4.0.tar.gz";
             license = "agpl3Only";
           };
      */
      facerecognition = pkgs.fetchNextcloudApp {
        sha256 = "sha256-FtYItN0Iy2QpSNf0GPs7fIPYgBdEuKHJGwZ7GQNySZE=";
        url = "https://github.com/matiasdelellis/facerecognition/releases/download/v0.9.60/facerecognition.tar.gz";
        license = "agpl3Only";
      };

    };
    extraAppsEnable = true;
    appstoreEnable = true; # why i would want appstore to be disabled ???
    autoUpdateApps.enable = true;
    cli.memoryLimit = "4G";
  };

  environment.systemPackages =
    let
      php = pkgs.php.buildEnv { extraConfig = "memory_limit = 4G"; };
    in
    [
      php
    ];
}
