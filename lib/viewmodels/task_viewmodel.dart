import 'package:drag/services/task_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/task_model.dart';

class TaskViewModel with ChangeNotifier {

  TaskViewModel(){
    _loadInitialData();
  }

  final TaskService taskService = TaskService();
  List<TaskModel> tasks = [];
  List<String> fixed_list = [];
  List<String> draggable_list = [];

  Future<void> _loadInitialData() async {
    loadTasks();
    loadFixedList();
    loadDraggableList();
  }


  Future<void> loadTasks() async {
    tasks = await taskService.getTasks();
    notifyListeners();
  }

  Future<void> loadFixedList() async {
    fixed_list = await taskService.getFixedList();
    notifyListeners();
  }

  Future<void> loadDraggableList() async {
    draggable_list = await taskService.getDraggableList();
    notifyListeners();
  }

  TaskModel? findTask(String doc_id){
    for(int i=0; i<tasks.length; i++){
      if(tasks[i].doc_id == doc_id){
        return tasks[i];
      }
    }
    return null;
  }

}