import 'package:e_commerce/controller/firebase_controller.dart';
import 'package:e_commerce/controller/listController.dart';
import 'package:get/get.dart';

class InstanceBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<FirebaseController>(() => FirebaseController());
    Get.lazyPut<ListController>(() => ListController());
  }
}
