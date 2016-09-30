resource storage100 {

    net {
          shared-secret "dblapro-askldzxczxkdfh100";  
    }

    volume 100 {
        device minor 100;
        disk /dev/disk/by-label/storage100;
        meta-disk /dev/sdd;
    }
    
    on 6587-dblapro-edss {
        node-id   0;
        address 10.100.101.135:7701;
    }

    on 6588-dblapro-edss {
        node-id   1;
        address 10.100.101.136:7701;
    }

    on 6589-dblapro-edss {
        node-id   2;
        address 10.100.101.137:7701;
    }

     connection {
          host 6587-dblapro-edss port 7701;
          host 6588-dblapro-edss port 7701;
      }

      connection {
          host 6587-dblapro-edss port 7701;
          host 6589-dblapro-edss port 7701;
      }

      connection {
         host 6588-dblapro-edss port 7701;
         host 6589-dblapro-edss port 7701;
       }



 }
