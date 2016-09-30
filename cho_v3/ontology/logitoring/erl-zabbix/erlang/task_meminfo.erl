
-module(task_meminfo).
-export([handler/2]).
-import(string,[tokens/2]).
-import(mon_util,[read_file_special/2]).

handler(ask,State) ->
    {new_state, _Settings, _TaskSettings, Send} = State,
    Content = read_file_special("/proc/meminfo",2048),
    ok = mem_info(Send, tokens(Content, " \n")),
    State.

mem_info(Send,["MemTotal:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,total,local]">>,V,T);
mem_info(Send,["MemFree:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,free,local]">>,V,T);
mem_info(Send,["Buffers:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,buffers,local]">>,V,T);
mem_info(Send,["Cached:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,cached,local]">>,V,T);
mem_info(Send,["Active:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,active,local]">>,V,T);
mem_info(Send,["Inactive:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,inactive,local]">>,V,T);
mem_info(Send,["SwapTotal:",V,"kB","SwapFree:",W,"kB"|T]) ->
    P = (list_to_integer(W) + list_to_integer("1"))* list_to_integer("100") / (list_to_integer(V) + list_to_integer("1")),
    Send(<<"module.meminfo[swap,total,local]">>, list_to_integer(V)*1024),
    Send(<<"module.meminfo[swap,free,local]">>, list_to_integer(W)*1024),
    mem_swap_send(Send,<<"module.meminfo[swap,pfree,local]">>,P,T);
mem_info(Send,["SwapCached:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[swap,cached,local]">>,V,T);
mem_info(Send,["Dirty:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,dirty,local]">>,V,T);
mem_info(Send,["Shmem:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,shmem,local]">>,V,T);
mem_info(Send,["CommitLimit:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,commitlimit,local]">>,V,T);
mem_info(Send,["Committed_AS:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,aommitted_as,local]">>,V,T);
mem_info(Send,["DirectMap4k:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,directmap4k,local]">>,V,T);
mem_info(Send,["DirectMap2M:",V,"kB"|T]) -> mem_info_send(Send,<<"module.meminfo[mem,directmap2m,local]">>,V,T);


mem_info(Send,[_|T]) -> mem_info(Send,T);
mem_info(_Send,[]) -> ok.

mem_info_send(Send,K,V,T) -> Send(K,list_to_integer(V)*1024), mem_info(Send,T).
mem_swap_send(Send,K,P,T) -> Send(K,P), mem_info(Send,T).
