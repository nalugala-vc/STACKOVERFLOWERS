import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:kenic/features/domain_core/controllers/domain_controller.dart';
import 'package:kenic/features/domain_core/controllers/cart_controller.dart';
import 'package:kenic/features/domain_core/controllers/domain_search_controller.dart';
import 'package:kenic/features/domain_core/domain_core.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';
import 'package:kenic/features/profile/controllers/personal_information_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(OnboardingController());
    Get.put(DomainController());
    Get.put(CartController());
    Get.put(DomainSearchController());
    Get.lazyPut(() => PersonalInformationController());
  }
}
