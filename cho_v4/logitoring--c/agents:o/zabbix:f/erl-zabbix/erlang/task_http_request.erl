
-module(task_http_request).
-export([handler/2]).
-import(mon_util,[http_req/3]).

handler(ask, State) ->
    {_Status, _Settings, TaskSettings, _Send} = State,
    Method = binary_to_atom(gb_trees:get(<<"method">>,TaskSettings),utf8),
    Protocol = gb_trees:get(<<"protocol">>,TaskSettings),
    Server = gb_trees:get(<<"server">>,TaskSettings),
    Path = gb_trees:get(<<"path">>,TaskSettings),
    Hdr_host = gb_trees:get(<<"hdr_host">>,TaskSettings),

    %Content = gb_trees:get(<<"content">>,TaskSettings),
    URL = binary_to_list(<<Protocol/binary,"://",Server/binary, Path/binary>>),
    Headers = [{"Host",binary_to_list(Hdr_host)}],

    http_req(State, Method, { URL, Headers }).
