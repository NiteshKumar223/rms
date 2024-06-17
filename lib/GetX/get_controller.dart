
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GetController extends GetxController {
  RxList<XFile>? _imageList = <XFile>[].obs;
  // ignore: invalid_use_of_protected_member
  List<XFile>? get imageList => _imageList?.value;

  Future<void> pickImages() async {
    final List<XFile>? pickedImages =
        await ImagePicker().pickMultiImage(imageQuality: 50);
    if (pickedImages != null && pickedImages.isNotEmpty) {
      _imageList?.assignAll(pickedImages);
    }
  }
}
