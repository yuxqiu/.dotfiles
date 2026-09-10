{
  flake.modules.nixos.snowflake-dracaena = {
    # otherwise `less`/systemctl's pager doesn't recognize TERM values
    # from local terminal emulators (e.g. ghostty) over SSH.
    environment.enableAllTerminfo = true;
  };
}
