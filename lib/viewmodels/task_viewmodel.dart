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

  int findTask(String doc_id){//tasks에서 해당 doc_id를 포함하는 index찾기
    int i;
    for(i=0; i<tasks.length; i++){
      if(tasks[i].doc_id == doc_id){
        break;
      }
    }
    return i;
  }

  int findTaskIndex(String taskId, bool isFixedList) {//fixed_list 나 draggable_list 에서 찾기
    List<String> taskList = isFixedList ? fixed_list : draggable_list;
    return taskList.indexOf(taskId);
  }



  void toggleCheck(TaskModel task, int idx){
    if(tasks[idx].is_checked == true){
      tasks[idx].is_checked = false;
    }
    else{
      tasks[idx].is_checked = true;
    }
    taskService.updateCheck(task.doc_id, task.is_checked!);
    notifyListeners();
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
  void moveTaskToList(String taskId, bool toFixedList) {
    if (toFixedList) {
      draggable_list.remove(taskId);
      fixed_list.add(taskId);
    } else {
      fixed_list.remove(taskId);
      draggable_list.add(taskId);
    }
    print(draggable_list);
    print(fixed_list);
    notifyListeners();
    // Firestore에서도 이동 반영
  }

  // void moveTaskToList(String taskId, bool toFixedList) {
  //   if (toFixedList) {
  //     draggable_list.remove(taskId); // 오른쪽 리스트에서 제거
  //     if (!fixed_list.contains(taskId)) {
  //       fixed_list.add(taskId); // 왼쪽 리스트에 추가
  //     }
  //   } else {
  //     fixed_list.remove(taskId); // 왼쪽 리스트에서 제거
  //     if (!draggable_list.contains(taskId)) {
  //       draggable_list.add(taskId); // 오른쪽 리스트에 추가
  //     }
  //   }
  //   notifyListeners(); // UI 업데이트
  // }


}