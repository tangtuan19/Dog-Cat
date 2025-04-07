import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
class Classifier {
  Interpreter? _interpreter;
  late List<String> _labels;
  bool _isModelLoaded = false;
  Classifier() {
    init();
  }
  Future<void> init() async {
    await _loadModel();
    _isModelLoaded = true;
  }
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset("assets/tflite_model.tflite");
      final labelData = await rootBundle.loadString("assets/labels.txt");
      _labels = labelData.split("\n").where((element) => element.isNotEmpty).toList();
      print("✅ Model và nhãn đã tải xong!");
    } catch (e) {
      print("❌ Lỗi khi tải mô hình hoặc nhãn: $e");
    }
  }
  Future<String> classifyImage(File image) async {
    if (!_isModelLoaded || _interpreter == null) {
      return "❌ Model chưa sẵn sàng!";
    }
    var input = await _preprocessImage(image);
    var output = List.generate(1, (index) => List.filled(_labels.length, 0.0));
    _interpreter!.run(input, output);
    int predictedIndex = output[0].indexWhere((value) => value == output[0].reduce((a, b) => a > b ? a : b));
    if (predictedIndex < 0 || predictedIndex >= _labels.length) {
      return "❌ Không nhận diện được đối tượng!";
    }
    return _labels[predictedIndex];
  }
  Future<List<List<List<List<double>>>>> _preprocessImage(File file) async {
    var image = img.decodeImage(await file.readAsBytes());
    if (image == null) {
      throw Exception("❌ Không thể đọc ảnh");
    }
    var fixedImage = img.bakeOrientation(image);
    var resizedImage = img.copyResize(fixedImage, width: 224, height: 224);
    List<List<List<List<double>>>> input = List.generate(
      1,
          (i) => List.generate(
        224,
            (j) => List.generate(
          224,
              (k) {
            var pixel = resizedImage.getPixel(j, k);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0
            ];
          },
        ),
      ),
    );
    return input;
  }
}
