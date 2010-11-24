-module(iso_8601_tests).
-import(iso_8601, [iso_week_date/3]).
-include_lib("eunit/include/eunit.hrl").

iso_8601_test_() ->
	[?_assert(iso_week_date(2005, 1, 1) =:= "2004-W53-6"),
	 ?_assert(iso_week_date(2007, 1, 1) =:= "2007-W01-1"),
	 ?_assert(iso_week_date(2008,12,29) =:= "2009-W01-1")].
