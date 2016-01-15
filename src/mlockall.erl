%% @author Couchbase <info@couchbase.com>
%% @copyright 2012 Couchbase, Inc.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%      http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(mlockall).

-export([lock/1, unlock/0]).

-ifdef(HAVE_MLOCKALL).

-on_load(init/0).

init() ->
  Path = case application:get_env(code,sopath) of
           {ok, CodePath} ->
             CodePath;
           _ ->
             case code:priv_dir(?MODULE) of
               {error, _} ->
                 EbinDir = filename:dirname(code:which(?MODULE)),
                 AppPath = filename:dirname(EbinDir),
                 filename:join(AppPath, "priv");
               CodePath ->
                 CodePath
             end
         end,
  erlang:load_nif(filename:join(Path, ?MODULE), 0).

lock(_Flags) ->
    erlang:nif_error(mlockall_nif_not_loaded).

unlock() ->
    erlang:nif_error(mlockall_nif_not_loaded).

-else.                                          % -ifndef(WIN32)

lock(_Flags) ->
    {error, enotsup}.

unlock() ->
    {error, enotsup}.

-endif.
