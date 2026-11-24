import 'package:flutter/material.dart';
import '../models/phone.dart';
import 'brand_list_screen.dart';
import 'comparison_screen.dart';

const String _kHeroBannerUrl =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlC9bOiuR--1MEa-GUulU_8z_zRLPt-jXcHQCfZCMp4A&s=10';

const String _kSamsungLogoUrl =
    'https://static.vecteezy.com/system/resources/previews/014/018/566/non_2x/samsung-logo-on-transparent-background-free-vector.jpg';

const String _kGoogleLogoUrl =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSilmPjZLzvGh9StjLOD5jEIYhLNHcnribU4uvg10rPTMRdMS71_FgJp5E&s=10';

class HomeScreen extends StatelessWidget {
  final List<Phone> phones;

  const HomeScreen({super.key, required this.phones});

  @override
  Widget build(BuildContext context) {
    final appleCount =
        phones.where((p) => p.brand.toLowerCase() == 'apple').length;
    final samsungCount =
        phones.where((p) => p.brand.toLowerCase() == 'samsung').length;
    final googleCount =
        phones.where((p) => p.brand.toLowerCase() == 'google').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        title: Image.asset(
          'assets/images/app_logo.png',
          height: 44,
          fit: BoxFit.contain,
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full-Width Light-Scrim Hero Banner
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                image: DecorationImage(
                  image: const NetworkImage(_kHeroBannerUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.32),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 26),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.48),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Apple, Samsung, & Google\nSmartphones in one place.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        height: 1.18,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black54,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Browse Apple, Samsung, and Google phones across multiple release years with instant spec comparisons',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black54,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Sharp-Cornered Search Bar
                    TextField(
                      readOnly: true,
                      onTap: () => _showGlobalSearch(context),
                      decoration: InputDecoration(
                        hintText: 'Search ${phones.length} phones...',
                        hintStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black87,
                          size: 22,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 14,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide:
                              BorderSide(color: Colors.black87, width: 1.2),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide:
                              BorderSide(color: Colors.black87, width: 1.2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Subtle Dataset Note Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ),
                      child: const Text(
                        'Current dataset includes officially released phones up to 2026.\nSome model specs may vary by region or variant.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // COMPARE PHONES CTA Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ComparisonScreen(phones: phones),
                    ),
                  );
                },
                icon: const Icon(Icons.compare_arrows_rounded),
                label: const Text(
                  'COMPARE PHONES',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),
            // "Or" Divider
            const Center(
              child: Text(
                'Or',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Browse by brand Heading
            const Center(
              child: Text(
                'Browse by brand',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Three Vertical Brand Cards Side-by-Side
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildVerticalBrandCard(
                      context: context,
                      brandName: 'Apple',
                      count: appleCount,
                      accentColor: const Color(0xFF1E293B),
                      logoWidget: const Icon(
                        Icons.apple,
                        size: 56,
                        color: Color(0xFF334155),
                      ),
                      showBottomLabel: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildVerticalBrandCard(
                      context: context,
                      brandName: 'Samsung',
                      count: samsungCount,
                      accentColor: const Color(0xFF1D4ED8),
                      logoWidget: Image.network(
                        _kSamsungLogoUrl,
                        height: 62,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Text(
                          'SAMSUNG',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      showBottomLabel: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildVerticalBrandCard(
                      context: context,
                      brandName: 'Google',
                      count: googleCount,
                      accentColor: const Color(0xFF047857),
                      logoWidget: Image.network(
                        _kGoogleLogoUrl,
                        height: 58,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Text(
                          'Google',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      showBottomLabel: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '© 2026 Mahnoor Ajmal • IT 315',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PhoneSpecs • Smartphone Spec Comparison',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalBrandCard({
    required BuildContext context,
    required String brandName,
    required int count,
    required Color accentColor,
    required Widget logoWidget,
    required bool showBottomLabel,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BrandListScreen(
              brandName: brandName,
              phones: phones,
            ),
          ),
        );
      },
      child: Container(
        height: 152,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.zero,
          border: Border.all(
            color: accentColor.withValues(alpha: 0.45),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(child: logoWidget),
            ),
            if (showBottomLabel) ...[
              const SizedBox(height: 4),
              Text(
                brandName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              '$count phones',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showGlobalSearch(BuildContext context) async {
    await showSearch<Phone?>(
      context: context,
      delegate: PhoneSearchDelegate(
        phones: phones,
        onSelectPhone: (searchContext, phone) {
          _showPhoneDetails(context, searchContext, phone);
        },
      ),
    );
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
      MapEntry('Front Camera', device.frontCamera),
      MapEntry('Camera Features', device.cameraFeatures),
      MapEntry('Extra Features', device.extraFeaturesSummary),
    ];

    return items.where((item) => _hasValue(item.value)).toList();
  }

  void _showPhoneDetails(
    BuildContext homeContext,
    BuildContext searchContext,
    Phone device,
  ) {
    showModalBottomSheet(
      context: searchContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
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
                  const SizedBox(height: 20),
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
                        Navigator.pop(sheetContext);
                        Navigator.pop(searchContext);
                        Navigator.push(
                          homeContext,
                          MaterialPageRoute(
                            builder: (_) => ComparisonScreen(
                              phones: phones,
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

class PhoneSearchDelegate extends SearchDelegate<Phone?> {
  final List<Phone> phones;
  final void Function(BuildContext searchContext, Phone phone) onSelectPhone;

  PhoneSearchDelegate({
    required this.phones,
    required this.onSelectPhone,
  });

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
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final q = query.trim().toLowerCase();
    final results = phones.where((p) {
      if (q.isEmpty) return true;
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
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text('${phone.brand.toUpperCase()} • ${phone.releaseDate}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onSelectPhone(context, phone),
        );
      },
    );
  }
}