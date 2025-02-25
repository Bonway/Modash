import 'dart:async';

// 适用于无参数函数的防抖扩展
extension FunctionExtDebounce on void Function() {
  void Function() debounce({int? timeout}) {
    final functionProxy = FunctionProxyDebounce(this, timeout: timeout);
    return functionProxy.debounce;
  }
}

class FunctionProxyDebounce {
  static final Map<String, Timer> _funcDebounce = {};

  final void Function()? target;
  final int timeout;

  FunctionProxyDebounce(this.target, {int? timeout}) : timeout = timeout ?? 500;

  void debounce() {
    if (target == null) return;

    String key = target.hashCode.toString();

    _funcDebounce[key]?.cancel();

    Timer? timer = Timer(Duration(milliseconds: timeout), () {
      target?.call();
      _funcDebounce.remove(key);
    });

    _funcDebounce[key] = timer;
  }
}

// 适用于带参数的函数的防抖扩展
extension FunctionExtDebounceWithArgs<T> on void Function(T) {
  void Function(T) debounce({int? timeout}) {
    final functionProxy =
        FunctionProxyDebounceWithArgs<T>(this, timeout: timeout);
    return functionProxy.debounce;
  }
}

class FunctionProxyDebounceWithArgs<T> {
  static final Map<String, Timer> _funcDebounce = {};

  final void Function(T)? target;
  final int timeout;

  FunctionProxyDebounceWithArgs(this.target, {int? timeout})
      : timeout = timeout ?? 500;

  void debounce(T args) {
    if (target == null) return;

    String key = target.hashCode.toString();

    _funcDebounce[key]?.cancel();

    Timer? timer = Timer(Duration(milliseconds: timeout), () {
      target?.call(args);
      _funcDebounce.remove(key);
    });

    _funcDebounce[key] = timer;
  }
}
