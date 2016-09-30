
-module(task_syslog_sender).
-export([handler/2]).
-import(file,[write_file/2]).
-import(gen_udp,[open/2,send/4,close/1,recv/2]).
-import(mon_util,[clock/0]).

handler(M, {new_state, _Settings, TaskSettings, Host}) -> handler(M, {TaskSettings, Host,[]});
handler({ add, K, V, _Time }, {TaskSettings, Host, Queue }) ->
    { TaskSettings, Host, [ {[ {K,V} ]} |Queue] };
handler(ask, {TaskSettings, Host, Queue }) ->
    _Body = jiffy:encode({[{data,Queue}]}),
	Msg = <<"<10>123 456 logitoring ","\"\":\"","\"">>,		
	write_file("/var/run/syslog.send.out",Msg),
	{ok, Sock} = gen_udp:open(0, [binary]),
	ok = send(Sock, {127,0,0,1}, 514, Msg),
    gen_udp:close(Sock),
    { TaskSettings, Host, [] }.

    
% @cee:{"key":"value"}