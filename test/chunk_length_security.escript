#!/usr/bin/env escript
%%! -pa ebin
main(_) ->
    {done, <<"a">>, no_trailers, <<>>} =
        cow_http_te:stream_chunked(<<"1\r\na\r\n0\r\n\r\n">>, {0, 0}),
    {more, <<>>, 18446744073709551617, _} =
        cow_http_te:stream_chunked(<<"FFFFFFFFFFFFFFFF\r\n">>, {0, 0}),
    {done, <<"a">>, no_trailers, <<>>} =
        cow_http_te:stream_chunked(<<"0000000000000001;x=y\r\na\r\n0\r\n\r\n">>, {0, 0}),
    lists:foreach(fun(Header) ->
        case catch cow_http_te:stream_chunked(Header, {0, 0}) of
            {'EXIT', _} -> ok;
            Other -> error({accepted_overlong_chunk_length, Header, Other})
        end
    end, [<<"10000000000000000\r\n">>, <<"00000000000000000\r\n">>,
          <<"fffffffffffffffff">>, <<"FFFFFFFFFFFFFFFFF;x=y\r\n">>]),
    io:format("PASS chunk length limits, leading zeros, extensions and valid bodies~n").
