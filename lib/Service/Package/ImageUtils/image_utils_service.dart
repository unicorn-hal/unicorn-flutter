// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as package;
import 'package:flutter_image_compress/flutter_image_compress.dart';

enum ImageSource { gallery, camera }

class ImageUtilsService {
  package.ImagePicker get _imagePicker => package.ImagePicker();

  int get IMAGE_MIN_HEIGHT => 512;
  int get IMAGE_MIN_WIDTH => 512;

  /// 画像を選択する
  /// [imageSource] 画像の選択元
  Future<Uint8List?> getImageBinary(ImageSource imageSource) async {
    final XFile? image = await _imagePicker.pickImage(
        source: imageSource == ImageSource.gallery
            ? package.ImageSource.gallery
            : package.ImageSource.camera);
    if (image == null) {
      return null;
    }
    Uint8List? compressedImage = await _compressImage(image);
    if (compressedImage == null) {
      return null;
    }
    return compressedImage;
  }

  /// 画像を圧縮する
  Future<Uint8List?> _compressImage(XFile image) async {
    final Uint8List? result = await FlutterImageCompress.compressWithFile(
      image.path,
      quality: 85,
      minHeight: IMAGE_MIN_HEIGHT,
      minWidth: IMAGE_MIN_WIDTH,
    );
    return result;
  }

  /// Uint8ListをBase64に変換する
  String uint8ListTob64(Uint8List uint8list) {
    String base64String = base64Encode(uint8list);
    return base64String;
  }

  /// Base64をUint8Listに変換する
  Uint8List b64ToUint8List(String base64String) {
    Uint8List uint8list = base64Decode(base64String);
    return uint8list;
  }

  /// Uint8ListをImageに変換する
  Image uint8ListToImage(Uint8List uint8list) {
    Image image = Image.memory(uint8list);
    return image;
  }

  /// Base64をImageに変換する
  Image b64ToImage(String base64String) {
    Uint8List uint8list = b64ToUint8List(base64String);
    Image image = uint8ListToImage(uint8list);
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
}
