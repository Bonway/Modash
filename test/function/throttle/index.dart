import 'dart:async';
import 'package:modash/modash.dart';
import 'package:test/test.dart';

void main() {
  group('Throttle Function Tests', () {
    test('Throttle limits function execution within timeout', () async {
      int callCount = 0;

      void targetFunction() {
        callCount++;
      }

      var throttledFunction = targetFunction.throttle(timeout: 200);

      throttledFunction();
      throttledFunction();
      throttledFunction();

      await Future.delayed(const Duration(milliseconds: 250));

      expect(callCount, equals(1)); // 200ms 内多次调用，只执行一次
    });

    test('Throttle allows execution after timeout', () async {
      int callCount = 0;

      void targetFunction() {
        callCount++;
      }

      var throttledFunction = targetFunction.throttle(timeout: 200);

      throttledFunction();
      await Future.delayed(const Duration(milliseconds: 250));
      throttledFunction();

      expect(callCount, equals(2)); // 250ms 后再次调用，应该能执行
    });

    test('Throttle works with arguments', () async {
      int lastReceivedValue = 0;

      void targetFunction(int value) {
        lastReceivedValue = value;
      }

      var throttledFunction = targetFunction.throttle(timeout: 200);

      throttledFunction(1);
      throttledFunction(2);
      throttledFunction(3);

      await Future.delayed(const Duration(milliseconds: 250));

      expect(lastReceivedValue, equals(1)); // 只执行第一次传入的值
    });

    test('Throttle does not queue executions', () async {
      int callCount = 0;

      void targetFunction() {
        callCount++;
      }

      var throttledFunction = targetFunction.throttle(timeout: 200);

      throttledFunction();
      await Future.delayed(const Duration(milliseconds: 100));
      throttledFunction();
      await Future.delayed(const Duration(milliseconds: 100));
      throttledFunction();

      await Future.delayed(const Duration(milliseconds: 250));

      expect(callCount, equals(2));
    });

    test('Throttle multiple instances do not interfere', () async {
      int countA = 0, countB = 0;

      void functionA() {
        countA++;
      }

      void functionB() {
        countB++;
      }

      var throttledA = functionA.throttle(timeout: 200);
      var throttledB = functionB.throttle(timeout: 300);

      throttledA();
      throttledB();
      throttledA();
      throttledB();

      await Future.delayed(const Duration(milliseconds: 400));

      expect(countA, equals(1)); // functionA 200ms 内只执行一次
      expect(countB, equals(1)); // functionB 300ms 内只执行一次
    });
  });
}
