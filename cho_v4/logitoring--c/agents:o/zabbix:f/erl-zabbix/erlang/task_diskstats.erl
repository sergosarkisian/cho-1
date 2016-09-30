
-module(task_diskstats).
-export([handler/2]).
-import(mon_util,[
    disk_settings/3, disk_parse_send/4,
    read_file_special/2, 
    nocol/0, strcol/1, intcol/1
]).

handler(Msg,{new_state, Settings, TaskSettings, Send}) -> 
    handler(Msg,disk_settings(Settings, TaskSettings, Send));
handler(ask, State) ->
    disk_parse_send(State, "diskstats", read_file_special("/proc/diskstats",4096), [
        nocol(), nocol(), strcol("name"),
        intcol("read,ops"), intcol("read,merged"), intcol("read,sectors"), intcol("read,ms"),
        intcol("write,ops"), intcol("write,merged"), intcol("write,sectors"), intcol("write,ms"),
        intcol("io,active"), intcol("io,ms"), intcol("io,weight")
    ]),
    State.
