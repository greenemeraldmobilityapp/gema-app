import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../data/remote/supabase_service.dart';

class TransactionState {
  final List<TransactionModel> transactions;
  final double walletBalance;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasReachedMax;

  const TransactionState({
    this.transactions = const [],
    this.walletBalance = 0.0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasReachedMax = false,
  });

  TransactionState copyWith({
    List<TransactionModel>? transactions,
    double? walletBalance,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasReachedMax,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      walletBalance: walletBalance ?? this.walletBalance,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  final TransactionRepository _repository;
  int _offset = 0;
  static const int _limit = 20;

  TransactionNotifier(this._repository) : super(const TransactionState());

  Future<void> loadTransactions({bool refresh = false}) async {
    final userId = _getCurrentUserId();
    if (userId == null) return;

    if (refresh) {
      _offset = 0;
      state = state.copyWith(isLoading: true, error: null, hasReachedMax: false);
    } else if (state.isLoadingMore || state.hasReachedMax) {
      return;
    } else {
      state = state.copyWith(isLoadingMore: true, error: null);
    }

    try {
      final transactions = await _repository.getTransactions(
        userId: userId,
        limit: _limit,
        offset: _offset,
      );

      final balance = await _repository.getWalletBalance(userId);

      if (transactions.length < _limit) {
        state = state.copyWith(
          transactions: refresh ? transactions : [...state.transactions, ...transactions],
          walletBalance: balance,
          isLoading: false,
          isLoadingMore: false,
          hasReachedMax: true,
          error: null,
        );
      } else {
        _offset += _limit;
        state = state.copyWith(
          transactions: refresh ? transactions : [...state.transactions, ...transactions],
          walletBalance: balance,
          isLoading: false,
          isLoadingMore: false,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  String? _getCurrentUserId() {
    return SupabaseService.currentUser?.id;
  }

  Future<void> refresh() async {
    await loadTransactions(refresh: true);
  }

  Future<void> loadMore() async {
    await loadTransactions(refresh: false);
  }
}

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepository(),
);

final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>(
  (ref) => TransactionNotifier(ref.watch(transactionRepositoryProvider)),
);

final walletBalanceProvider = Provider<double>(
  (ref) => ref.watch(transactionNotifierProvider).walletBalance,
);

final recentTransactionsProvider = Provider<List<TransactionModel>>(
  (ref) {
    final transactions = ref.watch(transactionNotifierProvider).transactions;
    return transactions.take(5).toList();
  },
);
