import 'package:image_picker/image_picker.dart';

class ImagePickerService{ //görsel seçme işlemlerini tek yerde yöneten servis.
  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>> pickMultiple() async {
    return await _picker.pickMultiImage(imageQuality: 70);
  }

  Future<XFile?> pickSingle(ImageSource source) async{
    return await _picker.pickImage(source: source, imageQuality: 70);
  }
}