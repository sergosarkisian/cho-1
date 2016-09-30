/var/log/elasticsearch/*.log {
		su elasticsearch elasticsearch
        daily
        rotate 14
        copytruncate
        compress
        missingok
        notifempty
}