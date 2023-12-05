import 'package:drag/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/uil.dart';



class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  Future<List<TaskModel>> getTasks(String day) async {
    QuerySnapshot querySnapshot = await _firestore.collection('calendar').doc(_firebaseAuth.currentUser?.uid).collection('day').doc(day)
        .collection('task').get();
    //querySnapshot = await _firestore.collection('/calendar/ 0U1fvPHkXVXUg9AQyduBOGzUim83/task').get();

    // print(querySnapshot.docs.length);
    return querySnapshot.docs.map((doc){
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print(data);
      return TaskModel(
        doc_id: data['doc_id'],
        is_fixed: data['is_fixed'],
        task_name: data['task_name'] ?? '',
        location: data['location'],
        fixed_time: data['fixed_time'],
        start_date: data['start_date'] != null ? (data['start_date'] as Timestamp).toDate(): null,
        end_date: data['end_date'] != null ? (data['end_date'] as Timestamp).toDate(): null,
        is_checked: data['is_checked'],
      );
    }).toList();
  }

  Future<List<String>> getFixedList(String day) async {
    DocumentSnapshot docSnapshot = await _firestore.collection('calendar').doc(_firebaseAuth.currentUser?.uid).collection('day').doc(day)
        .collection('fixed_list').doc('order').get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      List<dynamic> orderList = docSnapshot.get('order');
      return orderList.map((item) => item.toString()).toList();
    } else {
      return [];
    }
  }

  Future<List<String>> getDraggableList(String day) async {
    DocumentSnapshot docSnapshot = await _firestore.collection('calendar').doc(_firebaseAuth.currentUser?.uid).collection('day').doc(day)
        .collection('draggable_list').doc('order').get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      List<dynamic> orderList = docSnapshot.get('order');
      return orderList.map((item) => item.toString()).toList();
    } else {
      return [];
    }
  }

  Future<void> updateCheck(String doc_id, bool status, String day) async {
    await _firestore.collection('calendar').doc(_firebaseAuth.currentUser?.uid).collection('day').doc(day).collection('task').doc(doc_id).update({
      'is_checked' : !status,
    });
  }

  Future<void> updateDraggableList(String day, List<String> tasks) async {
    if(tasks.length == 1){
      await _firestore.collection('calendar').doc(_firebaseAuth.currentUser?.uid).collection('day').doc(day).collection('draggable_list').doc('order').set({
        'order': tasks,
      });
    }
    else{
      await _firestore.collection('calendar').doc(_firebaseAuth.currentUser?.uid).collection('day').doc(day).collection('draggable_list').doc('order').update({
        'order': tasks,
      });
    }
  }


  void updateFixedList(String day){

  }

  Future<void> createTask(DateTime start_date, DateTime end_date, String task_name) async {
    int differenceInDays = end_date.difference(start_date).inDays;


    for(int i=0; i<=differenceInDays; i++){
      String day = formatDateTime(start_date.add(Duration(days: i)));
      print(day);
      DocumentReference new_task_doc_ref = _firestore.collection('calendar').doc(_firebaseAuth.currentUser?.uid).collection('day').doc(day).collection('task').doc();

      await new_task_doc_ref.set({
        'doc_id' : new_task_doc_ref.id,
        'is_fixed' : false,
        'task_name' : task_name,
        'is_checked' : false,
        'start_date' : start_date,
        'end_date' : end_date,
      });

      List<String> tasks = await getDraggableList(day);
      tasks.add(new_task_doc_ref.id);
      updateDraggableList(day, tasks);

    }

  }

  Future<void> updateTask(DateTime start_date, DateTime end_date, String task_name) async {
    int differenceInDays = end_date.difference(start_date).inDays;

    // await _firestore.collection('calendar').doc(_firebaseAuth.currentUser?.uid).collection('day').doc(day).collection('task').doc(doc_id).update({
    //
    // });

    // for(int i=0; i<=differenceInDays; i++){
    //   String day = formatDateTime(start_date.add(Duration(days: i)));
    //   print(day);
    //   DocumentReference new_task_doc_ref = _firestore.collection('calendar').doc(_firebaseAuth.currentUser?.uid).collection('day').doc(day).collection('task').doc();
    //
    //   await new_task_doc_ref.update({
    //     'doc_id' : new_task_doc_ref.id,
    //     'is_fixed' : false,
    //     'task_name' : task_name,
    //     'is_checked' : false,
    //     'start_date' : start_date,
    //     'end_date' : end_date,
    //   });
    //
    //   List<String> tasks = await getDraggableList(day);
    //   tasks.add(new_task_doc_ref.id);
    //   updateDraggableList(day, tasks);
    //
    // }
  }

  Future<void> deleteTask(String day, String doc_id, List<String> tasks) async {
    await _firestore.collection('calendar').doc(_firebaseAuth.currentUser?.uid).collection('day').doc(day).collection('task').doc(doc_id).delete();
    await _firestore.collection('calendar').doc(_firebaseAuth.currentUser?.uid).collection('day').doc(day).collection('draggable_list').doc('order').update({
      'order': tasks,
    });
  }




}