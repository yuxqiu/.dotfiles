{
  flake.modules.nixos.journald = {
    services.journald.settings.Journal = {
      SystemMaxUse = "50M";
      SystemMaxFileSize = "50M";
      MaxRetentionSec = "30day";
      Compress = "yes";
      ForwardToSyslog = "no";
      ForwardToKMsg = "no";
      ForwardToConsole = "no";
      ForwardToWall = "no";
      RateLimitIntervalSec = "30s";
      RateLimitBurst = "10000";
    };
  };
}
