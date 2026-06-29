// lib/models/budget.dart
import 'dart:convert';

class Budget {
  final double bulanan;
  final int bulan;
  final int tahun;

  Budget({
    required this.bulanan,
    required this.bulan,
    required this.tahun,
  });

  Map<String, dynamic> toMap() {
    return {
      'bulanan': bulanan,
      'bulan': bulan,
      'tahun': tahun,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      bulanan: map['bulanan'].toDouble(),
      bulan: map['bulan'],
      tahun: map['tahun'],
    );
  }

  String toJson() => json.encode(toMap());
  factory Budget.fromJson(String source) => Budget.fromMap(json.decode(source));
}
