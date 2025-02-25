import 'dart:async';
import 'package:modash/modash.dart';
import 'package:test/test.dart';

void main() {
  group('Debounce Function Tests', () {
    test('Debounce works for a no-argument function', () async {
      int callCount = 0;

      void targetFunction() {
        callCount++;
      }

      var debouncedFunction = targetFunction.debounce(timeout: 200);

      debouncedFunction();
      debouncedFunction();
      debouncedFunction();

      await Future.delayed(Duration(milliseconds: 250));

      expect(callCount, equals(1)); // 短时间内多次调用，最终只执行一次
    });

    test('Debounce works for a function with arguments', () async {
      int receivedValue = 0;

      void targetFunction(int value) {
        receivedValue = value;
      }

      var debouncedFunction = targetFunction.debounce(timeout: 200);

      debouncedFunction(10);
      debouncedFunction(20);
      debouncedFunction(30);

      await Future.delayed(Duration(milliseconds: 250));

      expect(receivedValue, equals(30)); // 只执行最后一次传入的参数
    });

    test('Debounce does not execute immediately', () async {
      int callCount = 0;

      void targetFunction() {
        callCount++;
      }

      var debouncedFunction = targetFunction.debounce(timeout: 200);

      debouncedFunction();

      expect(callCount, equals(0)); // 确保不会立即执行

      await Future.delayed(Duration(milliseconds: 250));

      expect(callCount, equals(1)); // 延迟后执行
    });

    test('Debounce resets timer if called again within timeout', () async {
      int callCount = 0;

      void targetFunction() {
        callCount++;
      }

      var debouncedFunction = targetFunction.debounce(timeout: 200);

      debouncedFunction();
      await Future.delayed(Duration(milliseconds: 100));
      debouncedFunction(); // 重新调用，计时器会重置
      await Future.delayed(Duration(milliseconds: 150));
      debouncedFunction(); // 再次重置
      await Future.delayed(Duration(milliseconds: 250));

      expect(callCount, equals(1)); // 只有最后一次调用生效
    });

    test('Multiple instances of debounce do not interfere', () async {
      int countA = 0, countB = 0;

      void functionA() {
        countA++;
      }

      void functionB() {
        countB++;
      }

      var debouncedA = functionA.debounce(timeout: 200);
      var debouncedB = functionB.debounce(timeout: 300);

      debouncedA();
      debouncedB();
      debouncedA();
      debouncedB();

      await Future.delayed(Duration(milliseconds: 400));

      expect(countA, equals(1)); // functionA 应该执行一次
      expect(countB, equals(1)); // functionB 也应该执行一次
    });
  });
}
