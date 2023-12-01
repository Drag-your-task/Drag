import 'package:drag/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



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

  void updateDraggableList(){

  }

  void updateFixedList(){

  }


}