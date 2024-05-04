// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Graph {
  final int point_count;
  final int arc_count;
  final List<List<int>> adjacency_matrix;
  final List<List<int>> incidents_matrix;
  final List<int> right_incidents;
  Graph({
    required this.point_count,
    required this.arc_count,
    required this.adjacency_matrix,
    required this.incidents_matrix,
    required this.right_incidents,
  });

  Graph copyWith({
    int? point_count,
    int? arc_count,
    List<List<int>>? adjacency_matrix,
    List<List<int>>? incidents_matrix,
    List<int>? right_incidents,
  }) {
    return Graph(
      point_count: point_count ?? this.point_count,
      arc_count: arc_count ?? this.arc_count,
      adjacency_matrix: adjacency_matrix ?? this.adjacency_matrix,
      incidents_matrix: incidents_matrix ?? this.incidents_matrix,
      right_incidents: right_incidents ?? this.right_incidents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'point_count': point_count,
      'arc_count': arc_count,
      'adjacency_matrix': adjacency_matrix,
      'incidents_matrix': incidents_matrix,
      'right_incidents': right_incidents,
    };
  }

  @override
  String toString() {
    return 'ClassName(point_count: $point_count, arc_count: $arc_count, adjacency_matrix: $adjacency_matrix, incidents_matrix: $incidents_matrix, right_incidents: $right_incidents)';
  }

  @override
  bool operator ==(covariant Graph other) {
    if (identical(this, other)) return true;

    return other.point_count == point_count &&
        other.arc_count == arc_count &&
        listEquals(other.adjacency_matrix, adjacency_matrix) &&
        listEquals(other.incidents_matrix, incidents_matrix) &&
        listEquals(other.right_incidents, right_incidents);
  }

  @override
  int get hashCode {
    return point_count.hashCode ^
        arc_count.hashCode ^
        adjacency_matrix.hashCode ^
        incidents_matrix.hashCode ^
        right_incidents.hashCode;
  }
}
