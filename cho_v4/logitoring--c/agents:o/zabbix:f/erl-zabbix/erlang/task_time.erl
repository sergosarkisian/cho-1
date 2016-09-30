
-module(task_time).
-export([handler/2]).
-import(mon_util,[clock/0]).

handler(ask, State) ->
    {_Status, _Settings, _TaskSettings, Send} = State,
    Send(<<"module.system[time,unixepoch,local]">>, clock()),
    State.
