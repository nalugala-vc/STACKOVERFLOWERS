import 'package:get/get.dart';

class BaseController extends GetxController {
  var isLoading = RxBool(false);

  setBusy(bool value) {
    isLoading.value = value;
  }
}
