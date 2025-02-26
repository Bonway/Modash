import 'package:test/test.dart';
import 'package:modash/modash.dart';

import 'user.dart'; // 假设你将 cloneDeep 放在 modash.dart 文件中

void main() {
  group('cloneDeep tests', () {
    test('should clone primitive types correctly', () {
      expect(cloneDeep(42), 42);
      expect(cloneDeep('Hello'), 'Hello');
      expect(cloneDeep(true), true);
    });

    test('should clone List correctly', () {
      var original = [1, 2, 3];
      var cloned = cloneDeep(original);
      cloned[0] = 99;

      print("List original: ${original[0]}"); // 1
      print("List cloned: ${cloned[0]}"); // 99

      // 原始列表应保持不变
      expect(original[0], 1);
      expect(cloned[0], 99);

      // expect(original, cloned); // 失败，list1 和 list2 是不同的对象实例，即使它们的内容相同
      // expect(original == cloned, true); // 失败，'==' 默认比较引用，返回 false
    });

    test('should clone Map correctly', () {
      var original = {'name': 'Alice', 'age': 30};
      var cloned = cloneDeep(original);
      cloned['name'] = 'Bob';

      print("Map original: ${original['name']}"); // Alice
      print("Map cloned: ${cloned['name']}"); // Bob

      // 原始 Map 应保持不变
      expect(original['name'], 'Alice');
      expect(cloned['name'], 'Bob');
    });

    test('should clone List correctly', () {
      var original = [
        {'name': 'Alice', 'age': 30},
        {'name': 'Tom', 'age': 31}
      ];
      var cloned = cloneDeep(original);
      cloned[0]['name'] = 'Bob';

      print("Map original: ${original[0]['name']}"); // Alice
      print("Map cloned: ${cloned[0]['name']}"); // Bob

      // 原始 Map 应保持不变
      expect(original[0]['name'], 'Alice');
      expect(cloned[0]['name'], 'Bob');
    });

    test('should clone custom object correctly', () {
      var user = User(name: 'Alice', age: 30);

      // 这里传入 `fromJson` 让 cloneDeep 自动还原对象
      var clonedUser = cloneDeep(user, fromJson: User.fromJson) as User;
      clonedUser.name = 'Bob';

      expect(clonedUser.name, 'Bob');
      expect(clonedUser.age, 30);
      expect(user.name, 'Alice'); // 确保原对象未修改
    });

    test('should clone custom object correctly', () {
      var user = User(name: 'Alice', age: 30);

      // 使用 cloneDeep 进行深拷贝
      User clonedUser = cloneDeep(user, fromJson: User.fromJson);
      clonedUser.name = 'Bob';

      // 验证克隆后的对象与原对象之间的差异
      // expect(clonedUser.name, 'Bob');
      // expect(clonedUser.age, 30);

      // // 验证原对象保持不变
      // expect(user.name, 'Alice');
      // expect(user.age, 30);

      // // 确保 clonedUser 是新对象
      // expect(clonedUser, isNot(same(user))); // 确保不是同一个对象

      // 打印结果检查
      print("custom original: ${user.name}"); // Alice
      print("custom cloned: ${clonedUser.name}"); // Bob
    });

    test('should clone Model List correctly', () {
      var original = [
        {'name': 'Alice', 'age': 30},
        {'name': 'Tom', 'age': 31}
      ];

      var cloned = cloneDeep(original);
      cloned[0]['name'] = 'Bob';

      print("Map original: ${original[0]['name']}"); // Alice
      print("Map cloned: ${cloned[0]['name']}"); // Bob

      // 原始 Map 应保持不变
      expect(original[0]['name'], 'Alice');
      expect(cloned[0]['name'], 'Bob');
    });
  });
}
