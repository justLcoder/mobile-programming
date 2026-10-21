# Lab 6 — Notes

## Part 2

**1. Why do we have a separate provider for TickFeed?**

So that we can change the feed without changing the tickerProvider itself. It also makes testing easier since we can replace the feed with another one.

**2. What does autoDispose do?**

When we leave the page and nothing is listening to the provider anymore, Riverpod disposes of it. So the stream doesn't keep running for no reason.

**3. What happens during the first 800 ms?**

The provider is in AsyncLoading because the stream hasn't returned anything yet. hasValue is false.

When the first prices arrive, it changes to AsyncData.

## Part 3

**Exercise 3.3**

When I commented out AsyncLoading from the switch, flutter analyze reported an error because the switch wasn't handling every possible state.

Exact analyzer message:

flutter analyze
$ flutter analyze
Analyzing lab6...                                                       

  error - The type 'AsyncValue<List<Tick>>' isn't exhaustively matched by
         the switch cases since it doesn't match the pattern
         'AsyncLoading<List<Tick>>()'. Try adding a wildcard pattern or
         cases that match 'AsyncLoading<List<Tick>>()' -
         lib\ticker_page.dart:16:13 - non_exhaustive_switch_expression

1 issue found. (ran in 3.4s)

**Exercise 3.4**

I changed the feed to use an empty symbols list, and the app showed "No symbols subscribed" instead of the currencies.

The empty and single-item patterns should come first because the general AsyncData pattern would otherwise match them before they get a chance.

I also tested failAfter: 5. After showing prices for a few seconds, the feed disconnected and the app showed an error.

## Part 4

**Exercise 4.3**

The difference is that ref.refresh runs the provider again immediately, while ref.invalidate marks it to be updated.

Also, ref.refresh(tickerProvider.future) returns a Future, which we can use with await. That's why it works with RefreshIndicator.

The previous prices can stay on the screen during refreshing because Riverpod keeps the old data while loading the new data.

**Exercise 4.4**

On the first load, there's no data yet, so the app shows a full-screen loading spinner. But when we refresh or reconnect after getting prices, the old prices can stay visible.

isRefreshing happens when we manually refresh or invalidate a provider. isReloading happens when one of the provider's dependencies changes.

I tested the error and retry buttons. The app showed the error banner with the previous prices, and pressing Retry made it work again.

## Final Questions

**1. What are the three AsyncValue subtypes?**

AsyncLoading, AsyncData, and AsyncError.

If we forget one of them in a switch, Dart can report that the switch isn't exhaustive.

**2. When does AsyncError have a previous value?**

When the provider successfully loaded data before the error happened. Riverpod can keep that previous data even though the latest operation failed.

If the provider fails before receiving any data, the value is null.

**3. What's the difference between refresh, refresh.future, and invalidate?**

- ref.refresh(provider) refreshes the provider immediately and returns its current state.
- ref.refresh(provider.future) refreshes it and gives us a Future to wait for the result.
- ref.invalidate(provider) tells Riverpod that the provider needs to be recomputed, but doesn't return anything.

**4. Why should the loading-with-old-data pattern come before AsyncData?**

Because switch patterns are checked from top to bottom. We want to check whether we're loading with previous data before checking the normal data case.

**5. Why use switch instead of .when()?**

Switch gives us more control because we can check not only the state but also what's inside the data, like an empty list or a list with one item.

.when() is still useful when we only need to handle loading, data, and error without extra conditions.