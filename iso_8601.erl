-module(iso_8601).
-export([iso_week_date/1, iso_week_date/3]).
-import(calendar, [date_to_gregorian_days/3, day_of_the_week/3]).

% ISO 8601
%
% W01 is the week with the year's first Thursday in it.
% Weeks begin with Monday.
%
% Example: 2009-W01-1


%%
%% EXPORTS
%%

%%
%% Calculates the ISO Week Number from the {Year, Month, Day} parameter
%% and returns the string representing it.
%%
%% Useful for example when calling with the date tuple returned by the
%% functions of the calendar module.
%%
%% eg. {2010, 11, 19} -> "2010-W46-5"
%%
-spec iso_week_date({integer(), integer(), integer()}) -> [char()].
iso_week_date({Year, Month, Day}) ->
	iso_week_date(Year, Month, Day).

%%
%% Calculates the ISO Week Number from the Year, Month and Day parameters
%% and returns the string representing it.
%%
%% eg. 2010, 11, 19 -> "2010-W46-5"
%%
-spec iso_week_date(integer(), integer(), integer()) -> [char()].
iso_week_date(Year, Month, Day) ->
	D = date_to_gregorian_days(Year, Month, Day),
	W01_1_Year = gregorian_days_of_w01_1(Year),
	W01_1_NextYear = gregorian_days_of_w01_1(Year + 1),
	{Y, WN} = if W01_1_Year =< D andalso D < W01_1_NextYear ->
			% Current Year Week 01..52(,53)
			{Year, (D - W01_1_Year) div 7 + 1};
		D < W01_1_Year ->
			% Previous Year 52 or 53
			PWN = case day_of_the_week(Year - 1, 1, 1) of
				4 -> 53;
				_ -> case day_of_the_week(Year - 1, 12, 31) of
					4 -> 53;
					_ -> 52
					end
				end,
			{Year - 1, PWN};
		W01_1_NextYear =< D ->
			% Next Year, Week 01
			{Year + 1, 1}
	end,
	DOW = day_of_the_week(Year, Month, Day),
	lists:flatten(io_lib:format("~B-W~2.10.0B-~B", [Y, WN, DOW])).


%%
%% LOCAL FUNCTIONS
%%

%%
%% The Gregorian days of W01-1 for a given Year.
%%
-spec gregorian_days_of_w01_1(integer()) -> integer().
gregorian_days_of_w01_1(Year) ->
	D0101 = date_to_gregorian_days(Year, 1, 1),
	DOW = day_of_the_week(Year, 1, 1),
	if DOW =< 4 ->
		D0101 - DOW + 1;
	true ->
		D0101 + 7 - DOW + 1
	end.
