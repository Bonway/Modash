import 'dart:async';

// 重新定义扩展，明确扩展 void Function(T)
extension FunctionExtThrottleWithArgs<T> on void Function(T) {
  // 节流扩展
  void Function(T) throttle({int? timeout}) {
    final functionProxy =
        FunctionProxyThrottleWithArgs<T>(this, timeout: timeout);
    return functionProxy.throttle;
  }
}

class FunctionProxyThrottleWithArgs<T> {
  static final Map<String, bool> _funcThrottle = {};

  final void Function(T)? target;
  final int timeout;
  FunctionProxyThrottleWithArgs(this.target, {int? timeout})
      : timeout = timeout ?? 500;

  // 带参数的节流方法
  void throttle(T args) {
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
