List of classes:
1. Phone
2. Mouse
3. Keyboard
4. CardHolder
5. Pen
6. Calculator
7. Nothing

## Design credit (T14)

- **Name:** Bloom PlantCare App (Smart Gardening App UI Kit)
- **Author:** DS Jayawardhana & Amasha Terani (ds-jayawardhana)
- **Link:** https://www.figma.com/community/file/1534445735365222713/bloom-plantcare-app
- **Licence:** CC BY 4.0
- Reference frames: `docs/design-1.png`, `docs/design-2.png`. The credit is also shown in the app on the Model screen.

## Classifier sharing (T11)

The classifier is loaded once in `main.dart` (`TmClassifierApp`) and wrapped in an `AppState` object that is passed to every screen through its constructor (constructor injection). No screen calls `Classifier.load()`. `close()` runs when the app is detached or the root widget is disposed.