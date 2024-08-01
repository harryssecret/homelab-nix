{ config, ... }:
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      sonarrAnime = {
        image = "lscr.io/linuxserver/sonarr:latest";
        volumes = [ "sonarr_data:/config" "/srv/Multimedia/SeriesTV:/tv"  "/srv/Multimedia/Torrents:/downloads" ];
        ports = [ "8888:80" ];
        environment = {
          "PUID" = "1000";
          "GUID" = "1000";
          "TZ" = "Europe/Paris";
        };
      };
    };
  };
}