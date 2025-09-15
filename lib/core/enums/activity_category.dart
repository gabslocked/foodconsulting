/// Enum para categorizar atividades nas diferentes abas da missão
enum ActivityCategory {
  /// Visitas técnicas - aparecem na aba "Visitas"
  technicalVisit('technical_visit', 'Visita Técnica'),
  
  /// Tours culturais - aparecem na aba "Tours"  
  cultural('cultural', 'Tour Cultural'),
  
  /// Atrações turísticas - aparecem na aba "Atrações"
  attraction('attraction', 'Atração Turística'),
  
  /// Restaurantes - aparecem na aba "Atrações"
  restaurant('restaurant', 'Restaurante'),
  
  /// Atividades de lazer - aparecem na aba "Atrações"
  leisure('leisure', 'Lazer'),
  
  /// Compras - aparecem na aba "Atrações"
  shopping('shopping', 'Compras'),
  
  /// Eventos especiais - aparecem na aba "Atrações"
  event('event', 'Evento');

  const ActivityCategory(this.value, this.displayName);

  /// Valor usado no banco de dados
  final String value;
  
  /// Nome para exibição na UI
  final String displayName;

  /// Categorias que aparecem na aba "Visitas"
  static const List<ActivityCategory> visitCategories = [
    ActivityCategory.technicalVisit,
  ];

  /// Categorias que aparecem na aba "Tours"
  static const List<ActivityCategory> tourCategories = [
    ActivityCategory.cultural,
  ];

  /// Categorias que aparecem na aba "Atrações"
  static const List<ActivityCategory> attractionCategories = [
    ActivityCategory.attraction,
    ActivityCategory.restaurant,
    ActivityCategory.leisure,
    ActivityCategory.shopping,
    ActivityCategory.event,
  ];

  /// Retorna a categoria baseada no valor do banco
  static ActivityCategory? fromValue(String value) {
    for (ActivityCategory category in ActivityCategory.values) {
      if (category.value == value) {
        return category;
      }
    }
    return null;
  }

  /// Verifica se a categoria aparece na aba "Visitas"
  bool get isVisitCategory => visitCategories.contains(this);

  /// Verifica se a categoria aparece na aba "Tours"
  bool get isTourCategory => tourCategories.contains(this);

  /// Verifica se a categoria aparece na aba "Atrações"
  bool get isAttractionCategory => attractionCategories.contains(this);
}
