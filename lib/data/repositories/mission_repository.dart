import 'package:flutter/material.dart';
import '../models/mission_model.dart';
import '../models/flight_model.dart';
import '../models/accommodation_model.dart';
import '../models/itinerary_model.dart';
import '../models/activity_model.dart';
import '../models/tip_model.dart';
import '../services/supabase_service.dart';
import '../services/offline_sync_service.dart';

class MissionRepository {
  // Get user missions summary
  Future<List<MissionSummary>> getUserMissions() async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');
      
      // First get mission IDs for the user
      final participantResponse = await SupabaseService.from('mission_participants')
          .select('mission_id')
          .eq('user_id', userId);
      
      final missionIds = (participantResponse as List)
          .map((item) => item['mission_id'] as String)
          .toList();
      
      if (missionIds.isEmpty) {
        return [];
      }
      
      final response = await SupabaseService.from('missions')
          .select('id, name, country, city, cover_image_url, start_date, end_date, status')
          .inFilter('id', missionIds)
          .order('start_date', ascending: false);
      
      debugPrint('Mission query response: $response');
      
      final missions = (response as List)
          .map((json) {
            debugPrint('Processing mission JSON: $json');
            return MissionSummary.fromJson(json);
          })
          .toList();
      
      return missions;
    } catch (e) {
      debugPrint('Error in getUserMissions: $e');
      debugPrint('Error type: ${e.runtimeType}');
      // Try to get from cache if offline
      if (!await OfflineSyncService.isOnline()) {
        // Return cached data if available
        return [];
      }
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Get mission details
  Future<MissionModel?> getMissionDetails(String missionId) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');
      
      final response = await SupabaseService.from('missions')
          .select()
          .eq('id', missionId)
          .maybeSingle();
      
      debugPrint('Mission details response: $response');
      
      if (response != null) {
        debugPrint('Processing mission details JSON: $response');
        final mission = MissionModel.fromJson(response);
        await OfflineSyncService.cacheMissionData(mission);
        return mission;
      }
      return null;
    } catch (e) {
      debugPrint('Error in getMissionDetails: $e');
      debugPrint('Error type: ${e.runtimeType}');
      // Try to get from cache if offline
      if (!await OfflineSyncService.isOnline()) {
        return await OfflineSyncService.getCachedMission(missionId);
      }
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Get user flights for mission
  Future<List<FlightModel>> getUserFlights(String missionId) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');
      
      final response = await SupabaseService.from('flights')
          .select()
          .eq('user_id', userId)
          .eq('mission_id', missionId)
          .order('departure_time', ascending: true);
      
      final flights = (response as List)
          .map((json) => FlightModel.fromJson(json))
          .toList();
      
      await OfflineSyncService.cacheFlightData(flights);
      return flights;
    } catch (e) {
      // Try to get from cache if offline
      if (!await OfflineSyncService.isOnline()) {
        return await OfflineSyncService.getCachedFlights(missionId);
      }
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Get user accommodations for mission
  Future<List<AccommodationModel>> getUserAccommodations(String missionId) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');
      
      final response = await SupabaseService.from('accommodations')
          .select()
          .eq('user_id', userId)
          .eq('mission_id', missionId)
          .order('check_in_date', ascending: true);
      
      final accommodations = (response as List)
          .map((json) => AccommodationModel.fromJson(json))
          .toList();
      
      await OfflineSyncService.cacheAccommodationData(accommodations);
      return accommodations;
    } catch (e) {
      // Try to get from cache if offline
      if (!await OfflineSyncService.isOnline()) {
        return await OfflineSyncService.getCachedAccommodations(missionId);
      }
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Get mission itinerary
  Future<List<ItineraryModel>> getMissionItinerary(String missionId) async {
    try {
      final response = await SupabaseService.from('itineraries')
          .select()
          .eq('mission_id', missionId)
          .order('date', ascending: true)
          .order('start_time', ascending: true);
      
      final itineraries = (response as List)
          .map((json) => ItineraryModel.fromJson(json))
          .toList();
      
      await OfflineSyncService.cacheItineraryData(itineraries);
      return itineraries;
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Get mission activities
  Future<List<ActivityModel>> getMissionActivities(String missionId, {String? category}) async {
    try {
      var query = SupabaseService.from('activities')
          .select()
          .eq('mission_id', missionId);
      
      if (category != null) {
        query = query.eq('category', category);
      }
      
      final response = await query.order('title', ascending: true);
      
      final activities = (response as List)
          .map((json) => ActivityModel.fromJson(json))
          .toList();
      
      await OfflineSyncService.cacheActivitiesData(activities);
      return activities;
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Get mission tips
  Future<List<TipModel>> getMissionTips(String missionId, {String? category}) async {
    try {
      var query = SupabaseService.from('tips')
          .select()
          .eq('mission_id', missionId);
      
      if (category != null) {
        query = query.eq('category', category);
      }
      
      final response = await query.order('priority', ascending: false);
      
      final tips = (response as List)
          .map((json) => TipModel.fromJson(json))
          .toList();
      
      await OfflineSyncService.cacheTipsData(tips);
      return tips;
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Get upcoming activities for user
  Future<List<ItineraryModel>> getUpcomingActivities() async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');
      
      debugPrint('Getting upcoming activities for user: $userId');
      
      // Get missions where user is a participant
      final userMissions = await SupabaseService.client
          .from('mission_participants')
          .select('mission_id')
          .eq('user_id', userId);
      
      debugPrint('User missions found: ${userMissions.length}');
      
      if (userMissions.isEmpty) {
        debugPrint('User has no missions');
        return [];
      }
      
      final missionIds = (userMissions as List)
          .map((m) => m['mission_id'])
          .toList();
      
      debugPrint('Mission IDs: $missionIds');
      
      final response = await SupabaseService.client
          .from('itineraries')
          .select()
          .inFilter('mission_id', missionIds)
          .gte('date', DateTime.now().toIso8601String().split('T')[0])
          .order('date', ascending: true)
          .order('start_time', ascending: true)
          .limit(5);
      
      debugPrint('Itineraries response: ${response.length} items');
      
      return (response as List)
          .map((json) => ItineraryModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error in getUpcomingActivities: $e');
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
}
