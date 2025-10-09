abstract class Copyable<T> {
  T copyWith(); // Generic contract, real use is with named optional params
}

abstract class AppState<T> extends Copyable<T> {}
