// lib/providers/expense_provider.dart
import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';
import 'package:uuid/uuid.dart';

class ExpenseProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final _uuid = Uuid();

  List<Expense> _expenses = [];
  double _budget = 0;
  bool _isLoading = false;

  List<Expense> get expenses => List.unmodifiable(_expenses);
  double get budget => _budget;
  bool get isLoading => _isLoading;

  double get totalBulanIni {
    final now = DateTime.now();
    return _expenses
        .where(
            (e) => e.tanggal.month == now.month && e.tanggal.year == now.year)
        .fold(0.0, (sum, e) => sum + e.jumlah);
  }

  double get sisaBudget => _budget - totalBulanIni;

  double get persentasePenggunaan =>
      _budget > 0 ? (totalBulanIni / _budget).clamp(0.0, 1.0) : 0.0;

  List<Expense> get expensesBulanIni {
    final now = DateTime.now();
    final list = _expenses
        .where(
            (e) => e.tanggal.month == now.month && e.tanggal.year == now.year)
        .toList();
    list.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return list;
  }

  Map<ExpenseCategory, double> get perKategori {
    final now = DateTime.now();
    final Map<ExpenseCategory, double> result = {};
    for (final e in _expenses) {
      if (e.tanggal.month == now.month && e.tanggal.year == now.year) {
        result[e.kategori] = (result[e.kategori] ?? 0) + e.jumlah;
      }
    }
    return result;
  }

  List<MapEntry<DateTime, double>> get pengeluaranPerHari {
    final now = DateTime.now();
    final Map<DateTime, double> byDay = {};
    for (final e in _expenses) {
      if (e.tanggal.month == now.month && e.tanggal.year == now.year) {
        final day = DateTime(e.tanggal.year, e.tanggal.month, e.tanggal.day);
        byDay[day] = (byDay[day] ?? 0) + e.jumlah;
      }
    }
    final sorted = byDay.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sorted;
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _expenses = await _storage.loadExpenses();
    _budget = await _storage.loadBudget();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> tambahExpense({
    required String judul,
    required double jumlah,
    required ExpenseCategory kategori,
    required DateTime tanggal,
    String? catatan,
  }) async {
    final expense = Expense(
      id: _uuid.v4(),
      judul: judul,
      jumlah: jumlah,
      kategori: kategori,
      tanggal: tanggal,
      catatan: catatan,
    );
    await _storage.addExpense(expense);
    _expenses.add(expense);
    notifyListeners();
  }

  Future<void> hapusExpense(String id) async {
    await _storage.deleteExpense(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Future<void> setBudget(double amount) async {
    await _storage.saveBudget(amount);
    _budget = amount;
    notifyListeners();
  }
}
