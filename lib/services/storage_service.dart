// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import '../models/budget.dart';

class StorageService {
  static const String _expensesKey = 'expenses';
  static const String _budgetKey = 'budget';

  // ── EXPENSES ─────────────────────────────────────────

  Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_expensesKey);
    if (data == null) return [];
    final List<dynamic> list = json.decode(data);
    return list.map((e) => Expense.fromMap(e)).toList();
  }

  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(expenses.map((e) => e.toMap()).toList());
    await prefs.setString(_expensesKey, data);
  }

  Future<void> addExpense(Expense expense) async {
    final expenses = await loadExpenses();
    expenses.add(expense);
    await saveExpenses(expenses);
  }

  Future<void> deleteExpense(String id) async {
    final expenses = await loadExpenses();
    expenses.removeWhere((e) => e.id == id);
    await saveExpenses(expenses);
  }

  Future<void> updateExpense(Expense updated) async {
    final expenses = await loadExpenses();
    final idx = expenses.indexWhere((e) => e.id == updated.id);
    if (idx != -1) {
      expenses[idx] = updated;
      await saveExpenses(expenses);
    }
  }

  // ── BUDGET ────────────────────────────────────────────

  Future<double> loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_budgetKey) ?? 0.0;
  }

  Future<void> saveBudget(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetKey, amount);
  }
}
