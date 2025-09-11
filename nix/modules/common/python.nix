{ ... }: {
  home.file.".pythonrc".text = ''
    # enable syntax completion
    try:
        import readline
    except ImportError:
        ...
    else:
        import rlcompleter
        readline.parse_and_bind("tab: complete")
  '';
}
