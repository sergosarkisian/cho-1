zypper ar -cf --name "server::proxy" http://download.opensuse.org/repositories/server:/proxy/openSUSE_Leap_42.1/ "server::proxy"
zypper ar -cf --name "server::http" http://download.opensuse.org/repositories/server:/http/openSUSE_Leap_42.1/ "server::http"

"java-1_8_0-openjdk" "log4j" "gcc-java" "java-1_8_0-openjdk" "java-1_8_0-openjdk-devel" "javacc" "javacc3"
zypper --gpg-auto-import-keys in -C --no-recommends "exim" "haproxy" "nginx-syslog-cone"

"perl-JSON-XS" "perl-List-MoreUtils"

http://dl.bintray.com/sbt/rpm/sbt-0.13.8.rpm