@JS()
library heckofaheic;

import "dart:typed_data";
//TODO: Make this a proper web-only implementation, so this warning goes away,
// and using this library won't cause issues when trying to build for other platforms:
import "dart:html";

import "package:js/js.dart";
import "package:js/js_util.dart";
import "package:http/http.dart";

enum TargetType implements Comparable<TargetType> {
  png(mimeType: "image/png"),
  jpeg(mimeType: "image/jpeg"),
  gif(mimeType: "image/gif");

  final String mimeType;

  const TargetType({required this.mimeType});

  @override
  int compareTo(TargetType other) => mimeType.compareTo(other.mimeType);
}

//TODO: Write documentation
class HeckOfAHeic {
  static bool isHEIC(Uint8List bytes) {
    //TODO: Improve this check, see:
    // https://github.com/strukturag/libheif/commit/a898727c717dce9b171404041eeb2e93635157e8
    return String.fromCharCodes(bytes, 0, 16).contains("ftyp");
  }

  static Future<Uint8List> convert(
    Uint8List imageBytes, {
    TargetType toType = TargetType.png,
    double? jpegQuality,
    double? gifInterval,
  }) async {
    assert(jpegQuality == null || (jpegQuality >= 0 && jpegQuality <= 1)); // if set, must be between 0 and 1

    Blob heicBlob = Blob([imageBytes]);
    Blob convBlob = await _useHeic2anySingle(heicBlob, toType, jpegQuality, gifInterval);
    Uint8List resultBytes = await bytesFromBlob(convBlob);
    return resultBytes;
  }

  static Future<Blob> _useHeic2anySingle(
    Blob blob,
    TargetType? toType,
    double? jpegQuality,
    double? gifInterval,
  ) async {
    var promise = _executeHeic2any(blob, false, toType?.mimeType, jpegQuality, gifInterval);
    var qs = await promiseToFuture(promise);
    return qs;
  }

  static Future<List<Uint8List>> convertIntoMultipleFrames(
    Uint8List imageBytes, {
    TargetType toType = TargetType.png,
    double? jpegQuality,
    double? gifInterval,
  }) async {
    assert(jpegQuality == null || (jpegQuality >= 0 && jpegQuality <= 1));

    Blob heicBlob = Blob([imageBytes]);
    List<dynamic> convBlobs = await _useHeic2anyMultiple(heicBlob, toType, jpegQuality, gifInterval);

    //TODO: Replace this loop with a map() function:
    List<Uint8List> resultsBytes = [];
    for (Blob convBlob in convBlobs) {
      resultsBytes.add(await bytesFromBlob(convBlob));
    }

    return resultsBytes;
  }

  static Future<dynamic> _useHeic2anyMultiple(
    Blob blob,
    TargetType? toType,
    double? jpegQuality,
    double? gifInterval,
  ) async {
    var promise = _executeHeic2any(blob, true, toType?.mimeType, jpegQuality, gifInterval);
    var qs = await promiseToFuture(promise);
    return qs;
  }

  static Future<Uint8List> bytesFromBlob(Blob pngBlob) async {
    var objectUrl = Url.createObjectUrlFromBlob(pngBlob);
    var resultBytes = await readBytes(Uri.parse(objectUrl));
    Url.revokeObjectUrl(objectUrl);
    return resultBytes;
  }
}

@JS("executeHeic2any")
external dynamic _executeHeic2any(
  Blob blob,
  bool? multiple,
  String? toType,
  double? quality,
  double? gifInterval,
);
