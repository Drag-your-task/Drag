class TaskModel{
  String doc_id;
  bool is_fixed;//고정 시간표 내용인지 아닌지
  String task_name;
  bool is_checked;
  String? location;
  DateTime? start_date;
  DateTime? end_date;
  String? fixed_time;

  TaskModel({required this.doc_id, required this.is_fixed, required this.task_name, required this.is_checked, this.location, this.start_date, this.end_date, this.fixed_time});
}


