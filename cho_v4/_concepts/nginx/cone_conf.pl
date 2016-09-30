my $nginx_port = tnctl_find_free_port();

$cfg{haproxy}{http}{nginx} = sub{(
    { priority=>'path', acl=>'{ path_beg /cc/ }', backend=>'perl', server_port=>$ENV{WE_PORT} },
    { priority=>'default', acl=>'METH_GET', backend=>'nginx', server_port=>$nginx_port },
    { priority=>'default', acl=>'default', backend=>'perl', server_port=>$ENV{WE_PORT} }
)};

sub initconf_nginx{
%>
worker_processes      1;    #for bereset, notes...
worker_rlimit_nofile    8192;
worker_priority         -1;
syslog local6 nginx;
pid		tmp/nginx/nginx.pid;

events {
    use epoll;
    worker_connections  4096;
    multi_accept        on;
}

http {

##UNMERGED
    #recursive_error_pages    on;
    #proxy_intercept_errors    off;
    #proxy_next_upstream       off;
    #proxy_redirect            off;      

	types {
        application/vnd.oasis.opendocument.text odt;
    }
    
    
  ### global ###
    server_tokens           off;
    server_name_in_redirect off;
    ignore_invalid_headers  on;
    include                 /etc/nginx/mime.types;
    if_modified_since       before;
    root                    /etc/nginx/content/;
    ssi                     on;
    ssi_silent_errors       on; # testing=off
    add_header X-Frame-Options SAMEORIGIN;

    ### tcp ###
    tcp_nodelay             on;
    tcp_nopush              on;
    sendfile                on;
    keepalive_requests      100;

    ### timeouts ###
    resolver_timeout        6s;
    client_header_timeout   290;
    client_body_timeout     1200;
    send_timeout            310;
    keepalive_timeout       65 20;

    ## buffers ###
    client_header_buffer_size   128k;
    client_body_buffer_size    	4M;
    large_client_header_buffers 4 4k;
    client_max_body_size        1024M;
    output_buffers              1 128k;
    postpone_output             1460;
    aio        					on;
    directio   					512;
    server_names_hash_bucket_size 64;    

    ### errors ###
    recursive_error_pages   off;
    error_page              400 402 403 405 406 410 411 413 416 /40x.html;
    error_page              500 501 502 503 504 /50x.html;
    error_page              404 =410 /40x.html;
    error_page              443 =200 /test.png;

    ##Log
    #!!Need msec to be added to time format
    log_format main '@cee: {"cone_dd":"<.$cfg{dd_abbr}%>", "date":"$time_local", "host":"$host", "x-forwarded-for":"$http_x_forwarded_for", "x-client":"$http_x_client", "cli_ip":"$remote_addr", "cli_port":"$server_port", "method":"$request_method", "uri":"$request_uri", "proto":"$server_protocol", "status":"$status", "request_time":"$request_time", "bytes_sent":"$body_bytes_sent", "referrer":"$http_referer", "gzip_ratio":"$gzip_ratio", "user_agent":"$http_user_agent", "bauth_user":"$remote_user"}';
    
    #Syslog
    access_log syslog:notice main;
    error_log syslog:error;
    #Filelog
    open_log_file_cache     max=1024 inactive=30s min_uses=3 valid=5m;

    ### ssl ###
    ssl                         off;
    ssl_prefer_server_ciphers   on;
    ssl_ciphers                 RC4:HIGH:!aNULL:!MD5;
    ssl_protocols               TLSv1 SSLv3;
    ssl_session_cache           shared:TLSSL:16m;
    ssl_session_timeout         10m;
    #ssl_certificate            cert.pem;
    #ssl_certificate_key        cert.key;
    #ssl_client_certificate     chain.pem;
    #ssl_verify_client no;
    #ssl_verify_depth 3;

    ## Compression
    gzip              on;
    gzip_buffers      64 8k;
    gzip_comp_level   3;
    gzip_http_version 1.0;
    gzip_min_length   50;
    gzip_types        text/plain text/css image/x-icon application/x-javascript application/x-perl application/x-httpd-cgi application/xml;
    gzip_proxied      any;
    gzip_vary         on;
    gzip_disable “MSIE [1-6].(?!.*SV1)”;


    ### proxy-global ###
    proxy_intercept_errors      on; # testing=off
    proxy_ignore_client_abort   off;
    #proxy_redirect              http:// $scheme://;
    proxy_headers_hash_bucket_size 256;


    ### proxy-header ###
    #proxy_set_header        Accept-Encoding   "";
    proxy_set_header        Host              $http_host;
    proxy_set_header        X-Client          $remote_addr;
    proxy_set_header        X-Forwarded-By    $server_addr:$server_port;
    proxy_set_header        X-Forwarded-For   $remote_addr;
    #proxy_set_header       X-Forwarded-Class $classification; # custom
    proxy_set_header        X-Forwarded-Proto $scheme;
    map $scheme $msiis      { http off; https on; }
    proxy_set_header        Front-End-Https   $msiis;
    proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

    
    ### proxy-timeouts ###
    proxy_connect_timeout   12;
    proxy_send_timeout      1200;
    proxy_read_timeout      1200;
    
    ### proxy-buffers ###
    proxy_buffering             on;
    proxy_buffer_size           64k;
    proxy_buffers               256 64k;
    proxy_busy_buffers_size     64k;
    proxy_temp_file_write_size  10m;
    
    ### temp directories ###
    client_body_temp_path       tmp/nginx/client_body_temp_path;    
    proxy_temp_path             tmp/nginx/client_body_temp_path;
    fastcgi_temp_path           tmp/nginx/fastcgi_temp_path;
    uwsgi_temp_path             tmp/nginx/uwsgi_temp_path;
    scgi_temp_path              tmp/nginx/scgi_temp_path;
    
                                               


    perl_set $puri 'sub{
        my($r)=@_;
        my $uri = $r->variable("uri");
        $uri=~s/\+\d+$// and return $uri;
        $uri eq "/" and return "/index.html";
        $uri=~s{/[^/]+$}{} and return $uri;
        return $uri;
    }';
    

    
    <;for my $vdata(src_sites()){%>
    server {
        server_name <.join(' ', sort keys %{$$vdata{hosts}||die})%>;
        listen   127.0.0.1:<.$nginx_port%>;
        root     <.$$vdata{tmp_path}%>/htdocs;
        location / {
            try_files  $uri $puri @backend;
			expires                  240h;    
        }
        location @backend {
            proxy_pass     http://127.0.0.1:<.$ENV{WE_PORT}%>;
            #proxy_redirect bepass/ /;
            expires off;
            add_header Cache-Control private;
            proxy_set_header Host            $host;
        }
        location /nstat { stub_status on; }
    }
    <;}%>
}
<;
}