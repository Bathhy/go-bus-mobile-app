import 'dart:ffi';

import 'package:get/get.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';

class SplashController extends GetxController {
  //Class Construct
  final LocalRepository _localRepository;

  SplashController(this._localRepository);

  // State Properties
  RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    isUserLoggedIn();
    super.onInit();
  }

  RxBool isUserLoggedIn() {
    isLoggedIn.value = _localRepository.isLoggedIn();
    return isLoggedIn;
  }
}
