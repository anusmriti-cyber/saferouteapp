import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/emergency_contact_model.dart';
import '../services/emergency_contact_service.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  List<EmergencyContact> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final loadedContacts = await EmergencyContactService.getContacts();
    setState(() {
      contacts = loadedContacts;
      isLoading = false;
    });
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Add contact", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Name", labelStyle: TextStyle(color: Color(0xFF9E9E9E)))),
            TextField(controller: phoneController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Phone", labelStyle: TextStyle(color: Color(0xFF9E9E9E)))),
            TextField(controller: relationController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Relationship (e.g. Father)", labelStyle: TextStyle(color: Color(0xFF9E9E9E)))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Color(0xFF9E9E9E)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE8340A)),
            onPressed: () async {
              if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                final newContact = EmergencyContact(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  phone: phoneController.text,
                  relationship: relationController.text.isEmpty ? "Contact" : relationController.text,
                );
                await EmergencyContactService.addContact(newContact);
                Navigator.pop(context);
                _loadContacts();
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text("Emergency Help"),
        backgroundColor: const Color(0xFFE8340A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Official Helplines",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 15),
                ...contacts.where((c) => c.relationship == 'Official').map(_buildContactCard),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Personal Contacts",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Color(0xFFE8340A)),
                      onPressed: _showAddContactDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ...contacts.where((c) => c.relationship != 'Official').map(_buildContactCard),
              ],
            ),
    );
  }

  Widget _buildContactCard(EmergencyContact contact) {
    bool isOfficial = contact.relationship == 'Official';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E2E2E)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOfficial ? Colors.red.withOpacity(0.1) : const Color(0xFFE8340A).withOpacity(0.1),
          child: Icon(
            isOfficial ? Icons.emergency : Icons.person,
            color: isOfficial ? Colors.red : const Color(0xFFE8340A),
          ),
        ),
        title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text("${contact.phone} • ${contact.relationship}", style: const TextStyle(color: Color(0xFF9E9E9E))),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Color(0xFF00E676)),
          onPressed: () async {
            final Uri url = Uri(scheme: 'tel', path: contact.phone);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
        ),
        onLongPress: isOfficial ? null : () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: const Text("Delete Contact?", style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Color(0xFF9E9E9E)))),
                TextButton(
                  onPressed: () async {
                    await EmergencyContactService.deleteContact(contact.id);
                    Navigator.pop(context);
                    _loadContacts();
                  },
                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
