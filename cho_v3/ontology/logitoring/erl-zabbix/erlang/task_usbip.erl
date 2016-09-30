
-module(task_usbip).
-export([handler/2]).
-import(string,[tokens/2]).

handler(ask, State) ->
    {_Status, _Settings, _TaskSettings, Send} = State,
    Cmd = os:cmd("/usr/bin/pkcs11-tool --module=/usr/lib64/libeToken.so -T"),
	[_,_,C,_,_,_,_] = tokens(Cmd, "\n"),
    V = matching(re:run(C,"Majandus-\sja\sKommunikatsiooni")),
    Send(<<"module.pkcs11[status,value,local]">>, V),
    State.

matching({match,_}) -> 1;
matching(nomatch) -> 0.
