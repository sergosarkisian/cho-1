
-module(mon_util).
-export([
    read_file_special/2, clock/0,
    disk_settings/3, drbd_settings/3, disk_parse_send/4,
    cpu_settings/3, cpu_parse_send/4,
    neti_settings/3, neti_parse_send/4,
    nocol/0, strcol/1, intcol/1, npercentcol/1,
    treemap/1,
    http_req/3,
    md5hex/1
]).
-import(string,[tokens/2]).
-import(file,[list_dir/1,read_link/1]).
-import(timer,[tc/1]).
-import(lists,[foreach/2,keysort/2,reverse/1]).
-import(gb_trees,[lookup/2,from_orddict/1]).
-import(gb_sets,[is_element/2]).
-import(crypto,[hash/2]).

%% read file content form /proc (where read_file may not work)
read_file_special(Name,Len) ->
    {ok, Fd} = file:open(Name,[read]),
    {ok, Str} = file:pread(Fd,0,Len),
    ok = file:close(Fd),
    Str.

clock() -> {M,N,_} = now(), M*1000000+N.

jump_settings(Settings,TSettings,K) ->
    case lookup(K,TSettings) of
        {value,JName} -> gb_trees:get(JName,Settings); none -> TSettings
    end.

%% disk utils

disk_settings(Settings, TaskSettings, Send)->
    DiskGroupSettings = jump_settings(Settings,TaskSettings,<<"diskset">>),
    {DiskNameList,_Set} = gb_trees:get(<<"disks">>,DiskGroupSettings),
    Disks = [gb_trees:get(DiskName,Settings) || DiskName <- DiskNameList],
    Label2ColSet = treemap([
        {gb_trees:get(<<"disk_label">>,Disk),jump_settings(Settings,Disk,<<"colset">>)}
        || Disk <- Disks
    ]),
    Name2Label = disk_name2label(),
    {Settings, Label2ColSet, Name2Label, Send}.
    
drbd_settings(Settings, TaskSettings, Send)->
    DiskGroupSettings = jump_settings(Settings,TaskSettings,<<"diskset">>),
    {DiskNameList,_Set} = gb_trees:get(<<"disks">>,DiskGroupSettings),
    Disks = [gb_trees:get(DiskName,Settings) || DiskName <- DiskNameList],
    Label2ColSet = treemap([
        {gb_trees:get(<<"disk_label">>,Disk),jump_settings(Settings,Disk,<<"colset">>)}
        || Disk <- Disks
    ]),
    Name2Label = drbd_name2label(),
    {Settings, Label2ColSet, Name2Label, Send}.    
    

disk_parse_send(State, Mod, Content, Head) ->
    {_Settings, Label2ColSet, Name2Label, Send} = State,
    Table = [tokens(Line, " ") || Line <- tokens(Content, "\n")],
    NamedRows = [ {cells2name(Head, Cells), Cells} || Cells <- Table],
    LabRows = [{lookup(N,Name2Label), R} || {{value,N},R} <- NamedRows],
    %Send(<<"raw">>,cells2name(Head, [1,2,3,4,5,6,7,8])),
    CSNRows = [{lookup(L,Label2ColSet), L, R} || {{value,L},R} <- LabRows ],
    CSRows = [{CS, L, R} || {{value,CS}, L, R} <- CSNRows],
    ModB = list_to_binary(Mod),
    foreach(fun({ColSetSettings, Label, Cells})->
        send_for_cells(Send, Head, Cells, ColSetSettings, fun(K) ->
            <<"module.",ModB/binary,"[",K/binary,",",Label/binary,"]">>
        end)
    end, CSRows).

%% cpu utils

cpu_settings(Settings, TaskSettings, Send)->
    CPUGroupSettings = jump_settings(Settings,TaskSettings,<<"cpuset">>),
    {CPUNameList,_Set} = gb_trees:get(<<"cpus">>,CPUGroupSettings),
    CPUS = [gb_trees:get(CPUName,Settings) || CPUName <- CPUNameList],
    Label2ColSet = treemap([
        {gb_trees:get(<<"cpu_label">>,CPU),jump_settings(Settings,CPU,<<"colset">>)}
        || CPU <- CPUS
    ]),
    {Settings, Label2ColSet, Send}.

cpu_parse_send(State, Mod, Content, Head) ->
    {_Settings, Label2ColSet, Send} = State,
    Table = [tokens(Line, " ") || Line <- tokens(Content, "\n")],
    NamedRows = [ {cells2name(Head, Cells), Cells} || Cells <- Table],
    CSNRows = [{lookup(L,Label2ColSet), L, R} || {{value,L},R} <- NamedRows ],
    CSRows = [{CS, L, R} || {{value,CS}, L, R} <- CSNRows],
    ModB = list_to_binary(Mod),
    %Send(<<"raw">>,Table),
    foreach(fun({ColSetSettings, Label, Cells})->
        send_for_cells(Send, Head, Cells, ColSetSettings, fun(K) ->
            <<"module.",ModB/binary,"[",K/binary,",",Label/binary,"]">>
        end)
    end, CSRows).

neti_settings(Settings, TaskSettings, Send)->
    IfaceGroupSettings = jump_settings(Settings,TaskSettings,<<"interfaceset">>),
    {IfaceNameList,_Set} = gb_trees:get(<<"interfaces">>,IfaceGroupSettings),
    Ifaces = [gb_trees:get(IfaceName,Settings) || IfaceName <- IfaceNameList],
    Label2ColSet = treemap([
        {gb_trees:get(<<"interface_label">>,Iface),jump_settings(Settings,Iface,<<"colset">>)}
        || Iface <- Ifaces
    ]),
    {Settings, Label2ColSet, Send}.

neti_parse_send(State, Mod, Content, Head) ->
    {_Settings, Label2ColSet, Send} = State,
    Table = [tokens(Line, " ") || Line <- tokens(Content, "\n")],
    NamedRows = [{cells2name(Head, Cells), Cells} || Cells <- Table],
    CSNRows = [{lookup(L,Label2ColSet), L, R} || {{value,L},R} <- NamedRows ],
    CSRows = [{CS, L, R} || {{value,CS}, L, R} <- CSNRows],
    ModB = list_to_binary(Mod),
    foreach(fun({ColSetSettings, Label, Cells})->
        send_for_cells(Send, Head, Cells, ColSetSettings, fun(K) ->
            A = binary_to_list(Label),
            B = tokens(A, ":"),
            C = list_to_binary(B),
            <<"module.",ModB/binary,"[",K/binary,",",C/binary,"]">>
        end)
    end, CSRows).

send_for_cells(Send, Head, Cells, ColSetSettings, LongK) ->
    {_ColList,ColSet} = gb_trees:get(<<"cols">>,ColSetSettings),
    for_cells(Head,Cells,fun({K,Conv},V) ->
        is_element(K, ColSet) andalso Send(LongK(K), Conv(V))
    end).

cells2name([{<<"name">>,_Conv}|_], [Cell|_]) -> {value, list_to_binary(Cell)};
cells2name([_|Head], [_|Cells]) -> cells2name(Head,Cells);
cells2name([], _) -> none.

disk_name2label() ->
    Dir = "/dev/disk/by-label/", % ls -l
    {ok, Fns} = list_dir(Dir),
    DirListLnk = [{Fn,read_link(Dir++Fn)} || Fn <- Fns],
    DirListTok = [{Fn,tokens(Lnk, "/")} || {Fn,{ok,Lnk}} <- DirListLnk],
    DirListShort = [{list_to_binary(Short),list_to_binary(Fn)} || {Fn,["..","..",Short]} <- DirListTok],
    DirListDev = [ {<<"/dev/",Short/binary>>,Fn} || {Short,Fn} <- DirListShort],
    treemap(DirListShort++DirListDev).
    
    
drbd_name2label() ->
    Dir = "/dev/drbd/by-res/", % ls -l
    {ok, Fns} = list_dir(Dir),
    DirListLnk = [{Fn,read_link(Dir++Fn)} || Fn <- Fns],
    DirListTok = [{Fn,tokens(Lnk, "/")} || {Fn,{ok,Lnk}} <- DirListLnk],
    DirListShort = [{list_to_binary(Short),list_to_binary(Fn)} || {Fn,["..","..",Short]} <- DirListTok],
    DirListDev = [ {<<"/dev/",Short/binary>>,Fn} || {Short,Fn} <- DirListShort],
    treemap(DirListShort++DirListDev).
    
    

%% 2-dim table utils
for_cells([H|HL],[V|VL],F) -> F(H,V), for_cells(HL,VL,F);
for_cells([],[],_) -> ok.

nocol() -> {0,0}.
strcol(K) -> {list_to_binary(K),fun(V) -> list_to_binary(V) end}.
intcol(K) -> {list_to_binary(K),fun(V) -> list_to_integer(V) end}.
npercentcol(K) -> {list_to_binary(K),fun(V) -> 100-list_to_integer(V--"%") end}.

%% some struct utils

treemap(L) -> from_orddict(keysort(1,L)).

%% http

http_res({ok, {{_HttpVer, Code, _Msg}, _Headers, RBody}}) -> {Code, RBody};
http_res(_) -> {0, ""}.

http_req(State, Method, Request) ->
    {_Status, Settings, TaskSettings, Send} = State,
    URL = req2url(Request),
    HTTPOptions = add_options(URL,[]),
    % Send("HO",Request),
    Options = [],
    Do = fun()-> http_res(httpc:request(Method, Request, HTTPOptions, Options)) end,
    {Time, {Code, RBody}} = tc(Do),
    ColSetSettings = jump_settings(Settings,TaskSettings,<<"colset">>),
    {Mask,_} = gb_trees:get(<<"mask">>,ColSetSettings),
    Head  = [rawcol("time"), rawcol("code"), eqconstcol("status",200), hashcol("bodyhash")],
    Cells = [Time/1000          , Code          , Code                    , RBody              ],
    ApplyMaskPart = fun
        (<<"%method">>,_K) -> list_to_binary(atom_to_list(Method));
        (<<"%col">>,K) -> K;
        (<<"%url">>,_K) -> list_to_binary(URL);
        (V,_K) -> V
    end,
    send_for_cells(Send, Head, Cells, ColSetSettings, fun(ShortK) ->
        list_to_binary([ ApplyMaskPart(MaskPart,ShortK) || MaskPart <- Mask])
    end),
    State.

add_options([$h,$t,$t,$p,$s,$:|_],L) -> [{ssl,[{verify,0}]},{timeout, 10000},{autoredirect,true}|L];
add_options([$h,$t,$t,$p,$:|_],L) -> [{timeout, 10000},{autoredirect,true}|L];
add_options(_,L) -> L.

req2url({URL,_,_,_})->URL;
req2url({URL,_})->URL.

hashcol(K) -> {list_to_binary(K),fun(V) -> md5hex(V) end}.
rawcol(K) -> {list_to_binary(K),fun(V) -> V end}.
eqconstcol(K,C) -> {list_to_binary(K),fun (V) when V==C -> 1; (_) -> 0 end}.


%% hex

md5hex(V) -> list_to_binary(hexl(binary_to_list(hash(md5,V)),[])).
hex(N) when N < 10 -> $0+N;
hex(N) when N >= 10, N < 16 -> $a + (N-10).
hexl([N|LL],R) when N < 256 -> hexl(LL,[hex(N rem 16),hex(N div 16)|R]);
hexl([],R) -> reverse(R).
