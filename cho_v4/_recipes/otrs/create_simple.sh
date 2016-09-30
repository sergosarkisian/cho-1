su -s /bin/bash wwwrun -c "/home/storage/IT/webapp/otrs/otrs-app/bin/otrs.Console.pl Admin::Group::Add --name FE::ESS"
su -s /bin/bash wwwrun -c "/home/storage/IT/webapp/otrs/otrs-app/bin/otrs.Console.pl Admin::Role::Add --name FE::ESS"
su -s /bin/bash wwwrun -c "/home/storage/IT/webapp/otrs/otrs-app/bin/otrs.Console.pl Admin::Queue::Add --name FE::ESS --group FE::ESS "
su -s /bin/bash wwwrun -c "/home/storage/IT/webapp/otrs/otrs-app/bin/otrs.Console.pl Admin::SystemAddress::Add --name FE::ESS --email-address ess@help.cone.ee --queue-name FE::ESS"
su -s /bin/bash wwwrun -c "/home/storage/IT/webapp/otrs/otrs-app/bin/otrs.Console.pl Admin::Group::RoleLink --role-name FE::ESS --group-name FE::ESS --permission rw"
su -s /bin/bash wwwrun -c "/home/storage/IT/webapp/otrs/otrs-app/bin/otrs.Console.pl Admin::Group::RoleLink --role-name FE::ESS --group-name BE::Linux --permission move_into"
su -s /bin/bash wwwrun -c "/home/storage/IT/webapp/otrs/otrs-app/bin/otrs.Console.pl Admin::Group::RoleLink --role-name FE::ESS --group-name BE::NOC --permission move_into"
su -s /bin/bash wwwrun -c "/home/storage/IT/webapp/otrs/otrs-app/bin/otrs.Console.pl Admin::Group::RoleLink --role-name FE::ESS --group-name BE::Windows --permission move_into"
su -s /bin/bash wwwrun -c "/home/storage/IT/webapp/otrs/otrs-app/bin/otrs.Console.pl Admin::Group::RoleLink --role-name FE::ESS --group-name BE::Cone --permission move_into"
su -s /bin/bash wwwrun -c "/home/storage/IT/webapp/otrs/otrs-app/bin/otrs.Console.pl Admin::Group::RoleLink --role-name FE::ESS --group-name FE --permission move_into"

su -s /bin/bash wwwrun -c "/home/storage/IT/webapp/otrs/otrs-app/bin/otrs.Console.pl Admin::Role::UserLink --user-name a.dmitrijev --role-name FE::ESS"

