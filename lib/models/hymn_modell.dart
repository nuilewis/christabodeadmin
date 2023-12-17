import 'package:equatable/equatable.dart';

class Hymn extends Equatable {
  final String title;
  final String content;
  final int number;

  final String? docId;

  const Hymn({
    required this.title,
    required this.content,
    required this.number,
    this.docId,
  });

  ///----copyWith----///
  Hymn copyWith({
    String? title,
    String? content,
    int? number,
    String? docId,
  }) {
    return Hymn(
      title: title ?? this.title,
      content: content ?? this.content,
  number: number ?? this.number,
      docId: docId ?? this.docId,
    );
  }

  ///---------To Map and From Map methods---------///
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "title": title,
      "content": content,
      "number": number,

    };
    return data;
  }

  // factory constructor that returns a Devotional obj from a Map<String, dynamic>
  factory Hymn.fromMap({
    required Map<String, dynamic> data,
    required String docId,
  }) {

    return Hymn(
      title: data["title"],
      content: data["content"],
      number: data["number"],

      docId: docId,
    );
  }

  ///---isEmpty Logic---///
  static Hymn empty = const Hymn(
      title: "title", content: "content", number: 0);
  bool get isEmpty => this == Hymn.empty;
  bool get isNotEmpty => this != Hymn.empty;

  @override
  List<Object?> get props => [title, content, number];
}
