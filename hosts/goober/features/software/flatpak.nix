{config, ...}: {
  services.flatpak.enable = true;

  services.flatpak.packages = [
    "io.github.zen_browser.zen"
    "dev.vencord.Vesktop"
    "com.unicornsonlsd.finamp"
  ];

  services.flatpak.update.onActivation = true; 
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly"; # Default value
  };
}