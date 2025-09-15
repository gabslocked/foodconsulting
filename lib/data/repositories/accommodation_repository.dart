import '../models/accommodation_model.dart';
import '../services/supabase_service.dart';

class AccommodationRepository {
  // Get accommodation by ID
  Future<AccommodationModel?> getAccommodationById(String accommodationId) async {
    try {
      final response = await SupabaseService.from('accommodations')
          .select()
          .eq('id', accommodationId)
          .maybeSingle();
      
      if (response != null) {
        return AccommodationModel.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Update accommodation room number
  Future<AccommodationModel> updateRoomNumber(String accommodationId, String roomNumber) async {
    try {
      final response = await SupabaseService.from('accommodations')
          .update({
            'room_number': roomNumber,
            'updated_at': DateTime.now().toIso8601String()
          })
          .eq('id', accommodationId)
          .select()
          .single();
      
      return AccommodationModel.fromJson(response);
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Update accommodation status
  Future<AccommodationModel> updateAccommodationStatus(
    String accommodationId, 
    String status
  ) async {
    try {
      final response = await SupabaseService.from('accommodations')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String()
          })
          .eq('id', accommodationId)
          .select()
          .single();
      
      return AccommodationModel.fromJson(response);
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
}
