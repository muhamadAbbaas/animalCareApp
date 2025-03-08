class TaskModel {
  int? id;
  String title;
  DateTime dateTime;

  TaskModel({this.id, required this.title, required this.dateTime});

 Map<String, dynamic> toMap() {
  return {
    'id': id,
    'title': title,
    'date': dateTime.toIso8601String().split('T')[0], 
    'time': dateTime.toIso8601String().split('T')[1], 
  };
}

factory TaskModel.fromMap(Map<String, dynamic> map) {
  return TaskModel(
    id: map['id'],
    title: map['title'],
    dateTime: DateTime.parse("${map['date']}T${map['time']}"),
  );
}

}
