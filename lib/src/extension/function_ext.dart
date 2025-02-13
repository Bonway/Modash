import 'dart:async';

// 重新定义扩展，明确扩展 void Function(T)
extension FunctionExtWithArgs<T> on void Function(T) {
  // 防抖扩展
  void Function(T) debounce({int? timeout}) {
    final functionProxy = FunctionProxyWithArgs<T>(this, timeout: timeout);
    return functionProxy.debounce;
  }

  // 节流扩展
  void Function(T) throttleWithTimeout({int? timeout}) {
    final functionProxy = FunctionProxyWithArgs<T>(this, timeout: timeout);
    return functionProxy.throttleWithTimeout;
  }
}

class FunctionProxyWithArgs<T> {
  static final Map<String, Timer> _funcDebounce = {};
  static final Map<String, bool> _funcThrottle = {};

  final void Function(T)? target;
  final int timeout;

  FunctionProxyWithArgs(this.target, {int? timeout}) : timeout = timeout ?? 500;

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

  // 带参数的节流方法
  void throttleWithTimeout(T args) {
    if (target == null) return;

    String key = target.hashCode.toString();
    bool enable = _funcThrottle[key] ?? true;

    if (enable) {
      // 执行目标函数
      target?.call(args);

      // 禁用节流，等待 timeout 后重新启用
      _funcThrottle[key] = false;

      Timer(Duration(milliseconds: timeout), () {
        _funcThrottle[key] = true;
      });
    }
  }
}
