# execute with docksh <id>
function docksh(){
    docker exec -it $1 /bin/bash
}

# download file and verify their checksum
function checksum() {
  s=$(curl -fsSL "$1")
  if ! command -v shasum >/dev/null
  then
    shasum() { sha1sum "$@"; }
  fi
  c=$(printf %s\\n "$s" | shasum | awk '{print $1}')
  if [ "$c" = "$2" ]
  then
    printf %s\\n "$s"
  else
    echo "invalid checksum $c != $2" 1>&2;
  fi
  unset s
  unset c
}

# activate different jdk versions
function jdk() {
    version=$1
    export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
    java -version
}
