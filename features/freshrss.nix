{ config, lib, ... }:
{
  sops.secrets = {
    freshrss_username = {
      path = ../secrets/freshrss.json;
      format = "json";
    };
    freshrss_password = {
      path = ../secrets/freshrss.json;
      format = "json";
    };
  };

  services.freshrss = {
    enable = true;
    language = "fr";
    defaultUser = config.sops.secrets.freshrss_username;
    passwordFile = "/run/secrets/freshrss";
    database = {
      type = "sqlite";
    };
  };
}
