import 'dart:convert';

dynamic cloneDeep(dynamic obj,
    {dynamic Function(Map<String, dynamic>)? fromJson}) {
  if (obj == null) return null;

  if (obj is num || obj is String || obj is bool) {
    return obj;
  }

  if (obj is List) {
    return obj.map((item) => cloneDeep(item, fromJson: fromJson)).toList();
  }

  if (obj is Map) {
    return obj.map(
        (key, value) => MapEntry(key, cloneDeep(value, fromJson: fromJson)));
  }

  try {
    // 先把对象转换为 JSON 字符串，再解析回来，实现真正的深拷贝
    var jsonString = jsonEncode(obj);
    var clonedJson = jsonDecode(jsonString);

    // 如果提供了 `fromJson` 方法，就用它来恢复原对象
    if (fromJson != null && clonedJson is Map<String, dynamic>) {
      return fromJson(clonedJson);
    }

    return clonedJson;
  } catch (e) {
    return obj;
  }
}
