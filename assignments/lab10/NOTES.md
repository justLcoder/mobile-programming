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

## Part 1 — Questions

**What does the model answer for an object that belongs to none of the classes? How does the background class change that?**
The model always outputs a softmax over the 7 known classes, so the percentages always add up to 100 %. It has no "I don't know" answer: an unknown object is pushed into whichever class it looks most like, sometimes with high confidence. The "Nothing" class (empty wall / desk) gives the model a place for scenes without any of our objects, so an empty or unclear picture usually lands on "Nothing" instead of a random object. It does not solve every case: a shoe can still be called "Mouse".

**Floating point vs Quantized export: size, input type, Dart code?**
- Size: float stores 32-bit float weights; quantized stores 8-bit integers, so it is about 4× smaller and usually faster, with slightly lower accuracy.
- Input type: float takes `float32` values normalised to [-1, 1]; quantized takes `uint8` values 0–255.
- Dart code: for float we compute `value / 127.5 - 1` per channel and read a `List<double>` of probabilities. For quantized we pass the raw 0–255 integers with no normalisation, read `uint8` outputs and divide each by 255.

## Part 2 — Questions

**`assets/model/` vs `assets/`?**
`assets/model/` bundles the files directly inside that folder (`model_unquant.tflite`, `labels.txt`, `sample.jpg`). `assets/` bundles only files directly inside `assets/` itself: Flutter does not recurse into subfolders, so nothing in `assets/model/` would be bundled and `Interpreter.fromAsset('assets/model/...')` would fail.

**Why can `image` and `http` run in a plain Dart unit test, but `tflite_flutter` and `image_picker` cannot?**
`image` and `http` are pure Dart and run on the Dart VM anywhere. `tflite_flutter` calls the native TensorFlow Lite C library through FFI, and `image_picker` uses platform channels to the Android/iOS camera and gallery. Neither the native library nor the platform side exists in `flutter test`.

## Part 3 — Questions

**Change the normalisation to `value / 255`. What happens to the percentages, and why does nothing crash?**
The inputs then lie in [0, 1] instead of [-1, 1]: every pixel is shifted, so a black pixel looks mid-grey to the model. The predictions drift and become unreliable (often still confident, but on the wrong label). Nothing crashes because the tensor still has the right shape `[1, 224, 224, 3]` and type `float32`. TensorFlow Lite checks only shape and type, not the value range, and the softmax output still adds up to 1.

**Where in the app is the number of classes written down? What would change after retraining with another class?**
Nowhere in the code. It comes from the number of lines in `labels.txt` (`labels.length`), which sizes the output tensor and the Result rows. After retraining we only replace `assets/model/model_unquant.tflite` and `assets/model/labels.txt` together; no Dart code changes.

## Part 4 — Questions

**Two things from the Figma design that were changed or left out, and why.**
1. The design uses the Poppins font; the app uses the default Roboto so that it needs no extra font package or font download and works fully offline. The sizes and weights follow the design.
2. The plant-specific screens (login/sign-up, IoT sensors, weather, garden planner) were left out because this app needs no account or sensors. Their card layout, green hero, rounded white cards and mint chips were reused for Welcome, Home, Result, History and Model.

**The Model screen shows the labels. From the classifier or from the file again?**
From the classifier (`state.classifier.labels`). This is exactly the list the model output is paired with, read once at start-up. Reading `labels.txt` again would duplicate work and could show something different from what the classifier actually uses.

## Part 5 — Questions

**The same object scored differently from the camera and from a downloaded picture. Two reasons from the training data.**
1. All training samples came from one laptop webcam in one room: the same white wall, lighting, angle and hand holding the object. Downloaded pictures have other backgrounds, lighting and framing, so the model partly learned "white wall + hand" rather than the object itself.
2. Each class was trained on one specific object (our pen, our mouse, our calculator). A downloaded picture shows a different model, colour or shape of that kind of object, which the model never saw.

**`classify` runs on the UI thread. How long does it take, and what does the user see?**
Measured with `Stopwatch` in `AppState.classifyAndRecord` (logged as `RESULT ... ms`): 3041 ms and 4288 ms on the Pixel 8 emulator (software-emulated CPU, so a real phone is faster). During that time the app shows a "Classifying…" dialog, but because the UI thread is busy its spinner freezes and the screen does not react to taps until the result opens.

## Checkpoint questions

**1. Trace one photo from the shutter button to the percentage on screen.**
1. The system camera takes the photo; `image_picker` returns it as an `XFile`, already shrunk to max 1024 px wide (`lib/services/image_sources.dart`, `fromCamera`).
2. `readAsBytes()` turns it into `Uint8List` JPEG bytes (same file).
3. `classifyFrom` passes the bytes on: the one path shared by all sources (`lib/widgets/classify_flow.dart`).
4. `AppState.classifyAndRecord` times the call (`lib/services/app_state.dart`).
5. `Classifier.classify` (`lib/services/classifier.dart`): `img.decodeImage` → pixel image; `bakeOrientation` → EXIF rotation applied; `copyResizeCropSquare` → centre-cropped 224 × 224; each channel `value / 127.5 - 1` → float tensor `[1, 224, 224, 3]`; `interpreter.run` → output `[1, 7]` softmax probabilities; each index is paired with its line of `labels.txt`, then sorted → `List<Prediction>`.
6. A `HistoryEntry` stores the bytes, predictions, source and time (`lib/models/history_entry.dart`).
7. `ResultScreen` shows the image, and `PredictionRow` prints `(confidence * 100).toStringAsFixed(1)` + ` %` (`lib/screens/result_screen.dart`, `lib/widgets/prediction_row.dart`).

**2. Which three lines of `pubspec.yaml` would break the app if deleted, and what would the error be?**
1. `- assets/model/`: the model is not bundled. `Interpreter.fromAsset` fails with "Unable to load asset", and the start-up screen shows "Model file not found… Expected at: assets/model/model_unquant.tflite".
2. `tflite_flutter: ^0.12.1`: compile error `Target of URI doesn't exist: 'package:tflite_flutter/tflite_flutter.dart'`, and `Interpreter` is undefined.
3. `image_picker: ^1.2.4`: compile error `Target of URI doesn't exist: 'package:image_picker/image_picker.dart'`, and `ImagePicker` is undefined. (Deleting `image:` or `http:` fails the same way.)

**3. Why must the pre-processing in Flutter match what Teachable Machine did during training? Name the two things that must match.**
The model only learned what its training tensors looked like; any difference in the input is a distribution shift that it silently gets wrong. The two things that must match are:
1. Geometry: a 224 × 224 RGB image, centre-cropped to a square and correctly rotated.
2. Pixel scaling: each channel mapped from 0–255 to [-1, 1] (`value / 127.5 - 1`).

**4. The model is 97 % sure that a shoe is a mug. Is that a bug? What does the percentage mean?**
It is not a bug in the code; it is how a closed-set classifier behaves. The softmax spreads 100 % over the known classes only, so 97 % means "of our 7 classes, this picture looks most like Mug". It does not mean "97 % chance this is a mug", and it is not a measure of correctness or of the picture being in-distribution. The model has no "none of these" answer except the "Nothing" class it was trained on.

**5. What stays on the device and what leaves it? Compare with a cloud vision API.**
On the device: the model, the labels, every camera and gallery photo, the inference itself and the history (memory only). The only network traffic is the download source, which fetches a picture from the address the user typed. Nothing is ever uploaded. A cloud vision API would upload every photo to a server: it needs a connection, adds latency and possibly cost, and sends personal images to a third party. In return it gets much larger models that know thousands of classes instead of our 7.

## Classifier sharing (T11)

The classifier is loaded once in `main.dart` (`TmClassifierApp`) and wrapped in an `AppState` object that is passed to every screen through its constructor (constructor injection). No screen calls `Classifier.load()`. `close()` runs when the app is detached or the root widget is disposed.