{
  config,
  lib,
  secrets,
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
    sops.secrets."homepage" = {
      sopsFile = "${secrets}/secrets/homepage.env";
      format = "dotenv";
    };

    services.caddy.virtualHosts."http://sisyphe.normandy.hypervirtual.world".extraConfig = ''
        reverse_proxy :8082
      '';

    services.homepage-dashboard = {
      enable = true;
      environmentFile = config.sops.secrets."homepage".path;
      settings = {
        headerStyle = "boxed";
        language = "fr";
        title = "sillybox home !!";
        layout = [
          {
            "Vidéos & Séries" = {
              style = "row";
              columns = 4;
            };
          }
          {
            "Administration" = {
              style = "row";
              columns = 4;
            };
          }
        ];
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

      bookmarks = [ { code = [ { "Github" = [ { href = "https://github.com"; } ]; } ]; } ];

      services = [
        {
          "Divertissement" = [

            {
              "Serveur Minecraft poulet" = {
                icon = "minecraft";
                description = "serveur des trois poulets";
                widget = {
                  type = "minecraft";
                  url = "udp://${ip}:25565";
                };
              };
            }
            {
              "Crafty-controller" = {
                description = "Gestionnaire de serveur Minecraft";
                href = "https://192.168.1.177:8443";
              };
            }
          ];
        }
        {
          "Lecture" = [
            {
              "Calibre-web" = {
                icon = "calibre";
                description = "Serveur de livres";
                href = "http://books.hypervirtual.world";
              };
            }
            {
              "Freshrss" = {
                icon = "freshrss";
                description = "Récupère les articles";
                href = "http://freshrss.hypervirtual.world";
              };
            }
          ];
        }
        {
          "Vidéos & Séries" = [
            {

              "Jellyfin" = {
                icon = "jellyfin";
                description = "Permet de regarder ou écouter du contenu.";
                href = "http://media.hypervirtual.world";
                widget = {
                  type = "jellyfin";
                  url = "http://${ip}:8096";
                  enableBlocks = true;
                  key = "{{HOMEPAGE_VAR_JELLYFIN}}";
                };
              };
            }
            {
              "Jellyseerr" = {
                icon = "jellyseerr";
                description = "Moteur de recherche de films/séries";
                href = "http://katflix.sisyphe.normandy.hypervirtual.world";

                widget = {
                  type = "jellyseerr";
                  url = "http://${ip}:5055";
                  key = "{{HOMEPAGE_VAR_JELLYSEERR}}";
                };
              };
            }
            {
              "slskd" = {
                icon = "slskd";
                description = "Pour télécharger/partager de la musique";
                href = "http://slskd.sisyphe.normandy.hypervirtual.world";
              };
            }
            {
              "Prowlarr" = {
                icon = "prowlarr";
                description = "Indexe les différents sites de téléchargement";
                href = "http://prowlarr.sisyphe.normandy.hypervirtual.world";
                widget = {
                  type = "prowlarr";
                  key = "{{HOMEPAGE_VAR_PROWLARR}}";
                  url = "http://${ip}:9696";
                };
              };
            }
            {
              "Sonarr" = {
                icon = "sonarr";
                description = "Moteur de recherche pour les séries";
                href = "http://sonarr.sisyphe.normandy.hypervirtual.world";
                widget = {
                  type = "sonarr";
                  url = "http://${ip}:8989";
                  key = "{{HOMEPAGE_VAR_SONARR}}";
                };
              };
            }
            {
              "Sonarr anime" = {
                icon = "sonarr";
                description = "Moteur de recherche pour les séries animées";
                href = "http://sonarr-anime.sisyphe.normandy.hypervirtual.world";
                widget = {
                  type = "sonarr";
                  url = "http://${ip}:8999";
                  key = "{{HOMEPAGE_VAR_SONARRANIME}}";
                };
              };
            }
            {
              "Radarr" = {
                icon = "radarr";
                description = "Moteur de recherche pour les films";
                href = "http://radarr.sisyphe.normandy.hypervirtual.world";
                widget = {
                  type = "radarr";
                  key = "{{HOMEPAGE_VAR_RADARR}}";
                  url = "http://${ip}:7878";
                };
              };
            }
            {
              "Bazarr" = {
                icon = "bazarr";
                description = "Vérifie les sous titres des films/séries.";
                href = "http://bazarr.sisyphe.normandy.hypervirtual.world";
                widget = {
                  type = "bazarr";
                  key = "{{HOMEPAGE_VAR_BAZARR}}";
                  url = "http://${ip}:6767";
                };
              };
            }
            {
              "Bazarr anime" = {
                icon = "bazarr";
                description = "Vérifie les sous titres des séries animées.";
                href = "http://bazarr-anime.sisyphe.normandy.hypervirtual.world";
                widget = {
                  type = "bazarr";
                  key = "{{HOMEPAGE_VAR_BAZARRANIME}}";
                  url = "http://${ip}:6768";
                };

              };
            }
            {

              "Transmission" = {
                icon = "transmission";
                description = "s'occupe du téléchargement des fichiers";
                href = "http://transmission.sisyphe.normandy.hypervirtual.world";
                widget = {
                  type = "transmission";
                  url = "http://${ip}:9091";
                  username = "{{HOMEPAGE_VAR_TRANSMISSIONUSERNAME}}";
                  password = "{{HOMEPAGE_VAR_TRANSMISSIONPASSWORD}}";
                };
              };
            }
          ];
        }
        {
          "Utilitaires" = [
            {
              "Nextcloud" = {
                icon = "nextcloud";
                description = "Sauvegarde de données";
                href = "https://cloud.hypervirtual.world";
              };
            }
            {
              "4get" = {
                icon = "searx";
                description = "Moteur de recherche privé pour remplacer Google.";
                href = "https://4get.hypervirtual.world";
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
                  username = "{{HOMEPAGE_VAR_PROXMOXUSERNAME}}";
                  password = "{{HOMEPAGE_VAR_PROXMOXPASSWORD}}";
                  url = "https://${cfg.proxmoxVEIp}:8006";
                  node = "pve";
                };
              };
            }
            {
              "Pi.hole" = {
                icon = "pi-hole";
                description = "Bloqueur de pubs DNS/DHCP";
                href = "http://${cfg.piholeURL}/admin";
                widget = {
                  type = "pihole";
                  key = "{{HOMEPAGE_VAR_PIHOLE}}";
                  url = "http://${cfg.piholeURL}";
                };
              };
            }
            {
              "Grafana" = {
                icon = "grafana";
                description = "Visualiseur de graphiques";
                href = "http://grafana.sisyphe.normandy.hypervirtual.world";
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
                icon = "uptime-kuma";
                description = "Surveille l'état des différents services";
                href = "http://uptime.sisyphe.normandy.hypervirtual.world";
              };
            }
            {
              "Uptime Robot" = {
                icon = "uptime-kuma";
                description = "Surveille l'état des sites (hors réseau maison)";
                widget = {
                  type = "uptimerobot";
                  url = "https://api.uptimerobot.com";
                  key = "{{HOMEPAGE_VAR_UPTIMEROBOT}}";
                };
              };
            }
          ];
        }
      ];

    };
  };
}
