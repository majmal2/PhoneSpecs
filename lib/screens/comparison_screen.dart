import 'package:flutter/material.dart';
import '../models/phone.dart';

class ComparisonScreen extends StatefulWidget {
  final List<Phone> phones;
  final Phone? initialPhone1;

  const ComparisonScreen({
    super.key,
    required this.phones,
    this.initialPhone1,
  });

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  Phone? _phone1;
  Phone? _phone2;

  @override
  void initState() {
    super.initState();
    _phone1 = widget.initialPhone1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Side-by-Side Comparison'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSearchableSelector(
                    1,
                    _phone1,
                    (selected) => setState(() => _phone1 = selected),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSearchableSelector(
                    2,
                    _phone2,
                    (selected) => setState(() => _phone2 = selected),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: (_phone1 == null || _phone2 == null)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.compare_arrows_rounded,
                            size: 64,
                            color: Colors.indigo.shade200,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Select two phones to compare specs side by side.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        _buildDeviceHeaderCard(_phone1!, _phone2!),

                        // AVAILABILITY
                        _buildSectionBanner(
                          Icons.event_available,
                          'Availability',
                        ),
                        _buildSpecComparisonCard(
                          'Release Date',
                          _phone1!.releaseDate,
                          _phone2!.releaseDate,
                        ),
                        _buildSpecComparisonCard(
                          'Release Year',
                          '${_phone1!.year}',
                          '${_phone2!.year}',
                        ),

                        // DESIGN & BATTERY
                        _buildSectionBanner(
                          Icons.stay_current_portrait,
                          'Design & Battery',
                        ),
                        _buildSpecComparisonCard(
                          'Weight',
                          _phone1!.weight,
                          _phone2!.weight,
                        ),
                        _buildSpecComparisonCard(
                          'Battery',
                          _phone1!.batteryCapacity,
                          _phone2!.batteryCapacity,
                        ),

                        // DISPLAY
                        _buildSectionBanner(
                          Icons.tablet_android,
                          'Display',
                        ),
                        _buildSpecComparisonCard(
                          'Display Size',
                          _phone1!.displaySize,
                          _phone2!.displaySize,
                        ),
                        _buildSpecComparisonCard(
                          'Display Type',
                          _phone1!.displayType,
                          _phone2!.displayType,
                        ),
                        _buildSpecComparisonCard(
                          'Resolution',
                          _phone1!.displayResolution,
                          _phone2!.displayResolution,
                        ),

                        // PERFORMANCE & SOFTWARE
                        _buildSectionBanner(
                          Icons.memory,
                          'Performance & Software',
                        ),
                        _buildSpecComparisonCard(
                          'Chipset',
                          _phone1!.chipset,
                          _phone2!.chipset,
                        ),
                        _buildSpecComparisonCard(
                          'Operating System',
                          _phone1!.os,
                          _phone2!.os,
                        ),
                        _buildSpecComparisonCard(
                          'Memory / RAM',
                          _phone1!.memory,
                          _phone2!.memory,
                        ),

                        // CAMERA
                        _buildSectionBanner(
                          Icons.camera_alt_outlined,
                          'Camera',
                        ),
                        _buildSpecComparisonCard(
                          'Rear Camera',
                          _phone1!.mainCamera,
                          _phone2!.mainCamera,
                        ),
                        _buildSpecComparisonCard(
                          'Camera Features',
                          _phone1!.cameraFeatures,
                          _phone2!.cameraFeatures,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchableSelector(
    int slotIndex,
    Phone? currentPhone,
    ValueChanged<Phone?> onSelected,
  ) {
    return InkWell(
      onTap: () async {
        final Phone? result = await showSearch<Phone?>(
          context: context,
          delegate: ComparisonSearchDelegate(phones: widget.phones),
        );
        if (result != null) onSelected(result);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.indigo.shade200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                currentPhone?.name ?? 'Select Phone $slotIndex',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.indigo.shade900,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.search, size: 18, color: Colors.indigo),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceHeaderCard(Phone phone1, Phone phone2) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade900,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(child: _buildHeaderColumn(phone1)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 1,
            height: 38,
            color: Colors.white24,
          ),
          Expanded(child: _buildHeaderColumn(phone2)),
        ],
      ),
    );
  }

  Widget _buildHeaderColumn(Phone phone) {
    return Column(
      children: [
        Text(
          phone.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${phone.brand.toUpperCase()} • ${phone.year}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildSectionBanner(IconData icon, String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14, bottom: 6),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 19, color: Colors.indigo.shade900),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.indigo.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecComparisonCard(String label, String val1, String val2) {
    final clean1 = val1.trim().isNotEmpty ? val1.trim() : 'N/A';
    final clean2 = val2.trim().isNotEmpty ? val2.trim() : 'N/A';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  clean1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade800),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 1,
                height: 30,
                color: Colors.grey.shade200,
              ),
              Expanded(
                child: Text(
                  clean2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ComparisonSearchDelegate extends SearchDelegate<Phone?> {
  final List<Phone> phones;

  ComparisonSearchDelegate({required this.phones});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildList();

  Widget _buildList() {
    final results = phones.where((p) {
      final q = query.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final phone = results[index];
        return ListTile(
          title: Text(
            phone.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${phone.brand.toUpperCase()} • Released ${phone.releaseDate}'),
          trailing: const Icon(Icons.add_circle_outline, color: Colors.indigo),
          onTap: () => close(context, phone),
        );
      },
    );
  }
}
