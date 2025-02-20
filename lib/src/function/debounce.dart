import 'dart:async';

// 重新定义扩展，明确扩展 void Function(T)
extension FunctionExtDebounceWithArgs<T> on void Function(T) {
  // 防抖扩展
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

  // 带参数的防抖方法
  void debounce(T args) {
    if (target == null) return;

    String key = target.hashCode.toString();

    // 如果定时器存在，取消之前的定时器
    _funcDebounce[key]?.cancel();

    // 设置新的定时器
    Timer? timer = Timer(Duration(milliseconds: timeout), () {
      // 执行目标函数
      target?.call(args);

      // 清除定时器
      _funcDebounce.remove(key);
    });

    // 更新定时器
    _funcDebounce[key] = timer;
  }
}
