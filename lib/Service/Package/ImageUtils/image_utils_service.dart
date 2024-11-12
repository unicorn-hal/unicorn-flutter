// ignore_for_file: non_constant_identifier_names
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as package;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImageUtilsService {
  package.ImagePicker get _imagePicker => package.ImagePicker();

  final int _IMAGE_MIN = 512;

  /// 画像を選択する
  /// [imageSource] 画像の選択元 (gallery or camera)
  Future<File> getImageFile(ImageSource imageSource) async {
    final XFile? image = await _imagePicker.pickImage(
        source: imageSource == ImageSource.gallery
            ? package.ImageSource.gallery
            : package.ImageSource.camera);
    if (image == null) {
      throw Exception('No image selected');
    }
    File convertedImage = await _compressAndConvertToPng(image);
    return convertedImage;
  }

  /// 画像を圧縮する
  Future<File> _compressImage(XFile image) async {
    File file = File(image.path);
    XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
      file.path,
      file.path.replaceAll(RegExp(r'\.\w+$'), '_compressed.jpg'),
      minHeight: _IMAGE_MIN,
      minWidth: _IMAGE_MIN,
      quality: 80,
    );
    if (compressedImage == null) {
      throw Exception('Failed to compress image');
    }
    return File(compressedImage.path);
  }

  /// pngに変換する
  Future<File> _convertToPng(File image) async {
    img.Image imageFile = img.decodeImage(image.readAsBytesSync())!;
    File pngImage = File(image.path.replaceAll(RegExp(r'\.\w+$'), '.png'));
    await pngImage.writeAsBytes(img.encodePng(imageFile));
    return pngImage;
  }

  /// XFileを圧縮してpngに変換する
  Future<File> _compressAndConvertToPng(XFile image) async {
    File compressedImage = await _compressImage(image);
    File pngImage = await _convertToPng(compressedImage);
    return pngImage;
  }

  /// Uint8ListをImageに変換する
  Image uint8ListToImage(Uint8List uint8list) {
    Image image = Image.memory(uint8list);
    return image;
  }

  /// Uint8ListをFileに変換する
  File uint8listToFile(Uint8List uint8list) {
    File file = File.fromRawPath(uint8list);
    return file;
  }

  /// FileをUint8Listに変換する
  Future<Uint8List> fileToUint8List(File file) async {
    Uint8List uint8list = await file.readAsBytes();
    return uint8list;
  }

  /// FileをImageに変換する
  Future<Image> fileToImage(File file) async {
    Uint8List uint8list = await fileToUint8List(file);
    Image image = uint8ListToImage(uint8list);
    return image;
  }
}
