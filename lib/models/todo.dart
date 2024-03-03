//EXTENDED FROM shopping_list.dart
class ToDo {
  String title;
  bool complete;

  ToDo({required this.title, required this.complete});

  ToDo.fromMap(Map map)
      : this.title = map['title'],
        this.complete = map['complete'];

  Map toMap() {
    return {
      'title': this.title,
      'complete': this.complete,
    };
  }
}
