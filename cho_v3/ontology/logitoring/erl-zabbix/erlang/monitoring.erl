
-module(monitoring).
-export([start/0,start/1]).
-import(os,[cmd/1]).
-import(string,[tokens/2]).
-import(lists,[foreach/2]).
-import(gb_sets,[from_list/1]).
-import(mon_util,[treemap/1,clock/0]).
-mode(compile).


prepare_serve(Settings, TaskName, Send) ->
    TaskSettings = gb_trees:get(TaskName, Settings),
    Type = gb_trees:get(<<"task_type">>, TaskSettings),
    Mod = list_to_atom("task_"++binary_to_list(Type)),
    NState = {new_state, Settings, TaskSettings, Send},
    {NState, TaskSettings, fun(Msg,State)-> apply(Mod,handler,[Msg,State]) end}.

spawn_serve(Settings, TaskName, Send) ->
    {NState, TaskSettings, Apply} = prepare_serve(Settings, TaskName, Send),
    Period = gb_trees:get(<<"poll_periods">>, TaskSettings),
    Worker_loop = fun(Loop,State)->
        receive Msg -> Loop(Loop,Apply(Msg,State)) end
    end,
    Worker = fun()->
        Worker_loop(Worker_loop, NState)
    end,
    Master_loop = fun(Loop,Pid)->
        receive
            {'EXIT',Pid,_} ->
                Loop(Loop,spawn_link(Worker));
            M ->
                Pid ! M,
                Loop(Loop,Pid)
        end
    end,
    Master = fun()->
        %register(list_to_atom(binary_to_list(TaskName)),self()),
        process_flag(trap_exit, true),
        Master_loop(Master_loop,spawn_link(Worker))
    end,
    Pid = spawn_link(Master),
    timer:send_interval(Period,Pid,ask),
    Pid.

init() ->
    ok = inets:start(),
    ssl:start().

settings() ->
    [HostStr] = tokens(cmd("hostname -f"),"\n"),
	[SrvName_l,SrvType_l,Net_l,View_l,_Cli_l,_None2] = tokens(HostStr,"."),	    
	%[_IdStr,_TypeStr,CliStr] = tokens(SrvName,"-"),
	Net = list_to_binary(Net_l), 
	View = list_to_binary(View_l), 
	SrvType = list_to_binary(SrvType_l), 
    Host = list_to_binary(SrvName_l),    
    { ok, SettingsJSON } = file:read_file(<<"/media/sysdata/rev5/_context/conf/monitoring/",View/binary,"/",Net/binary,"/",SrvType/binary,"/",Host/binary,".json">>),
    trav(jiffy:decode(SettingsJSON)).

trav({L}) -> treemap([{K,trav(V)}||{K,V}<- L]);
trav([L|LL]) -> {[L|LL], from_list([L|LL])};
trav(V) -> V.

start() ->
    spawn(fun()->
        init(),
        Settings = settings(),
		[HostStr] = tokens(cmd("hostname -f"),"\n"),       
        Host = list_to_binary(HostStr), 
        HostSettings = gb_trees:get(<<"monitoring">>, Settings),
        DTaskName = gb_trees:get(<<"dst_tasks">>, HostSettings),
        ZPid = spawn_serve(Settings, DTaskName, Host),
        Send = fun(K,V) -> ZPid ! {add,K,V,clock()} end,
        {TaskNameList,_TaskNameSet} = gb_trees:get(<<"src_tasks">>, HostSettings),
        foreach(fun(TaskName)-> spawn_serve(Settings, TaskName, Send) end, TaskNameList),
        io:format("started\n"),
        receive _ -> ok end
    end).

start([TaskName]) ->
    init(),
    Settings = settings(),
    Send = fun(K,V)-> io:format("~p: ~p\n",[K,V]) end,
    {NState, _TaskSettings, Apply} = prepare_serve(Settings, list_to_binary(TaskName), Send),
    Apply(ask, NState),
    ok.

%% // MODULE - zabbix_sender \\

