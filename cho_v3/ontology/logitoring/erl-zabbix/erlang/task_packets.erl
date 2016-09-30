
-module(task_packets).
-export([handler/2]).
-import(string,[tokens/2]).

handler(ask,State) ->
    {new_state, _Settings, _TaskSettings, Send} = State,
    Content = os:cmd("/bin/netstat -s"),
    ok = packets_info(Send, tokens(Content, " \n")),
    State.

packets_info(Send,["TCPPureAcks:",V|T]) -> packets_info_send(Send,<<"module.packets[tcp,pureacks,local]">>,V,T);

packets_info(Send,[_|T]) -> packets_info(Send,T);
packets_info(_Send,[]) -> ok.

packets_info_send(Send,K,V,T) -> Send(K,list_to_integer(V)), packets_info(Send,T).
