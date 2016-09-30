
-module(task_http_saxon).
-export([handler/2]).
-import(mon_util,[http_req/3]).

handler(ask, State) ->
    {_Status, _Settings, TaskSettings, _Send} = State,
    XSL = "<xsl:stylesheet version=\"2.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\"></xsl:stylesheet>",
    XML = "<test/>",
    URLPrefix = gb_trees:get(<<"url_prefix">>,TaskSettings),
    URL = binary_to_list(<<URLPrefix/binary,"/tomcone/XSLTransform">>),
    Headers = [{"XSL-Length",integer_to_list(length(XSL))}],
    http_req(State, post, { URL, Headers, "text/xml", XSL ++ XML }).
