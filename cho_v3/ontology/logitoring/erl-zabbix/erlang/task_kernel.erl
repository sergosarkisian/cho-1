
-module(task_kernel).
-export([handler/2]).
-import(os,[cmd/1]).
-import(string,[tokens/2]).
-import(mon_util,[intcol/1]).

handler(ask, State) ->
    {_Status, _Settings, _TaskSettings, Send} = State,
    Head = [
	intcol("module.system[kernel,version,local]"),
	intcol("module.system[kernel,major,local]"),
	intcol("module.system[kernel,minor,local]"),
	intcol("module.system[kernel,revision,local]")
    ],
    Cmd = os:cmd("uname -r"),
    [[A,B,C]] = [tokens(Line, ".") || Line <- tokens(Cmd, "\n")],
    [D,E,_] = tokens(C, "-"),
    Cells = [A,B,D,E],
    for_cs(Head,Cells,fun({K,Conv},V) ->
        Send(K, Conv(V))
    end), State.
    
for_cs([H|HL],[V|VL],F) -> F(H,V), for_cs(HL,VL,F);
for_cs([],[],_) -> ok.
