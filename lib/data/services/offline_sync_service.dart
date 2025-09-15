import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../models/mission_model.dart';
import '../models/flight_model.dart';
import '../models/accommodation_model.dart';
import '../models/itinerary_model.dart';
import '../models/activity_model.dart';
import '../models/tip_model.dart';
import 'supabase_service.dart';

class OfflineSyncService {
  static const String _missionCacheKey = 'cached_missions';
  static const String _flightCacheKey = 'cached_flights';
  static const String _accommodationCacheKey = 'cached_accommodations';
  static const String _itineraryCacheKey = 'cached_itineraries';
  static const String _activitiesCacheKey = 'cached_activities';
  static const String _tipsCacheKey = 'cached_tips';
  static const String _lastSyncKey = 'last_sync_timestamp';
  
  // Cache mission data
  static Future<void> cacheMissionData(MissionModel mission) async {
    final prefs = await SharedPreferences.getInstance();
    final missionsJson = prefs.getString(_missionCacheKey) ?? '{}';
    final missions = json.decode(missionsJson) as Map<String, dynamic>;
    
    missions[mission.id] = mission.toJson();
    
    await prefs.setString(_missionCacheKey, json.encode(missions));
    await _updateLastSyncTimestamp();
  }
  
  // Cache flight data
  static Future<void> cacheFlightData(List<FlightModel> flights) async {
    final prefs = await SharedPreferences.getInstance();
    final flightsJson = prefs.getString(_flightCacheKey) ?? '{}';
    final cachedFlights = json.decode(flightsJson) as Map<String, dynamic>;
    
    for (final flight in flights) {
      cachedFlights[flight.id] = flight.toJson();
    }
    
    await prefs.setString(_flightCacheKey, json.encode(cachedFlights));
  }
  
  // Cache accommodation data
  static Future<void> cacheAccommodationData(List<AccommodationModel> accommodations) async {
    final prefs = await SharedPreferences.getInstance();
    final accommodationsJson = prefs.getString(_accommodationCacheKey) ?? '{}';
    final cachedAccommodations = json.decode(accommodationsJson) as Map<String, dynamic>;
    
    for (final accommodation in accommodations) {
      cachedAccommodations[accommodation.id] = accommodation.toJson();
    }
    
    await prefs.setString(_accommodationCacheKey, json.encode(cachedAccommodations));
  }
  
  // Cache itinerary data
  static Future<void> cacheItineraryData(List<ItineraryModel> itineraries) async {
    final prefs = await SharedPreferences.getInstance();
    final itinerariesJson = prefs.getString(_itineraryCacheKey) ?? '{}';
    final cachedItineraries = json.decode(itinerariesJson) as Map<String, dynamic>;
    
    for (final itinerary in itineraries) {
      cachedItineraries[itinerary.id] = itinerary.toJson();
    }
    
    await prefs.setString(_itineraryCacheKey, json.encode(cachedItineraries));
  }
  
  // Cache activities data
  static Future<void> cacheActivitiesData(List<ActivityModel> activities) async {
    final prefs = await SharedPreferences.getInstance();
    final activitiesJson = prefs.getString(_activitiesCacheKey) ?? '{}';
    final cachedActivities = json.decode(activitiesJson) as Map<String, dynamic>;
    
    for (final activity in activities) {
      cachedActivities[activity.id] = activity.toJson();
    }
    
    await prefs.setString(_activitiesCacheKey, json.encode(cachedActivities));
  }
  
  // Cache tips data
  static Future<void> cacheTipsData(List<TipModel> tips) async {
    final prefs = await SharedPreferences.getInstance();
    final tipsJson = prefs.getString(_tipsCacheKey) ?? '{}';
    final cachedTips = json.decode(tipsJson) as Map<String, dynamic>;
    
    for (final tip in tips) {
      cachedTips[tip.id] = tip.toJson();
    }
    
    await prefs.setString(_tipsCacheKey, json.encode(cachedTips));
  }
  
  // Get cached mission
  static Future<MissionModel?> getCachedMission(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    final missionsJson = prefs.getString(_missionCacheKey) ?? '{}';
    final missions = json.decode(missionsJson) as Map<String, dynamic>;
    
    if (missions.containsKey(missionId)) {
      return MissionModel.fromJson(missions[missionId]);
    }
    return null;
  }
  
  // Get cached flights for mission
  static Future<List<FlightModel>> getCachedFlights(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    final flightsJson = prefs.getString(_flightCacheKey) ?? '{}';
    final flights = json.decode(flightsJson) as Map<String, dynamic>;
    
    final missionFlights = <FlightModel>[];
    for (final flightData in flights.values) {
      final flight = FlightModel.fromJson(flightData);
      if (flight.missionId == missionId) {
        missionFlights.add(flight);
      }
    }
    
    return missionFlights;
  }
  
  // Get cached accommodations for mission
  static Future<List<AccommodationModel>> getCachedAccommodations(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    final accommodationsJson = prefs.getString(_accommodationCacheKey) ?? '{}';
    final accommodations = json.decode(accommodationsJson) as Map<String, dynamic>;
    
    final missionAccommodations = <AccommodationModel>[];
    for (final accommodationData in accommodations.values) {
      final accommodation = AccommodationModel.fromJson(accommodationData);
      if (accommodation.missionId == missionId) {
        missionAccommodations.add(accommodation);
      }
    }
    
    return missionAccommodations;
  }
  
  // Check connectivity
  static Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  
  // Sync with server when online
  static Future<void> syncWithServer() async {
    if (!await isOnline()) {
      debugPrint('No internet connection, skipping sync');
      return;
    }
    
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) return;
      
      // Fetch latest data from server
      await _refreshAllMissions(userId);
      
      debugPrint('Sync completed successfully');
    } catch (e) {
      debugPrint('Sync failed: $e');
    }
  }
  
  static Future<void> _refreshAllMissions(String userId) async {
    try {
      // Fetch user missions
      final missionsResponse = await SupabaseService.from('user_missions_summary')
          .select()
          .eq('user_id', userId);
      
      // Cache each mission's detailed data
      for (final missionData in missionsResponse) {
        final missionId = missionData['mission_id'] as String;
        
        // Fetch detailed mission data
        final detailResponse = await SupabaseService.from('user_mission_details_json')
            .select()
            .eq('mission_id', missionId)
            .eq('user_id', userId)
            .maybeSingle();
        
        if (detailResponse != null) {
          // Parse and cache the data
          // This would need to be implemented based on the actual JSON structure
          // from the Supabase views
        }
      }
      
      await _updateLastSyncTimestamp();
    } catch (e) {
      debugPrint('Error refreshing missions: $e');
      rethrow;
    }
  }
  
  static Future<void> _updateLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
  }
  
  static Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastSyncKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }
  
  // Clear all cached data
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_missionCacheKey);
    await prefs.remove(_flightCacheKey);
    await prefs.remove(_accommodationCacheKey);
    await prefs.remove(_itineraryCacheKey);
    await prefs.remove(_activitiesCacheKey);
    await prefs.remove(_tipsCacheKey);
    await prefs.remove(_lastSyncKey);
  }
}
