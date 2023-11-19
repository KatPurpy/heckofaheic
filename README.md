Converts HEIC into PNG using heic2any

## Features

- primitive
- web only

## Getting started

- Please get a copy of heic2any.min.js on [https://alexcorvi.github.io/heic2any/](https://alexcorvi.github.io/heic2any/)
- Add the script to your index.html
```html
<script src="heic2any.min.js" type="application/javascript"> </script>
```

## Usage

```dart
import "package:heckofaheic/heckofaheic.dart" as hoh;

// somewhere in the code you should check for if the file is HEIC and 
async (){
  Uint8List? imageBytes = await getYourImageBytesSomehow();
  if(hoh.isHEIC(imageBytes))
  {
    imageBytes = await hoh.convertFromHEIC(imageBytes);
  }
}
```

## Additional information
have fun.