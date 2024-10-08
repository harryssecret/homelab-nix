{ config, lib, ... }:
{
  imports = [ ./forgejo-smtp.nix ];
  sops.secrets.smtp_address = { };
  sops.secrets.smtp_password = {
    owner = "forgejo";
  };
  sops.secrets.forgejoInitialMail = {
    owner = "forgejo";
  };
  sops.secrets.forgejoInitialPassword = {
    owner = "forgejo";
  };

  services.forgejo = {
    enable = true;
    lfs.enable = true;
    database = {
      type = "postgres";
    };
    settings = {
      server = {
        DOMAIN = "git.hypervirtual.world";
        ROOT_URL = "https://git.hypervirtual.world";
        HTTP_PORT = 3333;
      };
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
      mailer = {
        ENABLED = true;
      };
      service.DISABLE_REGISTRATION = true;
    };
    mailerPasswordFile = config.sops.secrets.smtp_password.path;
  };

  systemd.services.forgejo.preStart = ''
    create="${lib.getExe config.services.forgejo.package} admin user create"
    $create --admin --email "`cat ${config.sops.secrets.forgejoInitialMail.path}`" --username you --password "`cat ${config.sops.secrets.forgejoInitialPassword.path}`" &>/dev/null || true
  '';
}
