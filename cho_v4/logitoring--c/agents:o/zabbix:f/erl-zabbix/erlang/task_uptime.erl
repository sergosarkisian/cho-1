
-module(task_uptime).
-export([handler/2]).
-import(mon_util,[read_file_special/2]).
-import(string,[tokens/2]).

handler(ask, State) ->
    {_Status, _Settings, _TaskSettings, Send} = State,
    File = read_file_special("/proc/uptime", 1024),
	[[H|_]] = [tokens(Line, " ") || Line <- tokens(File, "\n")],
	Uptime = list_to_float(H),
	Send(<<"module.system[time,uptime,local]">>, Uptime),
    State.
