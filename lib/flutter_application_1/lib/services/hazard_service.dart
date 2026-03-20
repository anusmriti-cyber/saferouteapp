import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/hazard_report_model.dart';

class HazardService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'hazard_reports';

  /// Submits a new hazard report to Firestore.
  /// Returns the generated document ID.
  static Future<String> submitReport({
    required HazardType type,
    required String description,
    double? latitude,
    double? longitude,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final reporterId = currentUser?.uid ?? 'anonymous';

    final docRef = _db.collection(_collection).doc();

    final report = HazardReport(
      id: docRef.id,
      reporterId: reporterId,
      type: type,
      description: description,
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
      timestamp: DateTime.now(),
    );

    await docRef.set(report.toMap());

    return docRef.id;
  }

  /// Streams all hazard reports ordered by newest first.
  static Stream<List<HazardReport>> getReportsStream() {
    return _db
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HazardReport.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Streams hazard reports submitted by the current logged-in user.
  static Stream<List<HazardReport>> getMyReportsStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _db
        .collection(_collection)
        .where('reporterId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HazardReport.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Deletes a hazard report by document ID.
  static Future<void> deleteReport(String reportId) async {
    await _db.collection(_collection).doc(reportId).delete();
  }
}
