import 'package:drag/services/task_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';
import '../utils/uil.dart';

class TaskViewModel with ChangeNotifier {

  final TaskService taskService = TaskService();

  List<TaskModel> tasks = [];
  List<String> fixed_list = [];
  List<String> draggable_list = [];

  List<List<TaskModel>> fixed_timetable = [];

  DateTime selectedDay = DateTime.now();

  void set_selectedDay(DateTime day){
    selectedDay = day;
    _loadInitialData();
    //notifyListeners();
  }


  TaskViewModel(){
    // print("day: "+formatDateTime(selectedDay));
    _loadInitialData();
    getFixedTime();
  }


  Future<void> _loadInitialData() async {
    loadTasks();
    loadFixedList();
    loadDraggableList();
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



  Future<void> toggleCheck(TaskModel task) async {
    taskService.updateCheck(task.doc_id, task.is_checked!,formatDateTime(selectedDay));
    loadTasks();
    //notifyListeners();
  }



  // 리스트 내에서 아이템 위치 변경 (fixed_list 또는 draggable_list 기반으로)
  void reorderTask(String taskId, int newIndex, bool inFixedList) {
    List<String> list = inFixedList ? fixed_list : draggable_list;
    list.remove(taskId);
    list.insert(newIndex, taskId);
    taskService.reorderTask(inFixedList, list, formatDateTime(selectedDay));
    notifyListeners();
    // Firestore에서도 순서 변경 반영
  }

  // 다른 리스트로 아이템 이동
  void moveTaskToOhterList(String taskId,int newIndex, bool toFixedList) {
    if (toFixedList) {
      draggable_list.remove(taskId);
      fixed_list.insert(newIndex,taskId);
    } else {
      fixed_list.remove(taskId);
      draggable_list.insert(newIndex,taskId);
    }
    taskService.moveTaskToOhterList(fixed_list,draggable_list, formatDateTime(selectedDay));
    notifyListeners();
    // Firestore에서도 이동 반영
  }

  void moveDragToFixedAtLast(String taskId){
    draggable_list.remove(taskId);
    fixed_list.add(taskId);
    taskService.moveTaskToOhterList(fixed_list,draggable_list, formatDateTime(selectedDay));
    notifyListeners();
  }


  Future<void> addTask(DateTime start_date, DateTime end_date, String task_name) async {
    await taskService.createTask(start_date, end_date, task_name);
    _loadInitialData();
  }

  void editTask(DateTime start_date, DateTime end_date, String task_name){

  }

  Future<void> deleteTask(bool isInFixedList, DateTime day, String doc_id) async {
    if(isInFixedList){
      fixed_list.remove(doc_id);
      await taskService.deleteTask(isInFixedList, formatDateTime(day), doc_id, fixed_list);
    }else{
      draggable_list.remove(doc_id);
      await taskService.deleteTask(isInFixedList, formatDateTime(day), doc_id, draggable_list);
    }

    await _loadInitialData();
  }


  DateTime? tryParseStartTime(String? timeRange) {
    if (timeRange == null) return null;

    try {
      final startTimeStr = timeRange.split(' ~ ')[0];
      final timeParts = startTimeStr.split(':');
      if (timeParts.length != 2) return null;

      return DateTime(2000, 1, 1, int.parse(timeParts[0]), int.parse(timeParts[1]));
    } catch (e) {
      // Handle the error or log it
      print('Error parsing time: $e');
      return null;
    }
  }

  void sortTasksByTime(List<TaskModel> tasks) {
    tasks.sort((TaskModel a, TaskModel b) {
      final DateTime? aTime = tryParseStartTime(a.fixed_time);
      final DateTime? bTime = tryParseStartTime(b.fixed_time);

      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;

      return aTime!.compareTo(bTime!);
    });

  }

  Future<void> getFixedTime() async {
    await taskService.getFixedTime().then((value) {
      if (value != null) {
        for (List<TaskModel> dailyTasks in value) {
          if (dailyTasks.isNotEmpty) { // Check if the daily tasks list is not empty
            sortTasksByTime(dailyTasks); // Sort the tasks
          }
        }
        fixed_timetable = value;
      }
    });
    notifyListeners();
  }

  void addFixedTask(String task_name, String location, String? day, String fixed_time) async {
    await taskService.createFixedTask(task_name, location, day, fixed_time);
    getFixedTime();

  }



}