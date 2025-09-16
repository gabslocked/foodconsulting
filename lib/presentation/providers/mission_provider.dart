import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/models/mission_model.dart';
import '../../data/models/flight_model.dart';
import '../../data/models/accommodation_model.dart';
import '../../data/models/itinerary_model.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/tip_model.dart';
import '../../data/models/destination_model.dart';
import '../../data/models/transport_model.dart';
import '../../data/models/sponsor_model.dart';
import '../../data/models/anuga_model.dart';
import '../../data/models/technical_visit_model.dart';
import '../../data/models/tour_model.dart';
import '../../data/models/attraction_model.dart';
import '../../data/models/hotel_model.dart';
import '../../data/repositories/mission_repository.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/notification_service.dart';

class MissionProvider extends ChangeNotifier {
  final MissionRepository _missionRepository = MissionRepository();
  
  List<MissionSummary> _missions = [];
  MissionModel? _currentMission;
  List<FlightModel> _flights = [];
  List<AccommodationModel> _accommodations = [];
  List<ActivityModel> _activities = [];
  List<TipModel> _tips = [];
  List<DestinationModel> _destinations = [];
  List<TransportModel> _transports = [];
  List<SponsorModel> _sponsors = [];
  List<ItineraryModel> _itineraries = [];
  List<AnugaModel> _anugaItems = [];
  List<TechnicalVisitModel> _technicalVisits = [];
  List<TourModel> _tours = [];
  List<AttractionModel> _attractions = [];
  List<HotelModel> _hotels = [];
  
  bool _isLoading = false;
  bool _isLoadingDetails = false;
  String? _error;
  
  StreamSubscription? _missionSubscription;
  
  // Getters
  List<MissionSummary> get missions => _missions;
  MissionModel? get currentMission => _currentMission;
  List<FlightModel> get flights => _flights;
  List<AccommodationModel> get accommodations => _accommodations;
  List<ItineraryModel> get itineraries => _itineraries;
  List<ActivityModel> get activities => _activities;
  List<TipModel> get tips => _tips;
  List<DestinationModel> get destinations => _destinations;
  List<TransportModel> get transports => _transports;
  List<SponsorModel> get sponsors => _sponsors;
  List<AnugaModel> get anugaItems => _anugaItems;
  List<TechnicalVisitModel> get technicalVisits => _technicalVisits;
  List<TourModel> get tours => _tours;
  List<AttractionModel> get attractions => _attractions;
  List<HotelModel> get hotels => _hotels;
  
  bool get isLoading => _isLoading;
  bool get isLoadingDetails => _isLoadingDetails;
  String? get error => _error;
  
  // Load user missions
  Future<void> loadUserMissions() async {
    _setLoading(true);
    _clearError();
    
    try {
      _missions = await _missionRepository.getUserMissions();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  // Load mission details
  Future<void> loadMissionDetails(String missionId) async {
    _setLoadingDetails(true);
    _clearError();
    
    try {
      debugPrint('Loading mission details for: $missionId');
      
      // Load mission basic info
      _currentMission = await _missionRepository.getMissionDetails(missionId);
      debugPrint('Mission loaded: ${_currentMission?.name}');
      
      // Load related data in parallel
      debugPrint('Loading related data...');
      
      // Load each data type individually to identify which one fails
      debugPrint('Loading flights...');
      final flights = await _missionRepository.getUserFlights(missionId);
      debugPrint('Flights loaded: ${flights.length}');
      
      debugPrint('Loading accommodations...');
      final accommodations = await _missionRepository.getUserAccommodations(missionId);
      debugPrint('Accommodations loaded: ${accommodations.length}');
      
      debugPrint('Loading activities...');
      final activities = await _missionRepository.getMissionActivities(missionId);
      debugPrint('Activities loaded: ${activities.length}');
      
      debugPrint('Loading tips...');
      final tips = await _missionRepository.getMissionTips(missionId);
      debugPrint('Tips loaded: ${tips.length}');
      
      // Assign loaded data to provider variables
      _flights = flights;
      _accommodations = accommodations;
      _activities = activities;
      _tips = tips;
      
      debugPrint('Loading itineraries...');
      await loadItineraries(missionId);
      await loadAnugaItems(missionId);
      
      debugPrint('Loading technical visits...');
      await loadTechnicalVisits(missionId);
      
      debugPrint('Loading tours...');
      await loadTours(missionId);
      
      debugPrint('Loading attractions...');
      await loadAttractions(missionId);
      
      debugPrint('Loading hotels...');
      await loadHotels(missionId);
      
      debugPrint('Loading destinations...');
      _destinations = await _loadDestinations(missionId);
      debugPrint('Destinations loaded: ${_destinations.length}');
      
      debugPrint('Loading transports...');
      _transports = await _loadTransports(missionId);
      debugPrint('Transports loaded: ${_transports.length}');
      
      debugPrint('Loading sponsors...');
      _sponsors = await _loadSponsors(missionId);
      debugPrint('Sponsors loaded: ${_sponsors.length}');
      
      debugPrint('Data loaded - Flights: ${_flights.length}, Accommodations: ${_accommodations.length}, Itineraries: ${_itineraries.length}, Activities: ${_activities.length}, Tips: ${_tips.length}, Transports: ${_transports.length}, Destinations: ${_destinations.length}, Sponsors: ${_sponsors.length}');
      
      // Subscribe to real-time updates
      _subscribeToMissionUpdates(missionId);
      
      // Subscribe to mission notifications
      await NotificationService.subscribeToMission(missionId);
      
      _setLoadingDetails(false);
      debugPrint('Mission details loaded successfully');
    } catch (e) {
      _setError('Erro ao carregar detalhes da missão: $e');
    } finally {
      _setLoadingDetails(false);
    }
  }
  
  
  // Filter activities by category
  List<ActivityModel> getActivitiesByCategory(String category) {
    return _activities.where((activity) => activity.category == category).toList();
  }
  
  // Filter tips by category
  List<TipModel> getTipsByCategory(String category) {
    return _tips.where((tip) => tip.category == category).toList();
  }
  
  // Group itineraries by date
  Map<DateTime, List<ItineraryModel>> getGroupedItineraries() {
    final grouped = <DateTime, List<ItineraryModel>>{};
    
    for (final itinerary in _itineraries) {
      final date = DateTime(
        itinerary.date.year,
        itinerary.date.month,
        itinerary.date.day,
      );
      
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(itinerary);
    }
    
    return grouped;
  }
  
  // Subscribe to real-time mission updates
  void _subscribeToMissionUpdates(String missionId) {
    _missionSubscription?.cancel();
    
    _missionSubscription = SupabaseService.client
        .from('missions')
        .stream(primaryKey: ['id'])
        .eq('id', missionId)
        .listen((List<Map<String, dynamic>> data) {
          if (data.isNotEmpty) {
            _currentMission = MissionModel.fromJson(data.first);
            notifyListeners();
          }
        });
  }
  
  // Refresh mission data
  Future<void> refreshMissionData() async {
    if (_currentMission != null) {
      await loadMissionDetails(_currentMission!.id);
    }
  }
  
  // Load destinations for mission
  Future<List<DestinationModel>> _loadDestinations(String missionId) async {
    try {
      final response = await SupabaseService.client
          .from('destinations')
          .select()
          .eq('mission_id', missionId)
          .order('display_order', ascending: true);
      
      return (response as List)
          .map((json) => DestinationModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error loading destinations: $e');
      return [];
    }
  }

  // Load transports for mission
  Future<List<TransportModel>> _loadTransports(String missionId) async {
    try {
      final response = await SupabaseService.client
          .from('transports')
          .select()
          .eq('mission_id', missionId);
      
      return (response as List)
          .map((json) => TransportModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error loading transports: $e');
      return [];
    }
  }

  // Load sponsors for mission
  Future<List<SponsorModel>> _loadSponsors(String missionId) async {
    try {
      final response = await SupabaseService.client
          .from('sponsors')
          .select()
          .eq('mission_id', missionId)
          .eq('is_active', true)
          .order('display_order');
      
      return (response as List)
          .map((json) => SponsorModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error loading sponsors: $e');
      return [];
    }
  }

  // Get mission participants
  Future<List<Map<String, dynamic>>> getMissionParticipants(String missionId) async {
    try {
      debugPrint('🔄 Loading mission participants for: $missionId');
      
      // Get participant user IDs from mission_participants table
      final participantsResponse = await SupabaseService.client
          .from('mission_participants')
          .select('user_id')
          .eq('mission_id', missionId)
          .eq('status', 'confirmed');
      
      debugPrint('📋 Found ${(participantsResponse as List).length} confirmed participants');
      
      if ((participantsResponse as List).isEmpty) {
        debugPrint('⚠️ No confirmed participants found for mission $missionId');
        return [];
      }
      
      // Extract user IDs
      final userIds = (participantsResponse as List)
          .map((item) => item['user_id'] as String)
          .toList();
      
      // Get all profiles and filter for participants
      final profilesResponse = await SupabaseService.client
          .from('profiles')
          .select('id, full_name, email, phone, company, avatar_url');
      
      // Filter to get only participants with existing profiles
      final participantProfiles = (profilesResponse as List)
          .where((profile) => userIds.contains(profile['id']))
          .toList();
      
      // Sort participants alphabetically by full_name
      participantProfiles.sort((a, b) => 
          (a['full_name'] as String).compareTo(b['full_name'] as String));
      
      debugPrint('✅ Loaded ${participantProfiles.length} participant profiles (sorted alphabetically)');
      
      return participantProfiles.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('💥 Error loading mission participants: $e');
      return [];
    }
  }

  // Clear current mission data
  void clearCurrentMission() {
    _currentMission = null;
    _flights.clear();
    _accommodations.clear();
    _itineraries.clear();
    _activities.clear();
    _itineraries.clear();
    _anugaItems.clear();
    _destinations.clear();
    _transports.clear();
    _sponsors.clear();
    _missionSubscription?.cancel();
    notifyListeners();
  }

  // Load itineraries for a mission
  Future<void> loadItineraries(String missionId) async {
    try {
      debugPrint('Loading itineraries for mission: $missionId');
      
      final response = await SupabaseService.client
          .from('itineraries')
          .select()
          .eq('mission_id', missionId)
          .order('date', ascending: true)
          .order('start_time', ascending: true);
      
      debugPrint('Itineraries response: $response');
      
      _itineraries = (response as List)
          .map((json) => ItineraryModel.fromJson(json))
          .toList();
      
      debugPrint('Itineraries loaded: ${_itineraries.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading itineraries: $e');
      _setError('Erro ao carregar itinerários: $e');
    }
  }

  // Load ANUGA items for a mission
  Future<void> loadAnugaItems(String missionId) async {
    try {
      debugPrint('Loading ANUGA items for mission: $missionId');
      
      final response = await SupabaseService.client
          .from('anuga')
          .select()
          .eq('mission_id', missionId)
          .eq('is_active', true)
          .order('display_order', ascending: true);
      
      debugPrint('ANUGA response: $response');
      
      _anugaItems = (response as List)
          .map((json) => AnugaModel.fromJson(json))
          .toList();
      
      debugPrint('ANUGA items loaded: ${_anugaItems.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading ANUGA items: $e');
      _setError('Erro ao carregar informações da ANUGA: $e');
    }
  }

  // Load technical visits for a mission
  Future<void> loadTechnicalVisits(String missionId) async {
    try {
      debugPrint('Loading technical visits for mission: $missionId');
      
      final response = await SupabaseService.client
          .from('technical_visits')
          .select()
          .eq('mission_id', missionId)
          .eq('is_active', true)
          .order('display_order', ascending: true);
      
      debugPrint('Technical visits response: $response');
      
      _technicalVisits = (response as List)
          .map((json) => TechnicalVisitModel.fromJson(json))
          .toList();
      
      debugPrint('Technical visits loaded: ${_technicalVisits.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading technical visits: $e');
      _setError('Erro ao carregar visitas técnicas: $e');
    }
  }

  // Load tours for a mission
  Future<void> loadTours(String missionId) async {
    try {
      debugPrint('Loading tours for mission: $missionId');
      
      final response = await SupabaseService.client
          .from('tours')
          .select()
          .eq('mission_id', missionId)
          .eq('is_active', true)
          .order('display_order', ascending: true);
      
      debugPrint('Tours response: $response');
      
      _tours = (response as List)
          .map((json) => TourModel.fromJson(json))
          .toList();
      
      debugPrint('Tours loaded: ${_tours.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tours: $e');
      _setError('Erro ao carregar tours: $e');
    }
  }

  // Load attractions for a mission
  Future<void> loadAttractions(String missionId) async {
    try {
      debugPrint('Loading attractions for mission: $missionId');
      
      final response = await SupabaseService.client
          .from('attractions')
          .select()
          .eq('mission_id', missionId)
          .eq('is_active', true)
          .order('display_order', ascending: true);
      
      debugPrint('Attractions response: $response');
      
      _attractions = (response as List)
          .map((json) => AttractionModel.fromJson(json))
          .toList();
      
      debugPrint('Attractions loaded: ${_attractions.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading attractions: $e');
      _setError('Erro ao carregar atrações: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setLoadingDetails(bool loading) {
    _isLoadingDetails = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
  
  void clearError() {
    _clearError();
  }
  
  // Load hotels from dedicated table
  Future<void> loadHotels(String missionId) async {
    try {
      debugPrint('Loading hotels for mission: $missionId');
      final response = await SupabaseService.client
          .from('hotels')
          .select('*')
          .eq('mission_id', missionId)
          .order('display_order');
      
      debugPrint('Hotels response: $response');
      
      _hotels = (response as List)
          .map((json) => HotelModel.fromJson(json))
          .toList();
      
      debugPrint('Hotels loaded: ${_hotels.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading hotels: $e');
      _setError('Erro ao carregar hotéis: $e');
    }
  }

  @override
  void dispose() {
    _missionSubscription?.cancel();
    super.dispose();
  }
}
