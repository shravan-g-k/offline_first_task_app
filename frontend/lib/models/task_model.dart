import 'dart:convert';
import 'dart:ui';

import 'package:frontend/core/constant/utils.dart';

class TaskModel {
  final String id;
  final String uid;
  final String title;
  final String description;
  final Color hexColor;
  final DateTime dueAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;
  TaskModel ({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.hexColor,
    required this.dueAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced
  });
  

  TaskModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    Color? hexColor,
    DateTime? dueAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced
  }) {
    return TaskModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      hexColor: hexColor ?? this.hexColor,
      dueAt: dueAt ?? this.dueAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'description': description,
      'hexColor': rgbToHex(hexColor),
      'dueAt': dueAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      hexColor: hexToRgb( map['hexColor'] ),
      dueAt: DateTime.parse(map['dueAt']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isSynced: map['isSynced']??1,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) => TaskModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskModel(id: $id, uid: $uid, title: $title, description: $description, hexColor: $hexColor, dueAt: $dueAt, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced) ';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TaskModel &&
      other.id == id &&
      other.uid == uid &&
      other.title == title &&
      other.description == description &&
      other.hexColor == hexColor &&
      other.dueAt == dueAt &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      uid.hashCode ^
      title.hashCode ^
      description.hashCode ^
      hexColor.hashCode ^
      dueAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isSynced.hashCode;
  }
}
