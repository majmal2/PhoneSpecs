import 'dart:convert';
import 'package:flutter/services.dart';

class Phone {
  final String id;
  final String brand;
  final String name;
  final String releaseDate;
  final int year;
  final Map<String, dynamic> display;
  final Map<String, dynamic> body;
  final Map<String, dynamic> cameraSpecifications;
  final Map<String, dynamic> additionalFeatures;
  final Map<String, dynamic> raw;

  Phone({
    required this.id,
    required this.brand,
    required this.name,
    required this.releaseDate,
    required this.year,
    required this.display,
    required this.body,
    required this.cameraSpecifications,
    required this.additionalFeatures,
    required this.raw,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    final brand = (json['brand'] ?? 'Unknown').toString().trim();
    final model = (json['model'] ?? json['name'] ?? 'Unknown Model')
        .toString()
        .replaceAll('_', ' ')
        .trim();
    final releaseDate =
        (json['releaseDate'] ?? json['year'] ?? 'Unknown').toString().trim();
    final year = _parseYear(releaseDate);

    final safeId = (json['id'] ?? '${brand}_${model}_$releaseDate')
        .toString()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

    return Phone(
      id: safeId,
      brand: brand,
      name: model,
      releaseDate: releaseDate,
      year: year,
      display: _asMap(json['display']),
      body: _asMap(json['body']),
      cameraSpecifications: _asMap(json['cameraSpecifications']),
      additionalFeatures: _asMap(json['additionalFeatures']),
      raw: Map<String, dynamic>.from(json),
    );
  }

  String get displaySize => _cleanText(display['size']) ?? 'N/A';

  String get displayResolution => _cleanText(display['resolution']) ?? 'N/A';

  String get displayTechnology => _cleanText(display['technology']) ?? 'N/A';

  String get displayType => displayTechnology;

  String get refreshRate => _cleanText(display['refreshRate']) ?? 'N/A';

  String get displaySummary {
    final parts = <String>[
      if (displaySize != 'N/A') displaySize,
      if (displayTechnology != 'N/A') displayTechnology,
      if (displayResolution != 'N/A') displayResolution,
      if (refreshRate != 'N/A') refreshRate,
    ];
    return parts.isEmpty ? 'N/A' : parts.join(' • ');
  }

  String get chipset => _cleanText(raw['processorChipset']) ?? 'N/A';

  String get os => _cleanText(raw['operatingSystemAtLaunch']) ?? 'N/A';

  String get memory {
    final ramList = _formatNumberList(raw['ramGbOptions'], unit: 'GB');
    final storageList = _formatNumberList(raw['storageOptionsGb'], unit: 'GB');

    if (storageList != null && ramList != null) {
      return '$storageList storage • $ramList RAM';
    }
    if (storageList != null) return '$storageList storage';
    if (ramList != null) return '$ramList RAM';
    return 'N/A';
  }

  String get batteryCapacity {
    final mah = raw['batteryMah'];
    final wired = raw['wiredChargingWatts'];
    final mahText = _formatNumberOrText(mah, unit: 'mAh');
    final wiredText = _formatNumberOrText(wired, unit: 'W');

    if (mahText != null && wiredText != null) {
      return '$mahText ($wiredText wired)';
    }
    return mahText ?? wiredText ?? 'N/A';
  }

  String get dimensions => _cleanText(body['dimensions']) ?? 'N/A';

  String get weight => _cleanText(body['weight']) ?? 'N/A';

  String get bodySummary {
    final parts = <String>[
      if (dimensions != 'N/A') dimensions,
      if (weight != 'N/A') weight,
    ];
    return parts.isEmpty ? 'N/A' : parts.join(' • ');
  }

  String get mainCamera =>
      _cleanText(cameraSpecifications['rearCameraSensorsAndResolutions']) ??
      'N/A';

  String get frontCamera =>
      _cleanText(cameraSpecifications['frontCameraSpecification']) ?? 'N/A';

  String get cameraFeatures {
    final feats = cameraSpecifications['cameraFeatures'];
    if (feats is List) {
      final cleaned =
          feats.map((e) => _cleanText(e)).whereType<String>().toList();
      if (cleaned.isNotEmpty) return cleaned.join(', ');
    }
    return _cleanText(cameraSpecifications['videoRecording']) ?? 'N/A';
  }

  String get extraFeaturesSummary {
    final items = <String>[];
    final wireless = _cleanText(additionalFeatures['wirelessCharging']);
    final water = _cleanText(additionalFeatures['waterAndDustResistance']);
    final storage = _cleanText(additionalFeatures['expandableStorage']);
    final stylus = _cleanText(additionalFeatures['stylusSupport']);

    if (water != null && water != 'Not specified') items.add(water);
    if (wireless != null && wireless != 'Not specified') {
      items.add('Wireless: $wireless');
    }
    if (stylus != null && stylus != 'Not specified') {
      items.add('Stylus: $stylus');
    }
    if (storage != null && storage != 'Not specified') {
      items.add('Card slot: $storage');
    }

    final other = additionalFeatures['otherFeatures'];
    if (other is List) {
      for (final o in other) {
        final text = _cleanText(o);
        if (text != null) items.add(text);
      }
    }

    return items.isEmpty ? 'N/A' : items.join(' • ');
  }

  /// Handy key-value map for building a 3-column comparison table:
  /// [Label | Phone 1 | Phone 2]
  Map<String, String> toComparisonMap() {
    return {
      'Brand': brand.toUpperCase(),
      'Model': name,
      'Release Date': releaseDate,
      'Display': displaySummary,
      'Chipset': chipset,
      'Memory & Storage': memory,
      'Battery & Charging': batteryCapacity,
      'Body & Weight': bodySummary,
      'Rear Camera': mainCamera,
      'Front Camera': frontCamera,
      'OS at Launch': os,
      'Extra Features': extraFeaturesSummary,
    };
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static int _parseYear(dynamic value) {
    if (value is int) return value;
    final match = RegExp(r'(19|20)\d{2}').firstMatch(value?.toString() ?? '');
    return int.tryParse(match?.group(0) ?? '') ?? 2024;
  }

  static String? _formatNumberList(dynamic value, {required String unit}) {
    if (value is! List || value.isEmpty) return null;
    final items = value
        .map((e) => _formatNumberOrText(e, unit: unit))
        .whereType<String>()
        .toList();
    if (items.isEmpty) return null;
    return items.join(' / ');
  }

  static String? _formatNumberOrText(dynamic value, {required String unit}) {
    final cleaned = _cleanText(value);
    if (cleaned == null) return null;
    if (cleaned.toLowerCase().contains(unit.toLowerCase())) {
      return cleaned;
    }
    final numVal = num.tryParse(cleaned);
    if (numVal != null) {
      final pretty =
          numVal % 1 == 0 ? numVal.toInt().toString() : numVal.toString();
      return '$pretty $unit';
    }
    return cleaned;
  }

  static String? _cleanText(dynamic input) {
    if (input == null) return null;
    final text = input
        .toString()
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (text.isEmpty) return null;
    final lower = text.toLowerCase();
    if (lower == 'n/a' ||
        lower == 'na' ||
        lower == 'null' ||
        lower == 'not available') {
      return null;
    }
    return text;
  }
}

Future<List<Phone>> loadPhonesFromJson({
  String assetPath = 'assets/phones.json',
}) async {
  final String response = await rootBundle.loadString(assetPath);
  final List<dynamic> data = json.decode(response);

  return data
      .whereType()
      .map((jsonItem) => Phone.fromJson(Map<String, dynamic>.from(jsonItem)))
      .toList();
}
