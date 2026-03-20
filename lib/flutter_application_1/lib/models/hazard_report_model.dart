import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum HazardType {
  crime,
  lighting,
  construction,
  accident,
  harassment,
  other
}

class HazardReport {
  final String id;
  final String reporterId;
  final HazardType type;
  final String description;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String? imageUrl;
  final int upvotes;

  HazardReport({
    required this.id,
    required this.reporterId,
    required this.type,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.imageUrl,
    this.upvotes = 0,
  });

  factory HazardReport.fromJson(Map<String, dynamic> json) {
    return HazardReport(
      id: json['id'],
      reporterId: json['reporterId'],
      type: HazardType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => HazardType.other,
      ),
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.parse(json['timestamp']),
      imageUrl: json['imageUrl'],
      upvotes: json['upvotes'] ?? 0,
    );
  }

  factory HazardReport.fromMap(Map<String, dynamic> map, String documentId) {
    return HazardReport(
      id: documentId,
      reporterId: map['reporterId'] ?? '',
      type: HazardType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => HazardType.other,
      ),
      description: map['description'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      timestamp: map['timestamp'] != null 
          ? (map['timestamp'] as Timestamp).toDate() 
          : DateTime.now(),
      imageUrl: map['imageUrl'],
      upvotes: map['upvotes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporterId': reporterId,
      'type': type.toString().split('.').last,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
      'upvotes': upvotes,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'reporterId': reporterId,
      'type': type.toString().split('.').last,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': Timestamp.fromDate(timestamp),
      'imageUrl': imageUrl,
      'upvotes': upvotes,
    };
  }

  IconData get icon {
    switch (type) {
      case HazardType.crime:
        return Icons.warning_rounded;
      case HazardType.lighting:
        return Icons.lightbulb_outline;
      case HazardType.construction:
        return Icons.construction;
      case HazardType.accident:
        return Icons.car_crash;
      case HazardType.harassment:
        return Icons.people_outline;
      case HazardType.other:
        return Icons.report_problem_outlined;
    }
  }

  Color get color {
    switch (type) {
      case HazardType.crime:
        return Colors.red;
      case HazardType.lighting:
        return Colors.orange;
      case HazardType.construction:
        return Colors.blue;
      case HazardType.accident:
        return Colors.amber;
      case HazardType.harassment:
        return Colors.purple;
      case HazardType.other:
        return Colors.grey;
    }
  }
}
