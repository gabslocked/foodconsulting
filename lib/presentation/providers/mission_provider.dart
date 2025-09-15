import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/models/mission_model.dart';
import '../../data/models/flight_model.dart';
import '../../data/models/accommodation_model.dart';
import '../../data/models/hotel_model.dart';
import '../../data/models/itinerary_model.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/attraction_model.dart';
import '../../data/models/tour_model.dart';
import '../../data/models/technical_visit_model.dart';
import '../../data/models/tip_model.dart';
import '../../data/models/destination_model.dart';
import '../../data/models/transport_model.dart';
import '../../data/models/sponsor_model.dart';
import '../../data/models/anuga_model.dart';
import '../../data/repositories/mission_repository.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/notification_service.dart';

class MissionProvider extends ChangeNotifier {
  final MissionRepository _missionRepository = MissionRepository();
  
  List<MissionSummary> _missions = [];
  MissionModel? _currentMission;
  List<FlightModel> _flights = [];
  List<AccommodationModel> _accommodations = [];
  List<HotelModel> _hotels = [];
  List<ActivityModel> _activities = [];
  List<AttractionModel> _attractions = [];
  List<TourModel> _tours = [];
  List<TechnicalVisitModel> _technicalVisits = [];
  List<TipModel> _tips = [];
  List<DestinationModel> _destinations = [];
  List<TransportModel> _transports = [];
  List<SponsorModel> _sponsors = [];
  List<ItineraryModel> _itineraries = [];
  List<AnugaModel> _anugaItems = [];
  
  bool _isLoading = false;
  bool _isLoadingDetails = false;
  String? _error;
  
  StreamSubscription? _missionSubscription;
  
  // Getters
  List<MissionSummary> get missions => _missions;
  MissionModel? get currentMission => _currentMission;
  List<FlightModel> get flights => _flights;
  List<AccommodationModel> get accommodations => _accommodations;
  List<HotelModel> get hotels => _hotels;
  List<ItineraryModel> get itineraries => _itineraries;
  List<ActivityModel> get activities => _activities;
  List<AttractionModel> get attractions => _attractions;
  List<TourModel> get tours => _tours;
  List<TechnicalVisitModel> get technicalVisits => _technicalVisits;
  List<TipModel> get tips => _tips;
  List<DestinationModel> get destinations => _destinations;
  List<TransportModel> get transports => _transports;
  List<SponsorModel> get sponsors => _sponsors;
  List<AnugaModel> get anugaItems => _anugaItems;
  
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
      
      debugPrint('Loading hotels...');
      final hotels = await _loadHotels(missionId);
      debugPrint('Hotels loaded: ${hotels.length}');
      
      debugPrint('Loading attractions...');
      final attractions = await _loadAttractions(missionId);
      debugPrint('Attractions loaded: ${attractions.length}');
      
      debugPrint('Loading tours...');
      final tours = await _loadTours(missionId);
      debugPrint('Tours loaded: ${tours.length}');
      
      debugPrint('Loading technical visits...');
      final technicalVisits = await _loadTechnicalVisits(missionId);
      debugPrint('Technical visits loaded: ${technicalVisits.length}');
      
      // Assign loaded data to provider variables
      _flights = flights;
      _accommodations = accommodations;
      _activities = activities;
      _attractions = attractions;
      _tours = tours;
      _technicalVisits = technicalVisits;
      _tips = tips;
      _hotels = hotels;
      
      debugPrint('Loading itineraries...');
      await loadItineraries(missionId);
      await loadAnugaItems(missionId);
      
      debugPrint('Loading destinations...');
      _destinations = await _loadDestinations(missionId);
      debugPrint('Destinations loaded: ${_destinations.length}');
      
      debugPrint('Loading transports...');
      _transports = await _loadTransports(missionId);
      debugPrint('Transports loaded: ${_transports.length}');
      
      debugPrint('Loading sponsors...');
      _sponsors = await _loadSponsors(missionId);
      debugPrint('Sponsors loaded: ${_sponsors.length}');
      
      debugPrint('Data loaded - Flights: ${_flights.length}, Accommodations: ${_accommodations.length}, Hotels: ${_hotels.length}, Itineraries: ${_itineraries.length}, Activities: ${_activities.length}, Attractions: ${_attractions.length}, Tours: ${_tours.length}, Technical Visits: ${_technicalVisits.length}, Tips: ${_tips.length}, Transports: ${_transports.length}, Destinations: ${_destinations.length}, Sponsors: ${_sponsors.length}');
      
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
  
  
  // Refresh mission data
  Future<void> refreshMissionData() async {
    if (_currentMission != null) {
      await loadMissionDetails(_currentMission!.id);
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
  
  // Load destinations for mission
  Future<List<DestinationModel>> _loadDestinations(String missionId) async {
    try {
      final response = await SupabaseService.client
          .from('destinations')
          .select()
          .eq('mission_id', missionId);
      
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
      final response = await SupabaseService.client
          .from('mission_participants')
          .select('''
            profiles(
              id,
              full_name,
              email,
              phone,
              company,
              avatar_url
            )
          ''')
          .eq('mission_id', missionId)
          .eq('status', 'confirmed');
      
      debugPrint('Mission participants response: $response');
      
      return (response as List)
          .where((item) => item['profiles'] != null)
          .map((item) => item['profiles'] as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('Error loading mission participants: $e');
      return [];
    }
  }

  // Clear current mission data
  void clearCurrentMission() {
    _currentMission = null;
    _flights.clear();
    _accommodations.clear();
    _hotels.clear();
    _itineraries.clear();
    _activities.clear();
    _attractions.clear();
    _tours.clear();
    _technicalVisits.clear();
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

  // Load hotels for a mission
  Future<List<HotelModel>> _loadHotels(String missionId) async {
    try {
      debugPrint('Loading hotels for mission: $missionId');
      
      final response = await SupabaseService.client
          .from('hotels')
          .select()
          .eq('mission_id', missionId)
          .order('priority', ascending: false)
          .order('category', ascending: true);
      
      debugPrint('Hotels response: $response');
      
      return (response as List)
          .map((json) => HotelModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error loading hotels: $e');
      return [];
    }
  }

  // Load attractions for a mission
  Future<List<AttractionModel>> _loadAttractions(String missionId) async {
    try {
      debugPrint('Loading attractions for mission: $missionId');
      
      final response = await SupabaseService.client
          .from('attractions')
          .select()
          .eq('mission_id', missionId)
          .eq('is_active', true)
          .order('display_order', ascending: true)
          .order('title', ascending: true);
      
      debugPrint('Attractions response: $response');
      
      return (response as List)
          .map((json) => AttractionModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error loading attractions: $e');
      return [];
    }
  }

  // Load tours for a mission
  Future<List<TourModel>> _loadTours(String missionId) async {
    try {
      debugPrint('Loading tours for mission: $missionId');
      
      final response = await SupabaseService.client
          .from('tours')
          .select()
          .eq('mission_id', missionId)
          .eq('is_active', true)
          .order('display_order', ascending: true)
          .order('title', ascending: true);
      
      debugPrint('Tours response: $response');
      
      return (response as List)
          .map((json) => TourModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error loading tours: $e');
      return [];
    }
  }

  // Load technical visits for a mission
  Future<List<TechnicalVisitModel>> _loadTechnicalVisits(String missionId) async {
    try {
      debugPrint('Loading technical visits for mission: $missionId');
      
      final response = await SupabaseService.client
          .from('technical_visits')
          .select()
          .eq('mission_id', missionId)
          .eq('is_active', true)
          .order('display_order', ascending: true)
          .order('title', ascending: true);
      
      debugPrint('Technical visits response: $response');
      
      return (response as List)
          .map((json) => TechnicalVisitModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error loading technical visits: $e');
      return [];
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
  
  @override
  void dispose() {
    _missionSubscription?.cancel();
    super.dispose();
  }
}
