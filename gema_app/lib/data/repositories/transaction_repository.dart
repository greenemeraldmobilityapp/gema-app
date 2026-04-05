import '../models/transaction_model.dart';
import '../remote/supabase_service.dart';

class TransactionRepository {
  Future<List<TransactionModel>> getTransactions({
    String? userId,
    int limit = 20,
    int offset = 0,
    TransactionCategory? category,
    TransactionStatus? status,
  }) async {
    var query = SupabaseService.client
        .from('transactions')
        .select()
        .order('created_at', ascending: false)
        .limit(limit)
        .range(offset, offset + limit - 1);

    if (userId != null) {
      query = query.eq('user_id', userId);
    }
    if (category != null) {
      query = query.eq('category', category.name);
    }
    if (status != null) {
      query = query.eq('status', status.name);
    }

    final response = await query;
    return (response as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  Future<double> getWalletBalance(String userId) async {
    final response = await SupabaseService.client
        .from('profiles')
        .select('wallet_balance')
        .eq('id', userId)
        .single();

    return (response['wallet_balance'] as num?)?.toDouble() ?? 0.0;
  }

  Stream<List<TransactionModel>> streamTransactions({
    required String userId,
    int limit = 20,
  }) {
    return SupabaseService.client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit)
        .map((data) => data
            .map((json) => TransactionModel.fromJson(json))
            .toList());
  }
}
