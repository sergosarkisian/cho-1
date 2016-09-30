
-module(task_drbdfree).
-export([handler/2]).
-import(os,[cmd/1]).
-import(mon_util,[
    drbd_settings/3, disk_parse_send/4,
    nocol/0, strcol/1, intcol/1, npercentcol/1
]).

handler(Msg,{new_state, Settings, TaskSettings, Send}) -> 
    handler(Msg,drbd_settings(Settings, TaskSettings, Send));
handler(ask, State) ->
    disk_parse_send(State, "drbdfree", cmd("df"), [
        strcol("name"), intcol("size,total"), intcol("size,used"), 
        intcol("size,free"), npercentcol("size,pfree"), strcol("mountpoint")
    ]),
    disk_parse_send(State, "drbdfree", cmd("df -i"), [
        strcol("name"), intcol("inode,total"), intcol("inode,used"), 
        intcol("inode,free"), npercentcol("inode,pfree"), strcol("mountpoint")
    ]),
    State.
