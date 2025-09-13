{ ... }: {
  programs.zsh = {
    shellAliases = {
      # JDK
      jdks = "/usr/libexec/java_home -V";
    };

    # TODO: wait for next stable release that contains siteFunctions
    # siteFunctions = {
    #   jdk = ''
    #     version=$1
    #     export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
    #     java -version
    #   '';
    # };

    initContent = ''
      # activate different jdk versions
      function jdk() {
          version=$1
          export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
          java -version
      }
    '';
  };
}
