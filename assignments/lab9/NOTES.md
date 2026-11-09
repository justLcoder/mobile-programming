Part 1:

Q1: Why is CartLine immutable with a copyWith instead of a mutable qty field? Which of the four styles would still "work" with mutation,
and why is that a trap?
Answer: Becuase Riverpod, Cubit, and Bloc only notify listeners the the new state is not equal to (==) the old state. So, if you change qty, the state is still the same object, so no rebuild will happen. But with setState, it would rebuild whenever you call it. The trap is that - you write code that works for setState, but it will break for the other 3. 

Q1: Why does CartBody take callbacks rather than importing a provider or a bloc directly?
Answer: Because its a dumb widget. that means you can reuse it without changes. It doesn't depend on any state-management library and you can test it on its own.

Part 2:

Q1: After T4, how would a second page (say an order history) read the cart? What would you have to change?
Answer: It can't — the state is private to this page's State. We'd have to lift it up above the Navigator
(e.g. into the App widget) and pass it down plus callbacks through constructors, or build an
InheritedWidget.

Q2: After T5, where does _history live, and what happens to it on hot restart versus hot reload?
Answer: In the _SetStateCartPageState object, next to _state. Hot reload keeps State objects, so history
survives. Hot restart re-runs main() and rebuilds the tree, so history (and the cart) are lost, and simply popping the page does the same.

Part 3:

Q1: Name the three places you used ref.read and the two places you used ref.watch , and justify each.
Answer: 
- `ref.read(cartProvider.notifier)` in the page build — only need method handles, no rebuilds.
- `ref.read(checkoutApiProvider)` inside `checkout()` — one-off lookup inside a method.
- `ref.read(cartProvider)` inside the `ref.listen` callback — read the current value inside a callback.
- `ref.watch(cartProvider)` in the page — display lines/status, must rebuild on change.
- `ref.watch(cartProvider.select(...))` in RiverpodSummaryCard — display only the totals.
  (Also `ref.watch(cartProvider)` inside canUndoProvider, so it recomputes on every change.)

Q2: Why does the summary card in T3 rebuild less often than the setState version?
Answer: In setState, any `setState` rebuilds the whole page, including the card (coupon error, submitting
status...). In Riverpod the card is a separate const ConsumerWidget that watches only a `select`
of the numbers; it rebuilds only when those numbers actually change.

Part 4:

Q1: What would break if you put BlocProvider inside CartBody ?
Answer: CartBody would create its own cubit: the AppBar undo, summary card and checkout button (outside
CartBody) couldn't find it with context.read/BlocBuilder, and the cart
would be recreated/closed whenever CartBody is removed. It also stops being a dumb widget.

Q2: Give the Riverpod equivalent of each of: BlocProvider , BlocBuilder , BlocListener , context.read , buildWhen .
Answer: 
- BlocProvider → declaring the provider + ProviderScope (scoped/disposed like `autoDispose`)
- BlocBuilder → `ref.watch` (ConsumerWidget)
- BlocListener → `ref.listen`
- context.read → `ref.read`
- buildWhen → `ref.watch(provider.select(...))`

Part 5:

Q1: When is the event layer worth its boilerplate? Give one feature in this cart where Bloc is clearly better than Cubit and one where it is
pure overhead.
Answer: Better than Cubit: checkout — droppable() de-duplicates taps declaratively, and the observer log
records which event caused each state. Pure overhead: add/remove/qty — one event class + handler per
method just to call the same pure helper a Cubit method calls directly.

Q2: Which of the four styles let you implement T4's "drop duplicate taps" declaratively, and how would you do it in the others?
Answer: Only Bloc (`transformer: droppable()`). In the others it's imperative: setState/Cubit/Riverpod check
`if (status == submitting) return;` at the start of checkout (or disable the button while submitting).