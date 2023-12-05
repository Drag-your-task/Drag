import 'package:drag/services/task_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';
import '../utils/uil.dart';

class TaskViewModel with ChangeNotifier {
  DateTime selectedDay = DateTime.now();

  void set_selectedDay(DateTime day){
    selectedDay = day;
    _loadInitialData();
    //notifyListeners();
  }


  TaskViewModel(){
    print("day: "+formatDateTime(selectedDay));
    _loadInitialData();
  }


  final TaskService taskService = TaskService();
  List<TaskModel> tasks = [];
  List<String> fixed_list = [];
  List<String> draggable_list = [];

  Future<void> _loadInitialData() async {
    await loadTasks();
    await loadFixedList();
    await loadDraggableList();
  }


  Future<void> loadTasks() async {
    tasks = await taskService.getTasks(formatDateTime(selectedDay));
    notifyListeners();
  }

  Future<void> loadFixedList() async {
    fixed_list = await taskService.getFixedList(formatDateTime(selectedDay));
    notifyListeners();
  }

  Future<void> loadDraggableList() async {
    draggable_list = await taskService.getDraggableList(formatDateTime(selectedDay));
    notifyListeners();
  }

  int findTask(String doc_id) {
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].doc_id == doc_id) {
        return i;
      }
    }
    return -1; // 일치하는 항목이 없는 경우
  }


  int findTaskIndex(String taskId, bool isFixedList) {//fixed_list 나 draggable_list 에서 찾기
    List<String> taskList = isFixedList ? fixed_list : draggable_list;
    return taskList.indexOf(taskId);
  }



  void toggleCheck(TaskModel task){
    taskService.updateCheck(task.doc_id, task.is_checked!,formatDateTime(selectedDay));
    loadTasks();
    //notifyListeners();
  }



  // 리스트 내에서 아이템 위치 변경 (fixed_list 또는 draggable_list 기반으로)
  void reorderTask(String taskId, int newIndex, bool inFixedList) {
    List<String> list = inFixedList ? fixed_list : draggable_list;
    list.remove(taskId);
    list.insert(newIndex, taskId);
    notifyListeners();
    // Firestore에서도 순서 변경 반영
  }

  // 다른 리스트로 아이템 이동
  void moveTaskToList(String taskId,int newIndex, bool toFixedList) {
    if (toFixedList) {
      draggable_list.remove(taskId);
      fixed_list.insert(newIndex,taskId);
    } else {
      fixed_list.remove(taskId);
      draggable_list.insert(newIndex,taskId);
    }
    print(draggable_list);
    print(fixed_list);
    notifyListeners();
    // Firestore에서도 이동 반영
  }

  void addTask(DateTime start_date, DateTime end_date, String task_name){
    taskService.createTask(start_date, end_date, task_name);
    _loadInitialData();
  }

}