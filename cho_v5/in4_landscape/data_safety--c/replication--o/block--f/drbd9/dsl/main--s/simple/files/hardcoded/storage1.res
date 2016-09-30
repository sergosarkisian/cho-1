resource storage1 {

    net {
          shared-secret "dblapro-askldzxczxkdfh1";  
    }

    volume 1 {
        device minor 1;
        disk /dev/disk/by-label/storage1;
        meta-disk /dev/sdg;
    }
    
    on 6587-dblapro-edss {
        node-id   0;
        address 10.100.101.135:7703;
    }

    on 6588-dblapro-edss {
        node-id   1;
        address 10.100.101.136:7703;
    }

    on 6589-dblapro-edss {
        node-id   2;
        address 10.100.101.137:7703;
    }

     connection {
          host 6587-dblapro-edss port 7703;
          host 6588-dblapro-edss port 7703;
      }

      connection {
          host 6587-dblapro-edss port 7703;
          host 6589-dblapro-edss port 7703;
      }

      connection {
         host 6588-dblapro-edss port 7703;
          host 6589-dblapro-edss port 7703;
       }



 }

