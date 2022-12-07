import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Devotional extends Equatable {
  final String? docId;
  final String title;
  final String scripture;
  final String scriptureReference;
  final String content;
  final String confessionOfFaith;
  final String author;
  final DateTime startDate;
  final DateTime endDate;

  const Devotional({
    required this.title,
    required this.scripture,
    required this.scriptureReference,
    required this.confessionOfFaith,
    required this.author,
    required this.content,
    required this.startDate,
    required this.endDate,
    this.docId,
  });

  Devotional copyWith({
    String? docId,
    String? title,
    String? scripture,
    String? author,
    String? scriptureReference,
    String? confessionOfFaith,
    String? content,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Devotional(
        docId: docId ?? this.docId,
        title: title ?? this.title,
        scripture: scripture ?? this.scripture,
        scriptureReference: scriptureReference ?? this.scriptureReference,
        confessionOfFaith: confessionOfFaith ?? this.confessionOfFaith,
        content: content ?? this.content,
        author: author ?? this.author,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate);
  }

  ///---------To Map and From Map methods---------///
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "author": author,
      "content": content,
      "confession": confessionOfFaith,
      "start": startDate,
      "end": endDate,
      "scripture": scripture,
      "scriptureRef": scriptureReference,
      "title": title,
    };
    return data;
  }

  // factory constructor that returns a Devotional obj from a Map<String, dynamic>
  factory Devotional.fromMap({
    required Map<String, dynamic> data,
    required String docId,
  }) {
    Timestamp startDate = data["start"];
    Timestamp endDate = data["end"];
    return Devotional(
      title: data["title"],
      scripture: data["scripture"],
      scriptureReference: data["scriptureRef"],
      content: data["content"],
      startDate: startDate.toDate(),
      endDate: endDate.toDate(),
      confessionOfFaith: data["confession"],
      author: data["author"],
      docId: docId,
    );
  }

  ///------------isEmpty logic----------///
  static Devotional empty = Devotional(
      docId: "docId",
      title: "title",
      scripture: "scripture",
      scriptureReference: "scriptureReference",
      confessionOfFaith: "confessionOfFaith",
      author: "author",
      content: "content",
      startDate: DateTime.now(),
      endDate: DateTime.now());
  bool get isEmpty => this == Devotional.empty;
  bool get isNotEmpty => this != Devotional.empty;
  @override
  List<Object?> get props => [
        docId,
        title,
        scripture,
        scriptureReference,
        confessionOfFaith,
        content,
        author,
        startDate,
        endDate,
      ];
}
