// ✅ 适用于无参数函数的节流扩展
extension FunctionExtThrottle on void Function() {
  void Function() throttle({int? timeout}) {
    final functionProxy = FunctionProxyThrottle(this, timeout: timeout);
    return functionProxy.throttle;
  }
}

class FunctionProxyThrottle {
  static final Map<int, int> _lastExecutionTime = {};

  final void Function() target;
  final int timeout;

  FunctionProxyThrottle(this.target, {int? timeout}) : timeout = timeout ?? 500;

  void throttle() {
    int now = DateTime.now().millisecondsSinceEpoch;
    int key = target.hashCode;
    int lastExecution = _lastExecutionTime[key] ?? 0;

    if (now - lastExecution >= timeout) {
      target();
      _lastExecutionTime[key] = now;
    }
  }
}

// ✅ 适用于带参数函数的节流扩展
extension FunctionExtThrottleWithArgs<T> on void Function(T) {
  void Function(T) throttle({int? timeout}) {
    final functionProxy =
        FunctionProxyThrottleWithArgs<T>(this, timeout: timeout);
    return functionProxy.throttle;
  }
}

class FunctionProxyThrottleWithArgs<T> {
  static final Map<int, int> _lastExecutionTime = {};

  final void Function(T) target;
  final int timeout;

  FunctionProxyThrottleWithArgs(this.target, {int? timeout})
      : timeout = timeout ?? 500;

  void throttle(T args) {
    int now = DateTime.now().millisecondsSinceEpoch;
    int key = target.hashCode;
    int lastExecution = _lastExecutionTime[key] ?? 0;

    if (now - lastExecution >= timeout) {
      target(args);
      _lastExecutionTime[key] = now;
    }
  }
}
