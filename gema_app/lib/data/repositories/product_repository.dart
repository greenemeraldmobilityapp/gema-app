import '../models/product_model.dart';
import '../remote/supabase_service.dart';

class ProductRepository {
  Future<List<ProductModel>> getProducts({
    String? storeId,
    String? category,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = SupabaseService.client
        .from('products')
        .select()
        .eq('is_available', true)
        .order('created_at', ascending: false)
        .limit(limit)
        .range(offset, offset + limit - 1);

    if (storeId != null) {
      query = query.eq('store_id', storeId);
    }
    if (category != null && category.isNotEmpty) {
      query = query.eq('category', category);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('name', '%$searchQuery%');
    }

    final response = await query;
    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  Future<ProductModel?> getProductById(String id) async {
    final response = await SupabaseService.client
        .from('products')
        .select()
        .eq('id', id)
        .single()
        .maybeSingle();

    if (response == null) return null;
    return ProductModel.fromJson(response);
  }

  Future<List<ProductModel>> getFeaturedProducts({int limit = 6}) async {
    final response = await SupabaseService.client
        .from('products')
        .select()
        .eq('is_available', true)
        .order('rating', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  Future<List<String>> getCategories() async {
    final response = await SupabaseService.client
        .from('products')
        .select('category')
        .neq('category', null);

    final categories = (response as List)
        .map((json) => json['category'] as String)
        .toSet()
        .toList();

    return categories;
  }
}
