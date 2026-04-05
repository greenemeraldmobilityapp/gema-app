import '../models/store_model.dart';
import '../remote/supabase_service.dart';

class StoreRepository {
  Future<List<StoreModel>> getStores({
    String? category,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = SupabaseService.client
        .from('stores')
        .select()
        .eq('is_open', true)
        .order('rating', ascending: false)
        .limit(limit)
        .range(offset, offset + limit - 1);

    if (category != null && category.isNotEmpty) {
      query = query.eq('category', category);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.or('name.ilike.%$searchQuery%,description.ilike.%$searchQuery%');
    }

    final response = await query;
    return (response as List)
        .map((json) => StoreModel.fromJson(json))
        .toList();
  }

  Future<StoreModel?> getStoreById(String id) async {
    final response = await SupabaseService.client
        .from('stores')
        .select()
        .eq('id', id)
        .single()
        .maybeSingle();

    if (response == null) return null;
    return StoreModel.fromJson(response);
  }

  Future<List<StoreModel>> getFeaturedStores({int limit = 6}) async {
    final response = await SupabaseService.client
        .from('stores')
        .select()
        .eq('is_open', true)
        .order('rating', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => StoreModel.fromJson(json))
        .toList();
  }

  Future<List<String>> getCategories() async {
    final response = await SupabaseService.client
        .from('stores')
        .select('category')
        .neq('category', null);

    final categories = (response as List)
        .map((json) => json['category'] as String)
        .toSet()
        .toList();

    return categories;
  }
}
