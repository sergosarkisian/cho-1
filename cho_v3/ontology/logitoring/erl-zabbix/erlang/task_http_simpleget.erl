
-module(task_http_simpleget).
-export([handler/2]).
-import(mon_util,[http_req/3]).

handler(ask, State) ->
    {_Status, _Settings, TaskSettings, _Send} = State,
    http_req(State, get, { binary_to_list(gb_trees:get(<<"url">>,TaskSettings)), [] }).
