{ ... }:
{
  programs.zsh = {
    shellAliases = {
      # JDK
      jdks = "/usr/libexec/java_home -V";
    };

    siteFunctions = {
      jdk = ''
        version=$1
        export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
        java -version
      '';
    };
  };
}
