import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Prayer extends Equatable {
  final String title;
  final String scripture;
  final String scriptureReference;
  final String content;
  final DateTime date;
 // final String? docId;

  const Prayer({
    required this.title,
    required this.scripture,
    required this.scriptureReference,
    required this.content,
    required this.date,
//    this.docId,
  });

  ///----------copyWith----------///
  Prayer copyWith({
    String? title,
    String? scripture,
    String? scriptureReference,
    String? content,
    DateTime? date,
 //   String? docId,
  }) {
    return Prayer(
    //    docId: docId ?? this.docId,
        title: title ?? this.title,
        scripture: scripture ?? this.scripture,
        scriptureReference: scriptureReference ?? this.scriptureReference,
        content: content ?? this.content,
        date: date ?? this.date);
  }

  ///---------To Map and From Map methods---------///
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "content": content,
      "date": date,
      "scripture": scripture,
      "scriptureRef": scriptureReference,
      "title": title,
    };
    return data;
  }

  // factory constructor that returns a Devotional obj from a Map<String, dynamic>
  factory Prayer.fromMap({
    required Map<String, dynamic> data,
  //  required String docId,
  }) {
    Timestamp date = data["date"];
    return Prayer(
      title: data["title"],
      scripture: data["scripture"],
      scriptureReference: data["scriptureRef"],
      content: data["content"],
      date: date.toDate(),
  //    docId: docId,
    );
  }

  ///------------isEmpty Logic-------------///
  static Prayer empty = Prayer(
      title: "",
      scripture: "scripture",
      scriptureReference: "scriptureReference",
      content: "content",
      date: DateTime.now());
  bool get isEmpty => this == Prayer.empty;
  bool get isNotEmpty => this != Prayer.empty;

  static final List<Prayer> demoData = [
    Prayer(
        title: "prayer 1",
        scripture: "scripture",
        scriptureReference: "scriptureReference",
        content: "content",
        date: DateTime.now()),
    Prayer(
        title: "prayer 2",
        scripture: "scripture",
        scriptureReference: "scriptureReference",
        content: "content",
        date: DateTime.now()),
  ];

  @override
  List<Object?> get props => [
        title,
        content,
        scripture,
        scriptureReference,
        date,
      ];
}
