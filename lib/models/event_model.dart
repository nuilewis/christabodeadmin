import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final String? docId;

  const Event({
    required this.name,
    required this.description,
    required this.startDate,
    this.endDate,
    this.docId,
  });

  ///----copyWith----///
  Event copyWith({
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? docId,
  }) {
    return Event(
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      docId: docId ?? this.docId,
    );
  }

  ///---------To Map and From Map methods---------///
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "start": startDate,
      "end": endDate,
    };
    return data;
  }

  // factory constructor that returns a Devotional obj from a Map<String, dynamic>
  factory Event.fromMap({
    required Map<String, dynamic> data,
    required String docId,
  }) {
    Timestamp startDate = data["start"];
    Timestamp endDate = data["end"];
    return Event(
      name: data["name"],
      description: data["description"],
      startDate: startDate.toDate(),
      endDate: endDate.toDate(),
      docId: docId,
    );
  }

  ///---isEmpty Logic---///
  static Event empty = Event(
      name: "name", description: "description", startDate: DateTime.now());
  bool get isEmpty => this == Event.empty;
  bool get isNotEmpty => this != Event.empty;

  @override
  List<Object?> get props => [name, description, startDate, endDate];
}
