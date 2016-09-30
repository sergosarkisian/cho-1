
-module(task_netstats).
-export([handler/2]).
-import(mon_util,[
    neti_settings/3, neti_parse_send/4,
    read_file_special/2,
    nocol/0, strcol/1, intcol/1
]).

handler(Msg,{new_state, Settings, TaskSettings, Send}) ->
    handler(Msg, neti_settings(Settings, TaskSettings, Send));
handler(ask, State) ->
    neti_parse_send(State, "netstats", read_file_special("/proc/net/dev", 2048), [
        strcol("name"),
        intcol("rx,bytes"), intcol("rx,packets"), intcol("rx,errors"), intcol("rx,drop"),
        intcol("rx,fifo"), intcol("rx,frame"), intcol("rx,zip"), intcol("rx,mcast"),
        intcol("tx,bytes"), intcol("tx,packets"), intcol("tx,errors"), intcol("tx,drop"),
        intcol("tx,fifo"), intcol("tx,frame"), intcol("tx,zip"), intcol("tx,mcast")
    ]),
    State.
