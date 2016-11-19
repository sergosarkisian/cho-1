resource storage10 {

    net {
          shared-secret "dblapro-askldzxczxkdfh10";  
    }

    volume 10 {
        device minor 10;
        disk /dev/disk/by-label/storage10;
        meta-disk /dev/sdg;
    }
    
    on 6587-dblapro-edss {
        node-id   0;
        address 10.100.101.135:7702;
    }

    on 6588-dblapro-edss {
        node-id   1;
        address 10.100.101.136:7702;
    }

    on 6589-dblapro-edss {
        node-id   2;
        address 10.100.101.137:7702;
    }

     connection {
          host 6587-dblapro-edss port 7702;
          host 6588-dblapro-edss port 7702;
      }

      connection {
          host 6587-dblapro-edss port 7702;
          host 6589-dblapro-edss port 7702;
      }

      connection {
         host 6588-dblapro-edss port 7702;
         host 6589-dblapro-edss port 7702;
       }



 }
