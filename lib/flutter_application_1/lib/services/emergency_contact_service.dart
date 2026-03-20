import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emergency_contact_model.dart';

class EmergencyContactService {
  static const String _contactsKey = 'emergency_contacts';

  static Future<List<EmergencyContact>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? contactsJson = prefs.getString(_contactsKey);
    if (contactsJson == null) {
      return _getDefaultContacts();
    }
    final List<dynamic> decoded = json.decode(contactsJson);
    return decoded.map((item) => EmergencyContact.fromJson(item)).toList();
  }

  static List<EmergencyContact> _getDefaultContacts() {
    return [
      EmergencyContact(
        id: '1',
        name: 'Police Helpline',
        phone: '100',
        relationship: 'Official',
      ),
      EmergencyContact(
        id: '2',
        name: 'Women Helpline',
        phone: '1091',
        relationship: 'Official',
      ),
      EmergencyContact(
        id: '3',
        name: 'Ambulance',
        phone: '102',
        relationship: 'Official',
      ),
    ];
  }

  static Future<void> addContact(EmergencyContact contact) async {
    final contacts = await getContacts();
    contacts.add(contact);
    await _saveContacts(contacts);
    
    // Save to Firestore
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('emergency_contacts')
            .doc(contact.id)
            .set({
              ...contact.toJson(),
              'userId': user.uid,
              'timestamp': FieldValue.serverTimestamp(),
            });
      }
    } catch (e) {
      print('Error saving emergency contact to Firestore: $e');
    }
  }

  static Future<void> deleteContact(String id) async {
    final contacts = await getContacts();
    contacts.removeWhere((c) => c.id == id);
    await _saveContacts(contacts);
    
    // Delete from Firestore
    try {
      await FirebaseFirestore.instance
          .collection('emergency_contacts')
          .doc(id)
          .delete();
    } catch (e) {
      print('Error deleting emergency contact from Firestore: $e');
    }
  }

  static Future<void> _saveContacts(List<EmergencyContact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(
      contacts.map((c) => c.toJson()).toList(),
    );
    await prefs.setString(_contactsKey, encoded);
  }
}
