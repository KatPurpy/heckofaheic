import "package:flutter/material.dart";

import "image_upload_point.dart";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Image Uploader",
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.lightBlue,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Image Uploader"),
        ),
        body: const Center(
          child: ImageUploadPoint(),
        ),
      ),
    );
  }
}
