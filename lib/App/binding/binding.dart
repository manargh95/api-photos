import 'package:get/get.dart';
import 'package:photos/Module/Screens/HomeScreenController.dart';


class Binding implements Bindings{

  @override
  void dependencies() {
    Get.put(HomeScreenController());

  }}