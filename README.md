# heckofaheic
[![pub package](https://img.shields.io/pub/v/heckofaheic)](https://pub.dev/packages/heckofaheic)

Converts HEIC into PNG/JPEG/GIF using [heic2any](https://github.com/alexcorvi/heic2any).

Useful in case your users are uploading HEIC images to your Flutter web app
that need to be displayed correctly, as HEIC is not supported by most browsers.

***Web only***

## Getting started
1. Please download a copy of `heic2any.min.js` on [alexcorvi.github.io/heic2any](https://alexcorvi.github.io/heic2any/)
2. Save it in your Flutter project's `web` folder, next to `index.html`
3. Link the script in your `index.html`, like so:
	```html
	<script src="heic2any.min.js" type="application/javascript"></script>
	```
4. Add a new script tag to your `index.html`, with the following content:
	```html
	<script>
	function executeHeic2any(blob, multiple, toType, quality, gifInterval) {
		return heic2any({
			blob,
			multiple: multiple,
			toType: toType,
			quality: quality,
			gifInterval: gifInterval
		});
	}
	</script>
	```

## Usage
```dart
import "package:heckofaheic/heckofaheic.dart";

Future<void> myFunction() async {
  Uint8List imageBytes = await getYourImageBytesSomehow();

  if (HeckOfAHeic.isHEIC(imageBytes)) {
    imageBytes = await HeckOfAHeic.convert(imageBytes);
  }
}
```

For the full API documentation, please refer to the [API reference](https://pub.dev/documentation/heckofaheic/latest/heckofaheic/heckofaheic-library.html).

## Additional information
have fun.
