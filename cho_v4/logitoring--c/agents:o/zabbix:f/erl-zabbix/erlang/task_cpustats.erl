
-module(task_cpustats).
-export([handler/2]).
-import(mon_util,[
    cpu_settings/3, cpu_parse_send/4,
    read_file_special/2,
    nocol/0, strcol/1, intcol/1
]).

handler(Msg,{new_state, Settings, TaskSettings, Send}) ->
    handler(Msg,cpu_settings(Settings, TaskSettings, Send));
handler(ask, State) ->
    cpu_parse_send(State, "cpustats", read_file_special("/proc/stat",2048), [
        strcol("name"), intcol("stat,utime"), intcol("stat,ntime"), intcol("stat,stime"),
        intcol("stat,idletime"), intcol("stat,iowait"), intcol("stat,irq"), intcol("stat,softirq"),
        intcol("stat,steal"), intcol("stat,guest"), intcol("stat,gnice")
    ]),
    State.
