import 'package:flutter/material.dart';
import '../models/phone.dart';
import 'comparison_screen.dart';

class BrandListScreen extends StatefulWidget {
  final String brandName;
  final List<Phone> phones;

  const BrandListScreen({
    super.key,
    required this.brandName,
    required this.phones,
  });

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  String _searchQuery = '';
  String _selectedSeries = 'All';

  @override
  Widget build(BuildContext context) {
    final brandPhones = widget.phones
        .where((p) => p.brand.toLowerCase() == widget.brandName.toLowerCase())
        .toList()
      ..sort((a, b) {
        final yearCompare = b.year.compareTo(a.year);
        if (yearCompare != 0) return yearCompare;
        return a.name.compareTo(b.name);
      });

    final seriesList = ['All', ..._extractSeriesList(brandPhones)];

    final filtered = brandPhones.where((p) {
      final matchesSearch =
          p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSeries =
          _selectedSeries == 'All' || _seriesLabelForPhone(p) == _selectedSeries;
      return matchesSearch && matchesSeries;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.brandName} Phones'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.indigo.shade50,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.brandName} Catalog',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Browse by series, search phones, view details, and compare instantly.',
                  style: TextStyle(fontSize: 13, color: Colors.indigo.shade700),
                ),
                const SizedBox(height: 14),
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search ${widget.brandName} phones...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: seriesList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final series = seriesList[index];
                      final selected = _selectedSeries == series;
                      return ChoiceChip(
                        label: Text(series),
                        selected: selected,
                        selectedColor: Colors.indigo.shade100,
                        labelStyle: TextStyle(
                          color:
                              selected ? Colors.indigo.shade900 : Colors.black87,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (_) =>
                            setState(() => _selectedSeries = series),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Showing ${filtered.length} phones',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No phones found.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final device = filtered[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            device.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Released: ${device.year}'),
                                const SizedBox(height: 4),
                                Text(
                                  '${device.displaySize} • ${device.batteryCapacity}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showDeviceDetails(context, device),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<String> _extractSeriesList(List<Phone> phones) {
    final set = <String>{};
    for (final phone in phones) {
      set.add(_seriesLabelForPhone(phone));
    }
    final list = set.toList()..sort();
    return list;
  }

  String _seriesLabelForPhone(Phone phone) {
    final name = phone.name;

    if (widget.brandName.toLowerCase() == 'apple') {
      final match =
          RegExp(r'iPhone\s+(\d+)', caseSensitive: false).firstMatch(name);
      if (match != null) return 'iPhone ${match.group(1)} Series';
      if (name.toLowerCase().contains('se')) return 'iPhone SE';
      return 'Other iPhone';
    }

    if (widget.brandName.toLowerCase() == 'samsung') {
      if (RegExp(r'\bGalaxy\s+S\d*', caseSensitive: false).hasMatch(name)) {
        return 'Galaxy S Series';
      }
      if (RegExp(r'\bGalaxy\s+A\d*', caseSensitive: false).hasMatch(name)) {
        return 'Galaxy A Series';
      }
      if (RegExp(r'\bGalaxy\s+M\d*', caseSensitive: false).hasMatch(name)) {
        return 'Galaxy M Series';
      }
      if (RegExp(r'\bGalaxy\s+Note\d*', caseSensitive: false).hasMatch(name)) {
        return 'Galaxy Note Series';
      }
      if (RegExp(r'\bGalaxy\s+Z\b', caseSensitive: false).hasMatch(name)) {
        return 'Galaxy Z Series';
      }
      return 'Other Galaxy';
    }

    if (widget.brandName.toLowerCase() == 'google') {
      if (name.toLowerCase().contains('fold')) return 'Pixel Fold';
      final pixelMatch =
          RegExp(r'Pixel\s+(\d+)', caseSensitive: false).firstMatch(name);
      if (pixelMatch != null) return 'Pixel ${pixelMatch.group(1)} Series';
      return 'Other Pixel';
    }

    return 'Other';
  }

  bool _hasValue(String value) {
    final v = value.trim().toLowerCase();
    return v.isNotEmpty &&
        v != 'n/a' &&
        v != 'na' &&
        v != 'not available' &&
        v != 'null';
  }

  List<MapEntry<String, String>> _availableSpecs(Phone device) {
    final items = <MapEntry<String, String>>[
      MapEntry('Display Size', device.displaySize),
      MapEntry('Display Type', device.displayType),
      MapEntry('Resolution', device.displayResolution),
      MapEntry('Chipset', device.chipset),
      MapEntry('Operating System', device.os),
      MapEntry('Memory / RAM', device.memory),
      MapEntry('Battery', device.batteryCapacity),
      MapEntry('Weight', device.weight),
      MapEntry('Rear Camera', device.mainCamera),
      MapEntry('Camera Features', device.cameraFeatures),
    ];

    return items.where((item) => _hasValue(item.value)).toList();
  }

  void _showDeviceDetails(BuildContext context, Phone device) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        final specRows = _availableSpecs(device);

        return DraggableScrollableSheet(
          initialChildSize: 0.82,
          minChildSize: 0.55,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    device.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${device.brand.toUpperCase()} • Released ${device.releaseDate}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ComparisonScreen(
                              phones: widget.phones,
                              initialPhone1: device,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.compare_arrows),
                      label: const Text(
                        'Compare This Phone',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Specifications',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (specRows.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Detailed specs are not available for this model in the current dataset.',
                        style:
                            TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                    )
                  else
                    ...specRows.map((entry) => _specRow(entry.key, entry.value)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Some specifications may be unavailable for certain models in the current database.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _specRow(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
