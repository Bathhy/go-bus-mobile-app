import 'package:get/get.dart';

abstract class BaseController<T> extends GetxController {
  final Rx<T> _state;

  BaseController(T initialState) : _state = initialState.obs;

  T get state => _state.value;

  Rx<T> get obs => _state;

  void emit(T newState) {
    _state.value = newState;
  }

  void updateState(T Function(T state) reducer) {
    emit(reducer(_state.value));
    update(); // Add this to notify GetBuilder widgets
  }
}

abstract class BaseUiState {
  final bool isLoading;

  const BaseUiState({this.isLoading = false});
}
