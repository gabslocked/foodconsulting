import '../models/flight_model.dart';
import '../services/supabase_service.dart';

class FlightRepository {
  // Get flight by ID
  Future<FlightModel?> getFlightById(String flightId) async {
    try {
      final response = await SupabaseService.from('flights')
          .select()
          .eq('id', flightId)
          .maybeSingle();
      
      if (response != null) {
        return FlightModel.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Update flight status
  Future<FlightModel> updateFlightStatus(String flightId, String status) async {
    try {
      final response = await SupabaseService.from('flights')
          .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', flightId)
          .select()
          .single();
      
      return FlightModel.fromJson(response);
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Update flight gate and terminal
  Future<FlightModel> updateFlightGateTerminal(
    String flightId, 
    String? gate, 
    String? terminal
  ) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (gate != null) updateData['gate'] = gate;
      if (terminal != null) updateData['terminal'] = terminal;
      
      final response = await SupabaseService.from('flights')
          .update(updateData)
          .eq('id', flightId)
          .select()
          .single();
      
      return FlightModel.fromJson(response);
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
}
