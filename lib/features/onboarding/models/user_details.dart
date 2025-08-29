class UserDetails {
  final String firstName;
  final String lastName;
  final String address1;
  final String city;
  final String state;
  final String? companyName;
  final String postcode;
  final String country;

  UserDetails({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.state,
    this.companyName,
    required this.postcode,
    required this.country,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      firstName: json['firstname'] as String? ?? '',
      lastName: json['lastname'] as String? ?? '',
      address1: json['address1'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      companyName: json['company_name'] as String?,
      postcode: json['postcode'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'address1': address1,
      'city': city,
      'state': state,
      'company_name': companyName,
      'postcode': postcode,
      'country': country,
    };
  }

  UserDetails copyWith({
    String? firstName,
    String? lastName,
    String? address1,
    String? city,
    String? state,
    String? companyName,
    String? postcode,
    String? country,
  }) {
    return UserDetails(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address1: address1 ?? this.address1,
      city: city ?? this.city,
      state: state ?? this.state,
      companyName: companyName ?? this.companyName,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
    );
  }

  @override
  String toString() {
    return 'UserDetails(firstName: $firstName, lastName: $lastName, address1: $address1, city: $city, state: $state, companyName: $companyName, postcode: $postcode, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserDetails &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.address1 == address1 &&
        other.city == city &&
        other.state == state &&
        other.companyName == companyName &&
        other.postcode == postcode &&
        other.country == country;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        address1.hashCode ^
        city.hashCode ^
        state.hashCode ^
        companyName.hashCode ^
        postcode.hashCode ^
        country.hashCode;
  }
}
