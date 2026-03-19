import 'package:flutter/material.dart';
import '../models/transport_data_model.dart';
import '../services/trnsport_api_service.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  final List<TransportDataModel> _allData =
      TransportApiService.getDummyTransportData();
  
  String? _selectedCategory; // "Bus", "Train", or null

  Color _getFrequencyColor(String frequencyLevel) {
    switch (frequencyLevel.toLowerCase()) {
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'low':
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_selectedCategory == null 
            ? 'Transport Categories' 
            : '$_selectedCategory Timings'),
        backgroundColor: Colors.transparent, // Transparent for gradient
        foregroundColor: Colors.white,
        elevation: 0,
        leading: _selectedCategory != null 
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedCategory = null),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1A0400)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selectedCategory == null 
                ? _buildCategorySelection() 
                : _buildTransportList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Transport Type",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Check schedules and safety frequency for buses and trains in your area.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: GridView.count(
              crossAxisCount: 1,
              childAspectRatio: 2.5,
              mainAxisSpacing: 20,
              children: [
                _categoryCard(
                  title: "Bus",
                  subtitle: "Local and Express Buses",
                  icon: Icons.directions_bus,
                  color: const Color(0xFFE8340A), // App brand color
                  onTap: () => setState(() => _selectedCategory = "Bus"),
                ),
                _categoryCard(
                  title: "Train",
                  subtitle: "Local, Metro, and Intercity",
                  icon: Icons.train,
                  color: const Color(0xFFE8340A), // App brand color
                  onTap: () => setState(() => _selectedCategory = "Train"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Dark card surface
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF2E2E2E)), // Border for separation
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 40),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportList() {
    final filteredData = _allData
        .where((d) => d.transportType.toLowerCase() == _selectedCategory!.toLowerCase())
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Available $_selectedCategory Entries",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() => _selectedCategory = null),
                child: const Text(
                  "Change Type", 
                  style: TextStyle(color: Color(0xFFE8340A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredData.isEmpty
                ? const Center(child: Text("No data available for this category.", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final data = filteredData[index];
                      final frequencyColor = _getFrequencyColor(data.frequencyLevel);

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Color(0xFF2E2E2E)),
                        ),
                        elevation: 0,
                        color: const Color(0xFF1E1E1E), // Dark card background
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Specific Transport Name & Frequency Badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data.transportName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: frequencyColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: frequencyColor, width: 1.5),
                                    ),
                                    child: Text(
                                      data.frequencyLevel,
                                      style: TextStyle(
                                        color: frequencyColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Area Name
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.grey, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    data.areaName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Frequency description
                              Row(
                                children: [
                                  const Icon(Icons.repeat, color: Colors.grey, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    data.frequency,
                                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(color: Color(0xFF2E2E2E)),
                              const SizedBox(height: 12),
                              const Text(
                                "SCHEDULED TIMINGS",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: data.schedules.map((time) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8340A).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFE8340A).withOpacity(0.5)),
                                    ),
                                    child: Text(
                                      time,
                                      style: const TextStyle(
                                        color: Color(0xFFE8340A),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
