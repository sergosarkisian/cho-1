
-module(task_procnum).
-export([handler/2]).
-import(erlang,[system_info/1]).

handler(ask, State) ->
    {_Status, _Settings, _TaskSettings, Send} = State,
    Send(<<"module.procnum[cpus,total,local]">>, system_info(logical_processors_online)),
    State.
