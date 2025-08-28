class UserDomain {
  final String name;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final double renewalPrice;
  final bool isExpired;
  final List<String> nameservers;
  final List<String> privateNameservers;
  final bool registrarLock;

  UserDomain({
    required this.name,
    required this.purchaseDate,
    required this.expiryDate,
    required this.renewalPrice,
    required this.isExpired,
    this.nameservers = const ['ns1.example.com', 'ns2.example.com'],
    this.privateNameservers = const [],
    this.registrarLock = true,
  });

  // Dummy data generator
  static List<UserDomain> getDummyDomains() {
    return [
      UserDomain(
        name: 'example.com',
        purchaseDate: DateTime(2023, 1, 15),
        expiryDate: DateTime(2024, 1, 15),
        renewalPrice: 12.99,
        isExpired: true,
      ),
      UserDomain(
        name: 'mydomain.net',
        purchaseDate: DateTime(2023, 6, 1),
        expiryDate: DateTime(2024, 6, 1),
        renewalPrice: 14.99,
        isExpired: false,
      ),
      UserDomain(
        name: 'businesssite.org',
        purchaseDate: DateTime(2023, 3, 10),
        expiryDate: DateTime(2024, 3, 10),
        renewalPrice: 11.99,
        isExpired: false,
      ),
    ];
  }
}
