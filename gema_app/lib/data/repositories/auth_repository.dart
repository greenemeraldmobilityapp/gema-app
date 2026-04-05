import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../remote/supabase_service.dart';

class AuthRepository {
  final SupabaseService _supabase;

  AuthRepository(this._supabase);

  Future<UserModel?> getCurrentUser() async {
    final user = SupabaseService.currentUser;
    if (user == null) return null;

    final response = await SupabaseService.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return UserModel.fromJson(response);
  }

  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    final response = await SupabaseService.client.auth.signUp(
      email: email,
      password: password,
      data: {
        if (fullName != null) 'full_name': fullName,
        if (phone != null) 'phone': phone,
      },
    );

    if (response.user != null) {
      await SupabaseService.client.from('profiles').insert({
        'id': response.user!.id,
        'email': email,
        if (fullName != null) 'full_name': fullName,
        if (phone != null) 'phone': phone,
      });
    }

    return response;
  }

  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await SupabaseService.client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'gema://reset-password',
    );
  }

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? address,
    String? avatarUrl,
  }) async {
    final user = SupabaseService.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (fullName != null) updates['full_name'] = fullName;
    if (phone != null) updates['phone'] = phone;
    if (address != null) updates['address'] = address;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await SupabaseService.client
        .from('profiles')
        .update(updates)
        .eq('id', user.id);
  }

  Future<String?> uploadAvatar(String filePath) async {
    final user = SupabaseService.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await SupabaseService.client.storage
        .from('profiles')
        .upload(fileName, filePath);

    final urlResponse = SupabaseService.client.storage
        .from('profiles')
        .getPublicUrl(fileName);

    return urlResponse;
  }
}
