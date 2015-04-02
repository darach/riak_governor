%%%-------------------------------------------------------------------
%%% @doc This module defins a service provider behaviour enabling alternative
%%% distributed consensus algorithm implementations to be provided to riak_governor
%%% @end
%%%-------------------------------------------------------------------
-module(riak_governor_spi).

-export([get_leader/1]).
-export([start_ensemble/2]).
-export([stop_ensemble/1]).

-callback get_leader(term()) -> {term(), node()} | undefined.
-callback start_ensemble(term(),list()) -> ok | already_started.
-callback stop_ensemble(term()) -> ok.

get_leader(Id) ->
    Provider = riak_governor_util:get_ensemble_provider(),
    get_leader(Provider,Id).

start_ensemble(Name,Peers) ->
    Provider = riak_governor_util:get_ensemble_provider(),
    start_ensemble(Provider,Name,Peers).

stop_ensemble(Name) ->
    Provider = riak_governor_util:get_ensemble_provider(),
    stop_ensemble(Provider,Name).

%%%===================================================================
%%% Internal
%%%===================================================================
get_leader(rafter,Id) ->
    riak_governor_spi_rafter:get_leader(Id);
get_leader(riak_ensemble,Id) ->
    riak_governor_spi_riak_ensemble:get_leader(Id);
get_leader(_Otherwise,_Id) ->
    throw(bad_ensemble_provider).

start_ensemble(rafter,Name,Peers) ->
    riak_governor_spi_rafter:start_ensemble(Name,Peers);
start_ensemble(riak_ensemble,Name,Peers) ->
    riak_governor_spi_riak_ensemble:start_ensemble(Name,Peers);
start_ensemble(_Otherwise,_Name,_Peers) ->
    throw(bad_ensemble_provider).

stop_ensemble(rafter,Name) ->
    riak_governor_spi_rafter:stop_ensemble(Name);
stop_ensemble(riak_ensemble,Name) ->
    riak_governor_spi_riak_ensemble:stop_ensemble(Name);
stop_ensemble(_Otherwise,_Name) ->
    throw(bad_ensemble_provider).
