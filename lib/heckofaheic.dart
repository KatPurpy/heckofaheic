library heckofaheic;

import "dart:typed_data";
import "dart:async";
import 'package:js/js.dart';
import "dart:html" as html;
import "dart:js_util" as js_util;
import 'package:http/http.dart' as http;

@JS("heic2any")
external dynamic heic2any(dynamic args);

bool isHEIC(Uint8List imageBytes) {
  String header = String.fromCharCodes(imageBytes.sublist(0, 16));
  return header.contains("ftypheic");
}

Future<Uint8List> convertFromHEIC(Uint8List list) async
{
  print('WHAT IS GOING ON');
  print("CReaTED ARRAY ${([list])}");
  var htmlBlob = html.Blob([list], "application/octet-stream");
  print("CREATED BLOB $htmlBlob");
  var blob = (blob: htmlBlob);
  print("CReATED BLOB OBJECT $blob");
  var pngblob = await js_util.promiseToFuture(heic2any(blob));
  print(pngblob);
  var objectUrl = html.Url.createObjectUrlFromBlob(pngblob);
  print(objectUrl);
  var resultBytes = await http.readBytes(Uri.parse(objectUrl));
  print(resultBytes);
  html.Url.revokeObjectUrl(objectUrl);
  return resultBytes;
}