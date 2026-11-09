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