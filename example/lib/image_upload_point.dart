import "dart:typed_data";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:heckofaheic/heckofaheic.dart";
import "package:flutter_dropzone/flutter_dropzone.dart";

const double imageSize = 300;

class ImageUploadPoint extends StatelessWidget {
  const ImageUploadPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const _UploadedImage(),
    );
  }
}

class _UploadedImage extends StatefulWidget {
  const _UploadedImage();

  @override
  State<_UploadedImage> createState() => _UploadedImageState();
}

class _UploadedImageState extends State<_UploadedImage> {
  late DropzoneViewController dropzoneViewController;
  Uint8List? image;

  void setImageFromBytes(Uint8List imageBytes) async {
    if (HeckOfAHeic.isHEIC(imageBytes)) {
      debugPrint(
          "Converting HEIC... ${String.fromCharCodes(imageBytes, 0, 16)}");
      imageBytes = await HeckOfAHeic.convert(imageBytes);
      debugPrint("Converted HEIC! ${String.fromCharCodes(imageBytes, 0, 16)}");
    }

    setState(() {
      image = imageBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (image == null)
          const _UploadButton()
        else
          Image.memory(
            image!,
            fit: BoxFit.cover,
            width: imageSize,
            height: imageSize,
          ),
        Positioned.fill(
            child: DropzoneView(
                onCreated: (ctl) => dropzoneViewController = ctl,
                onDrop: (file) async {
                  setImageFromBytes(
                      await dropzoneViewController.getFileData(file));
                })),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onLongPress: () {
                // Remove image
                setState(() {
                  image = null;
                });
              },
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? pickedImage = await picker.pickImage(
                  source: ImageSource.gallery,
                  requestFullMetadata: false,
                );
                if (pickedImage == null) return; // User cancelled the popup

                Uint8List imageBytes = await pickedImage.readAsBytes();
                setImageFromBytes(imageBytes);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      width: imageSize,
      height: imageSize,
      child: const Center(
        child: Icon(
          Icons.upload,
          color: Colors.white,
          size: 128,
        ),
      ),
    );
  }
}
