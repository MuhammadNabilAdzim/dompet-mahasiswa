// lib/models/expense.dart
import 'dart:convert';

enum ExpenseCategory {
  makanan,
  transportasi,
  pendidikan,
  hiburan,
  kesehatan,
  belanja,
  lainnya,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.makanan:
        return 'Makanan & Minum';
      case ExpenseCategory.transportasi:
        return 'Transportasi';
      case ExpenseCategory.pendidikan:
        return 'Pendidikan';
      case ExpenseCategory.hiburan:
        return 'Hiburan';
      case ExpenseCategory.kesehatan:
        return 'Kesehatan';
      case ExpenseCategory.belanja:
        return 'Belanja';
      case ExpenseCategory.lainnya:
        return 'Lainnya';
    }
  }

  String get icon {
    switch (this) {
      case ExpenseCategory.makanan:
        return '🍜';
      case ExpenseCategory.transportasi:
        return '🚌';
      case ExpenseCategory.pendidikan:
        return '📚';
      case ExpenseCategory.hiburan:
        return '🎮';
      case ExpenseCategory.kesehatan:
        return '💊';
      case ExpenseCategory.belanja:
        return '🛍️';
      case ExpenseCategory.lainnya:
        return '📦';
    }
  }

  int get colorValue {
    switch (this) {
      case ExpenseCategory.makanan:
        return 0xFFFF6B6B;
      case ExpenseCategory.transportasi:
        return 0xFF4ECDC4;
      case ExpenseCategory.pendidikan:
        return 0xFF45B7D1;
      case ExpenseCategory.hiburan:
        return 0xFFFFBE0B;
      case ExpenseCategory.kesehatan:
        return 0xFF06D6A0;
      case ExpenseCategory.belanja:
        return 0xFFFF7C7C;
      case ExpenseCategory.lainnya:
        return 0xFFA8DADC;
    }
  }
}

class Expense {
  final String id;
  final String judul;
  final double jumlah;
  final ExpenseCategory kategori;
  final DateTime tanggal;
  final String? catatan;

  Expense({
    required this.id,
    required this.judul,
    required this.jumlah,
    required this.kategori,
    required this.tanggal,
    this.catatan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'jumlah': jumlah,
      'kategori': kategori.index,
      'tanggal': tanggal.millisecondsSinceEpoch,
      'catatan': catatan,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      judul: map['judul'],
      jumlah: map['jumlah'].toDouble(),
      kategori: ExpenseCategory.values[map['kategori']],
      tanggal: DateTime.fromMillisecondsSinceEpoch(map['tanggal']),
      catatan: map['catatan'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) =>
      Expense.fromMap(json.decode(source));
}
