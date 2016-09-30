Условия:
+ человек с одного взгляда/оповещения определяет сущность
+ генерирование DNS-имён с CNAME
+ уникальность  и однозначная идентифицируемость сущности без двойных названий
 
#root
Naming - .pool
 
#client root
Naming - .{CLIENT}.pool
def parameter = context
 
Token delimiter - "--"
Tree elements delimiter - "."

Первое деление - на два ландшафта:
I. Серверный ландшафт
II. Сервисный ландшафт
 
 Серверный ландшафт состоит из двух слоёв:
 1) Юниты (units) или физические объекты
 2) Операционные системы (os) или их аналоги (виртуальные машины, контейнеры)
 
 Сервисный ландшафт состоит из трёх слоёв:
 1) Технологические сервисы (technology services, ts) - так сервисы привыкли видеть администраторы. Системный слой, отвечает за выбранную технологическую реализацию.
 2) Сервисы приложений (application service, as) - так сервисы привыкли видеть разработчики. Слой запускаемых приложений.
 3) Клиентские сервисы (client services, cs) - так сервисы привыкли видеть клиенты. Так сервис видется клиенту
 
 Каждый последующий слой включает в себя ссылки\линки на предыдущие.
 

 I. Servers landscape
# unit.{CLIENT}.pool - Physical objects
What		- Matherial object (dimensions, power consumtion)
Tokens 1	- {LOC_ADDR}--{LOC_CITY}--{LOC_COUNTRY}
Tokens 2 	- {IDENT}--{HUMAN_NAMING}--{ROLE}--{TYPE(prod/dev/test)}
IDENT 		- management_IP

Example		
        0a015498--hv02--hv--prod.rev3--supermicro--srv.veose14--muuga--ee.unit.tk.pool

# os.{CLIENT}.pool - Operation systems
What		- OS-bound with HW params, net params, OS params
Tokens 1 	- {ZONE_ID}, like VLAN tag or zone-specific integer
Tokens 2	- {OS_VER}--{OS_NAME}--{OS_TYPE}
Tokens 3 	- {IDENT}--{HUMAN_NAMING}--{ROLE}--{TYPE(prod/dev/test)}
IDENT 		- MAIN_MAC_ADDR_4_OCT (0a140279), same as main IP  for VM
 
Example:
        0afb0203--hv3--hvxen--prod.rev5--suse--l.3010.os.example.pool


II. Services landscape		
# ts.{CLIENT}.pool - Technology services (systemd checkable)

What		        - Techpool structure for logging patterns & systemd services
Tokens 1               - {OS_POOL_IDENT}
Tokens 2               - {CLASS--c}--{ORDER--o}--{FAMILY--f}--{GENUS--g}--{SPECIES--s}
OS_POOL_IDENT - MAIN_MAC_ADDR_4_OCT (0a140279), same as main IP  for VM

Example:
    services--c--virtualization--o--network--f--openvswitch--g--main--s.0afb0203.ts.example.pool
    logitoring--c--messagebus--o--syslog--f--rsyslog@client.0afcf15a5.ts.example.pool
    services--c--database--o--rdbms--f--oracle10g--g--main--s@wk10.0afcf15a5.ts.example.pool

# as.{CLIENT}.pool - Application services (middle-level abstract, systemd - depends on realisation)
What		- Service that aggregates upper levels into tech names for IT adm, internal usage & debugging
Tokens 1       - {S_DEPLOYED_MODEL}--{S_TECHNOLOGY}--{S_CLASS}
Tokens 2       - {S_NAME}--{STARTUP_TYPE (systemd/own/ts)}--{ S_TYPE(app/infra)}
Tokens 3 (net)       - {(t)cp/(u)dp/(h)ttp/(s)tls + TCP_PORT}--{TERMINATION_TP_PRODUCT}--{c(onsumer)/p(rovider)/g(ate)} 
Tokens 3 (systemd - {??}--{SYSTEMD_SERVICE/TIMER}--{e(xport)/i(mport)/s(ync)/j(ob)} 
Tokens 3 (infra - {??}--{SYSTEMD_SERVICE/TIMER--{ds(datasafety)/i(mport)/s(ync)/j(ob)} 
IDENT 		- Service name in HaProxy or some valueable service name ("infra_backup_rman")


Example	
        t8010--nginx--p.kodutehnika--systemd--app.hosting--php--web.as.example.pool
        t8003--apache2--p.tocean--own--app.cone2--cone--web.as.example.pool
        t1521--oracle10g--p.tocean--ts--app.se_conedb--oracle10g--database.as.example.pool

        ???
        host_finvalda+lt-tocean--c--haproxy--tocean..transocean--forwarding--cone.as.example.pool
        c_9103_tcp-infra_backup_sd


# cs.{CLIENT}.pool - Client services
What		- 
Tokens 1       - 
Tokens 2       - 
IDENT 		- 
