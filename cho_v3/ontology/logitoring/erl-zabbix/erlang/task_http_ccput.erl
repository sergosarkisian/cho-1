
-module(task_http_ccput).
-export([handler/2]).
-import(mon_util,[http_req/3,md5hex/1]).

handler(ask, State) ->
    {_Status, _Settings, TaskSettings, _Send} = State,
    Content = "monitoring#0",
    <<C0:2/binary,C1:2/binary,C2/binary>> = md5hex(Content),
    URLPrefix = gb_trees:get(<<"url_prefix">>,TaskSettings),
    URL = binary_to_list(<<URLPrefix/binary,"/cc/",C0/binary,"/",C1/binary,"/",C2/binary>>),
    http_req(State, put, { URL, [], "text/plain", Content }).