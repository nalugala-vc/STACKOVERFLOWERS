class Domain {
  final String name;
  final String extension;
  final bool isAvailable;
  final double price;
  final String? description;
  final DateTime? registrationDate;
  final DateTime? expiryDate;
  final WhoisInfo? whoisInfo;
  final bool isInCart;
  final String fullDomainName;

  Domain({
    required this.name,
    required this.extension,
    required this.isAvailable,
    required this.price,
    this.description,
    this.registrationDate,
    this.expiryDate,
    this.whoisInfo,
    this.isInCart = false,
  }) : fullDomainName = '$name$extension';

  Domain copyWith({
    String? name,
    String? extension,
    bool? isAvailable,
    double? price,
    String? description,
    DateTime? registrationDate,
    DateTime? expiryDate,
    WhoisInfo? whoisInfo,
    bool? isInCart,
  }) {
    return Domain(
      name: name ?? this.name,
      extension: extension ?? this.extension,
      isAvailable: isAvailable ?? this.isAvailable,
      price: price ?? this.price,
      description: description ?? this.description,
      registrationDate: registrationDate ?? this.registrationDate,
      expiryDate: expiryDate ?? this.expiryDate,
      whoisInfo: whoisInfo ?? this.whoisInfo,
      isInCart: isInCart ?? this.isInCart,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'extension': extension,
      'isAvailable': isAvailable,
      'price': price,
      'description': description,
      'registrationDate': registrationDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'whoisInfo': whoisInfo?.toJson(),
      'isInCart': isInCart,
    };
  }

  factory Domain.fromJson(Map<String, dynamic> json) {
    return Domain(
      name: json['name'] ?? '',
      extension: json['extension'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      price: (json['price'] ?? 0.0).toDouble(),
      description: json['description'],
      registrationDate:
          json['registrationDate'] != null
              ? DateTime.parse(json['registrationDate'])
              : null,
      expiryDate:
          json['expiryDate'] != null
              ? DateTime.parse(json['expiryDate'])
              : null,
      whoisInfo:
          json['whoisInfo'] != null
              ? WhoisInfo.fromJson(json['whoisInfo'])
              : null,
      isInCart: json['isInCart'] ?? false,
    );
  }
}

class WhoisInfo {
  final String registrant;
  final String registrarName;
  final DateTime registrationDate;
  final DateTime expiryDate;
  final List<String> nameServers;
  final String status;

  WhoisInfo({
    required this.registrant,
    required this.registrarName,
    required this.registrationDate,
    required this.expiryDate,
    required this.nameServers,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'registrant': registrant,
      'registrarName': registrarName,
      'registrationDate': registrationDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'nameServers': nameServers,
      'status': status,
    };
  }

  factory WhoisInfo.fromJson(Map<String, dynamic> json) {
    return WhoisInfo(
      registrant: json['registrant'] ?? '',
      registrarName: json['registrarName'] ?? '',
      registrationDate: DateTime.parse(json['registrationDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      nameServers: List<String>.from(json['nameServers'] ?? []),
      status: json['status'] ?? '',
    );
  }
}

class DomainSuggestion {
  final String keyword;
  final String suggestion;
  final String extension;
  final double price;
  final bool isAvailable;
  final String type; // 'trending', 'ai_generated', 'alternative'

  DomainSuggestion({
    required this.keyword,
    required this.suggestion,
    required this.extension,
    required this.price,
    required this.isAvailable,
    required this.type,
  });

  String get fullDomainName => '$suggestion$extension';

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'suggestion': suggestion,
      'extension': extension,
      'price': price,
      'isAvailable': isAvailable,
      'type': type,
    };
  }

  factory DomainSuggestion.fromJson(Map<String, dynamic> json) {
    return DomainSuggestion(
      keyword: json['keyword'] ?? '',
      suggestion: json['suggestion'] ?? '',
      extension: json['extension'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      isAvailable: json['isAvailable'] ?? false,
      type: json['type'] ?? '',
    );
  }
}
