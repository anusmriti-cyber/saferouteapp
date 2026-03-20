import 'package:flutter/material.dart';
import '../models/hazard_report_model.dart';
import '../services/hazard_service.dart';

class HazardReportScreen extends StatefulWidget {
  const HazardReportScreen({super.key});

  @override
  State<HazardReportScreen> createState() => _HazardReportScreenState();
}

class _HazardReportScreenState extends State<HazardReportScreen> {
  final _formKey = GlobalKey<FormState>();
  HazardType _selectedType = HazardType.other;
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await HazardService.submitReport(
          type: _selectedType,
          description: _descriptionController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Hazard report submitted successfully!")),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error submitting report: $e")),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Hazard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Keep your community safe by reporting hazards you encounter.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              const Text("Hazard Type", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: HazardType.values.map((type) {
                  bool isSelected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(type.toString().split('.').last.toUpperCase()),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedType = type),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Describe the hazard (e.g. Broken streetlight, suspicious activity...)",
                ),
                validator: (val) => (val?.isEmpty ?? true) ? "Please provide a description" : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitReport,
                child: _isLoading 
                    ? const CircularProgressIndicator()
                    : const Text("SUBMIT REPORT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
