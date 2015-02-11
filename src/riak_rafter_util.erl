-module(riak_rafter_util).

-include("riak_rafter.hrl").

-export([get_ensemble_size/0, ensemble_name/1]).
-export([get_primary_apl/1]).

get_ensemble_size() ->
    riak_rafter:get_env(ensemble_size, ?DEFAULT_ENSEMBLE_SIZE).

ensemble_name(Nodes) when is_list(Nodes) ->
    list_to_atom(lists:flatten(lists:map(fun erlang:atom_to_list/1, Nodes))).

get_primary_apl(DocIdx) ->
    N = get_ensemble_size(),
    {ok, Ring} = riak_core_ring_manager:get_raw_ring(),
    {ok, CHBin} = riak_core_ring_manager:get_chash_bin(),
    riak_core_apl:get_primary_apl_chbin(DocIdx, N, CHBin,
                                        riak_core_ring:all_members(Ring)).
