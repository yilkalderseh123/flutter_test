import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskController extends GetxController {
  var taskList = <Map<String, dynamic>>[].obs;

  Future<void> getTasks() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/api/tasks'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Convert List<dynamic> to List<Map<String, dynamic>>
      taskList.value = List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  void deleteTask(String id) async {
    final response =
        await http.delete(Uri.parse('http://localhost:5000/api/tasks/$id'));
    if (response.statusCode == 200) {
      taskList.removeWhere((task) => task['_id'] == id);
    } else {
      throw Exception('Failed to delete task');
    }
  }

  void markTaskCompleted(int id) async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/api/tasks/$id'),
      body: jsonEncode({'isCompleted': 1}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      var taskIndex = taskList.indexWhere((task) => task['id'] == id);
      if (taskIndex != -1) {
        taskList[taskIndex]['isCompleted'] = 1;
        taskList.refresh();
      }
    } else {
      throw Exception('Failed to mark task as completed');
    }
  }
}
