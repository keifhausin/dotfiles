function gradleDebug() {
    GRADLE_OPTS="-Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y" gw --no-daemon "$@"
}

function gradleUserHomeLocal() {
    GRADLE_USER_HOME="$(pwd)/.gradle" gw "$@"
}

function gradle-profiler() {
	~/.gradle-profiler/gradlew -b ~/.gradle-profiler/build.gradle installDist
	echo ""
	~/.gradle-profiler/build/install/gradle-profiler/bin/gradle-profiler "$@"
}

# Useful for profiling the Gradle launcher and adhoc profiling

function gradleYk() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib" gw --no-daemon "$@"
}

function gradleYkSample() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=sampling,probe_disable=*,onexit=snapshot" gw --no-daemon "$@"
}

function gradleYkAlloc() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=alloceach=10,allocsizelimit=4096,onexit=snapshot" gw --no-daemon "$@"
}

function gradleYkAllocCount() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=alloc_object_counting,onexit=snapshot" gw --no-daemon "$@"
}

function  curl_time() {
    curl -so /dev/null -w "\
   namelookup:  %{time_namelookup}s\n\
      connect:  %{time_connect}s\n\
   appconnect:  %{time_appconnect}s\n\
  pretransfer:  %{time_pretransfer}s\n\
     redirect:  %{time_redirect}s\n\
starttransfer:  %{time_starttransfer}s\n\
-------------------------\n\
        total:  %{time_total}s\n" "$@"
}

nvm_auto_use() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}