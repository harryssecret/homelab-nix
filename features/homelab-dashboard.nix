{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.homepage-dashboard;
  ip = cfg.baseURL;
in
{
  options = {
    homepage-dashboard.baseURL = mkOption {
      type = types.str;
      default = "192.168.1.177";
    };
    homepage-dashboard.proxmoxVEIp = mkOption {
      type = types.str;
      default = "192.168.1.10";
    };
    homepage-dashboard.proxmoxBSIp = mkOption {
      type = types.str;
      default = "";
    };
    homepage-dashboard.piholeURL = mkOption {
      type = types.str;
      default = "192.168.1.25";
    };
  };

  #TODO: add Radarr/Sonarr/... api key support
  config = {
    sops.defaultSopsFile = ../secrets/service-key.json;
    sops.defaultSopsFormat = "json";
    sops.secrets = {
      sonarr = { };
      radarr = { };
      jellyfin = { };
      jellyseerr = { };
      pihole = { };
      transmission = { };
      prowlarr = { };
      proxmoxPassword = { };
      proxmoxUsername = { };
    };

    services.homepage-dashboard = {
      enable = true;
      settings = {
        "headerStyle" = "boxed";
        "language" = "fr";
      };
      widgets = [
        {
          resources = {
            cpu = true;
            disk = "/";
            memory = true;
          };
        }
        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };
        }
      ];

      services = [
        {
          "Divertissement" = [
            {
              "Jellyfin" = {
                icon = "jellyfin";
                description = "Permet de regarder ou écouter du contenu.";
                href = "http://${ip}:8096";
                widget = {
                  type = "jellyfin";
                  url = "http://${ip}:8096";
                  key = config.sops.secrets.jellyfin;
                };
              };
            }
            {
              "Calibre-web" = {
                icon = "calibre";
                description = "Serveur de livres";
                href = "http://${ip}:8083";
              };
            }
            {
              "Serveur Minecraft poulet" = {
                icon = "minecraft";
                description = "serveur des trois poulets";
              };
            }
          ];
        }
        {
          "Téléchargement" = [
            {
              "Jellyseerr" = {
                icon = "jellyseerr";
                description = "Moteur de recherche de films/séries";
                href = "http://${ip}:5055";

                widget = {
                  type = "jellyseerr";
                  url = "http://${ip}:5055";
                  key = config.sops.secrets.jellyseerr;
                };
              };
            }
            {
              "slskd" = {
                icon = "slskd";
                description = "Pour télécharger/partager de la musique";
                href = "http://${ip}:5030";
              };
            }
            {
              "Prowlarr" = {
                icon = "prowlarr";
                description = "Indexe les différents sites de téléchargement";
                href = "http://${ip}:9696/";
                widget = {
                  type = "prowlarr";
                  key = config.sops.secrets.prowlarr;
                  url = "http://${ip}:9696";
                };
              };
            }
            {

              "Sonarr" = {
                icon = "sonarr";
                description = "Moteur de recherche pour les séries";
                href = "http://${ip}:8989/";
                widget = {
                  type = "sonarr";
                  url = "http://${ip}:9696";
                  key = config.sops.secrets.sonarr;
                };
              };
            }
            {
              "Radarr" = {
                icon = "radarr";
                description = "Moteur de recherche pour les films";
                href = "http://${ip}:7878/";
                widget = {
                  type = "radarr";
                  key = config.sops.secrets.radarr;
                  url = "http://${ip}:7878";
                };
              };
            }
            {

              "Transmission" = {
                icon = "transmission";
                description = "s'occupe du téléchargement des fichiers";
                href = "http://${ip}:9091";
                widget = {
                  type = "transmission";
                };
              };
            }
          ];
        }
        {
          "Utilitaires" = [
            {
              "Photoprism" = {
                icon = "photoprism";
                description = "Sauvegarde de photos";
                href = "http://${ip}:2342";
              };

            }
            {
              "Searx" = {
                icon = "searx";
                description = "Moteur de recherche privé pour remplacer Google.";
                href = "http://${ip}:8080";
              };
            }
          ];
        }
        {
          "Administration" = [
            /*
              {
                "Proxmox Backup Server" = {
                  icon = "proxmox-light";
                  description = "Permet de sauvegarder le serveur.";
                  href = "https://${cfg.proxmoxBSIp}:8007";
                };
              }
            */
            {
              "Proxmox VE" = {
                icon = "proxmox";
                description = "Panneau de controle des machines virtuelles";
                href = "https://${cfg.proxmoxVEIp}:8006";
                widget = {
                  type = "proxmox";
                  username = config.sops.secrets.proxmoxUsername;
                  key = config.sops.secrets.proxmoxPassword;
                  url = "https://${cfg.proxmoxVEIp}:8006";
                  node = "pve";
                };
              };
            }
            {
              "Pi.hole" = {
                icon = "pihole";
                description = "Bloqueur de pubs DNS/DHCP";
                href = "http://${cfg.piholeURL}/admin";
                widget = {
                  type = "pihole";
                  key = config.sops.secrets.pihole;
                  url = "http://${cfg.piholeURL}/admin/api.php";
                };
              };
            }
            {
              "Grafana" = {
                icon = "grafana";
                description = "Visualiseur de graphiques";
                href = "http://${ip}:3000";
              };
            }
            {
              "InfluxDB" = {
                icon = "influxdb";
                description = "Traite les statistiques du serveur Proxmox";
                href = "http://192.168.1.157:8086";
              };
            }
            {
              "Uptime Kuma" = {
                icon = "uptimekuma";
                description = "Surveille l'état des différents services";
                href = "http://${ip}:4000";
              };
            }
          ];
        }
      ];

    };
  };
}
