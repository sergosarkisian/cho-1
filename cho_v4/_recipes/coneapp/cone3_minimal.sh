zypper ar -cf --name "server::proxy" http://download.opensuse.org/repositories/server:/proxy/openSUSE_Leap_42.1/ "server::proxy"
zypper ar -cf --name "server::http" http://download.opensuse.org/repositories/server:/http/openSUSE_Leap_42.1/ "server::http"

zypper --gpg-auto-import-keys in -C --no-recommends "exim haproxy nginx-syslog-cone"

"perl-JSON-XS perl-List-MoreUtils"
