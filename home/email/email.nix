{ pkgs, ... }: {
  programs.mbsync = {
    enable = true;
    # TODO use agenix?
    extraConfig = builtins.readFile ./.mbsyncrc;
  };
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = { preNew = "mbsync -a"; };
  };
  accounts.email = {
    accounts.gmail = {
      address = "thomaslaich@gmail.com";
      imap.host = "imap.gmail.com";
      # mbsync = {
      #   enable = true;
      #   create = "maildir";
      # };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      realName = "Thomas Laich";
      passwordCommand = "op item get smtp.gmail.com --fields password";
      smtp = {
        tls.useStartTls = true;
        host = "smtp.gmail.com";
        port = 587;
      };
      userName = "thomaslaich@gmail.com";
    };
  };
}
