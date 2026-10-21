## Exercise 3.3

After removing AsyncLoading(), flutter analyze reported:

flutter analyze
$ flutter analyze
Analyzing lab6...                                                       

  error - The type 'AsyncValue<List<Tick>>' isn't exhaustively matched by
         the switch cases since it doesn't match the pattern
         'AsyncLoading<List<Tick>>()'. Try adding a wildcard pattern or
         cases that match 'AsyncLoading<List<Tick>>()' -
         lib\ticker_page.dart:16:13 - non_exhaustive_switch_expression

1 issue found. (ran in 3.4s)


## Exercise 3.4

The empty-list pattern displays "No symbols subscribed" when the stream emits an empty list.

The specific AsyncData patterns must appear before the general AsyncData pattern because the general pattern would match first and make the specific patterns unreachable.