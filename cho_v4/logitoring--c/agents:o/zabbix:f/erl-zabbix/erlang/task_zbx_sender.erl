
-module(task_zbx_sender).
-export([handler/2]).
-import(file,[write_file/2]).
-import(gen_tcp,[connect/3,send/2,recv/2,close/1]).
-import(mon_util,[clock/0]).

handler(M, {new_state, _Settings, TaskSettings, Host}) -> handler(M, {TaskSettings, Host,[]});
handler({ add, K, V, Time }, {TaskSettings, Host, Queue }) ->
    { TaskSettings, Host, [ {[ {host,Host}, {key,K}, {value,V}, {clock,Time} ]} |Queue] };
handler(ask, {TaskSettings, Host, Queue }) ->
    Body = jiffy:encode({[ {request,<<"sender data">>}, {data,Queue}, {clock,clock()} ]}),
    Size = byte_size(Body),
    Msg = <<"ZBXD\x01",Size:64/little,Body/binary>>,
	write_file("/var/run/zbx.send.out",Msg),
    {ok, Sock} = connect("x", 10051, [binary, {packet, 0}, {active, false}]),
    ok = send(Sock, Msg),
    {ok, Packet} = recv(Sock, 0),
    write_file("/var/run/zbx.recv.out",Packet),
    ok = close(Sock),
    { TaskSettings, Host, [] }.
