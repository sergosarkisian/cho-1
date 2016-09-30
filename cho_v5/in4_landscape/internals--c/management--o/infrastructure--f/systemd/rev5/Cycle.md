#### Rev5 internals--c--management--o--infrastructure--f--systemd
### 1_build

## Steps
- Source build
    - [ ] CI tools integration (+ )

- OBS build - source
    - [ ] personally updated packages (+ )
    - [ ] linkpac packages using openSUSE:Leap:42.1:Update repo (+ )
    - [ ] linkpac packages using any Tumbleweed repo (- )
    - [ ] service - downloaded packages (+ )
    - [ ] service - github packages (+ )

- OBS build - platforms
    - [ ] openSUSE TW (+ )
    - [ ] openSUSE Leap 42.1 (+ )

- Spec file
    - [ ] rev5 service naming (+ ) 
    - [ ] RPM lint is ok (+ ) 
    - [ ] systemd autostart/autoenable services (- ) 
    - [ ] all modules are in seperate packages (+ ) 

- Files
    - [ ] rev5 model are synced with package files (+ ) 
    - [ ] custom-made patches (- ) 
    - [ ] all patches are synced with developers (+ ) 
    - [ ] changelog is up-todate (+ ) 

- Packages accessibility
    - [ ] role-model repo tree (+ ) 

## Improvements 
- 
    - 

### 2_init

## Steps
- Repositories
    - [ ] C-O repo model (+ )
    - [ ] role-based repo model (+ )

- Packages 
    - [ ] ..(+ ) 

## Improvements 
- 
    - 

### 3_recipe

## Steps
- Complectation
    - [ ]  (+ ) 

## Improvements 
- 
    - 

### 4_security

## Steps

- Internal
    - [ ] Have a apparmor rule (+ )

- Network
    - [ ] Have a firewall rule (if network service) (+ ) 

- Auth
    - [ ] Have a PAM rule (if have auth) (+ ) 

## Improvements 
- 
    - 

### 5_service

## Steps
- Management
    - [ ]  profile.d aliases (+ ) 

- Systemd (if needed run as a service)
    - [ ] rev5 systemd template  (+ ) 
    - [ ] Tmpfiles if needed (+ ) 
    - [ ] adjusted Dependencies - Conflicts, Requires, After, ... (+ ) 
    - [ ] adjusted Install - WantedBy, RequiredBy, Alias (+ ) 
    - [ ] Correct "Type" in Service section (+ ) 
    - [ ] ExecReload command (+ ) 
    - [ ] Permissions - WorkingDirectory	  (+ )
    - [ ] Permissions - User,  Group  (+ ) 
    - [ ] Env file (+ ) 
    - [ ] BlockIO(R/W)Bandwidth (+ ) 

## Improvements 
- 
    - 

### 6_logitoring

## Steps
- Looging
    - [ ]  Have a cusom rsyslog rules (if no-JSON log implementation and/or file-based) (+ ) 
    - [ ]  (+ ) 

- Monitoring
    - [ ] Have a zabbix template (+ ) 

- Analytis
    - [ ] Have a kibana4 template (+ ) 
 
## Improvements 
*

### 7_datasafety

## Steps
- Wrappers
    - [ ] for Bareos usage (+ ) 
    - [ ] dumps & exports (+ ) 


## Improvements 
- 
    - 

-----
# Improvements tags
#B - Bugs, #R - Re-work, #N - New