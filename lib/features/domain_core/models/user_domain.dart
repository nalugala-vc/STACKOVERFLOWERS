class UserDomain {
  final int id;
  final int userId;
  final int orderId;
  final String regType;
  final String domainName;
  final String registrar;
  final int regPeriod;
  final String firstPaymentAmount;
  final String recurringAmount;
  final String paymentMethod;
  final String paymentMethodName;
  final DateTime regDate;
  final DateTime? expiryDate;
  final DateTime nextDueDate;
  final String status;
  final String subscriptionId;
  final int promoId;
  final bool dnsManagement;
  final bool emailForwarding;
  final bool idProtection;
  final bool doNotRenew;
  final String notes;

  UserDomain({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.regType,
    required this.domainName,
    required this.registrar,
    required this.regPeriod,
    required this.firstPaymentAmount,
    required this.recurringAmount,
    required this.paymentMethod,
    required this.paymentMethodName,
    required this.regDate,
    this.expiryDate,
    required this.nextDueDate,
    required this.status,
    required this.subscriptionId,
    required this.promoId,
    required this.dnsManagement,
    required this.emailForwarding,
    required this.idProtection,
    required this.doNotRenew,
    required this.notes,
  });

  // Computed properties
  bool get isActive => status.toLowerCase() == 'active';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isExpired => status.toLowerCase() == 'expired';

  // For backward compatibility
  String get name => domainName;
  DateTime get purchaseDate => regDate;
  double get renewalPrice => double.tryParse(recurringAmount) ?? 0.0;

  // Additional properties for backward compatibility
  List<String> get nameservers => []; // Will be populated from API
  List<String> get privateNameservers => []; // Empty by default
  bool get registrarLock => true; // Default to true

  factory UserDomain.fromJson(Map<String, dynamic> json) {
    return UserDomain(
      id: json['id'] ?? 0,
      userId: json['userid'] ?? 0,
      orderId: json['orderid'] ?? 0,
      regType: json['regtype'] ?? '',
      domainName: json['domainname'] ?? '',
      registrar: json['registrar'] ?? '',
      regPeriod: json['regperiod'] ?? 0,
      firstPaymentAmount: json['firstpaymentamount'] ?? '0.00',
      recurringAmount: json['recurringamount'] ?? '0.00',
      paymentMethod: json['paymentmethod'] ?? '',
      paymentMethodName: json['paymentmethodname'] ?? '',
      regDate: DateTime.tryParse(json['regdate'] ?? '') ?? DateTime.now(),
      expiryDate:
          json['expirydate'] != null && json['expirydate'] != '0000-00-00'
              ? DateTime.tryParse(json['expirydate'])
              : null,
      nextDueDate:
          DateTime.tryParse(json['nextduedate'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? '',
      subscriptionId: json['subscriptionid'] ?? '',
      promoId: json['promoid'] ?? 0,
      dnsManagement: json['dnsmanagement'] == 1,
      emailForwarding: json['emailforwarding'] == 1,
      idProtection: json['idprotection'] == 1,
      doNotRenew: json['donotrenew'] == 1,
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userid': userId,
      'orderid': orderId,
      'regtype': regType,
      'domainname': domainName,
      'registrar': registrar,
      'regperiod': regPeriod,
      'firstpaymentamount': firstPaymentAmount,
      'recurringamount': recurringAmount,
      'paymentmethod': paymentMethod,
      'paymentmethodname': paymentMethodName,
      'regdate': regDate.toIso8601String(),
      'expirydate': expiryDate?.toIso8601String(),
      'nextduedate': nextDueDate.toIso8601String(),
      'status': status,
      'subscriptionid': subscriptionId,
      'promoid': promoId,
      'dnsmanagement': dnsManagement ? 1 : 0,
      'emailforwarding': emailForwarding ? 1 : 0,
      'idprotection': idProtection ? 1 : 0,
      'donotrenew': doNotRenew ? 1 : 0,
      'notes': notes,
    };
  }

  // Dummy data generator for backward compatibility
  static List<UserDomain> getDummyDomains() {
    return [
      UserDomain(
        id: 1,
        userId: 8,
        orderId: 67,
        regType: 'Register',
        domainName: 'example.com',
        registrar: 'COCCAepp',
        regPeriod: 1,
        firstPaymentAmount: '12.99',
        recurringAmount: '12.99',
        paymentMethod: 'mpesa',
        paymentMethodName: 'M-Pesa',
        regDate: DateTime(2023, 1, 15),
        expiryDate: DateTime(2024, 1, 15),
        nextDueDate: DateTime(2024, 1, 15),
        status: 'Active',
        subscriptionId: '',
        promoId: 0,
        dnsManagement: true,
        emailForwarding: true,
        idProtection: true,
        doNotRenew: false,
        notes: '',
      ),
      UserDomain(
        id: 2,
        userId: 8,
        orderId: 69,
        regType: 'Register',
        domainName: 'mydomain.net',
        registrar: 'COCCAepp',
        regPeriod: 1,
        firstPaymentAmount: '14.99',
        recurringAmount: '14.99',
        paymentMethod: 'mpesa',
        paymentMethodName: 'M-Pesa',
        regDate: DateTime(2023, 6, 1),
        expiryDate: DateTime(2024, 6, 1),
        nextDueDate: DateTime(2024, 6, 1),
        status: 'Active',
        subscriptionId: '',
        promoId: 0,
        dnsManagement: false,
        emailForwarding: false,
        idProtection: false,
        doNotRenew: false,
        notes: '',
      ),
    ];
  }
}

// API Response Model
class UserDomainsResponse {
  final String result;
  final String clientId;
  final String domainId;
  final int totalResults;
  final int startNumber;
  final int numReturned;
  final List<UserDomain> domains;

  UserDomainsResponse({
    required this.result,
    required this.clientId,
    required this.domainId,
    required this.totalResults,
    required this.startNumber,
    required this.numReturned,
    required this.domains,
  });

  factory UserDomainsResponse.fromJson(Map<String, dynamic> json) {
    final domainsData = json['domains'] as Map<String, dynamic>?;
    final domainList = domainsData?['domain'] as List<dynamic>? ?? [];

    return UserDomainsResponse(
      result: json['result'] ?? '',
      clientId: json['clientid'] ?? '',
      domainId: json['domainid'] ?? '',
      totalResults: json['totalresults'] ?? 0,
      startNumber: json['startnumber'] ?? 0,
      numReturned: json['numreturned'] ?? 0,
      domains: domainList.map((domain) => UserDomain.fromJson(domain)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'clientid': clientId,
      'domainid': domainId,
      'totalresults': totalResults,
      'startnumber': startNumber,
      'numreturned': numReturned,
      'domains': {'domain': domains.map((domain) => domain.toJson()).toList()},
    };
  }
}

// Nameservers Response Model
class NameserversResponse {
  final bool success;
  final String message;
  final NameserversData data;

  NameserversResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NameserversResponse.fromJson(Map<String, dynamic> json) {
    return NameserversResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: NameserversData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class NameserversData {
  final String domainId;
  final List<String> nameservers;
  final int count;

  NameserversData({
    required this.domainId,
    required this.nameservers,
    required this.count,
  });

  factory NameserversData.fromJson(Map<String, dynamic> json) {
    return NameserversData(
      domainId: json['domainid']?.toString() ?? '',
      nameservers: List<String>.from(json['nameservers'] ?? []),
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'domainid': domainId, 'nameservers': nameservers, 'count': count};
  }
}

// EPP Code Response Model
class EppCodeResponse {
  final bool success;
  final String message;
  final String data;

  EppCodeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EppCodeResponse.fromJson(Map<String, dynamic> json) {
    return EppCodeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data};
  }
}

// Nameserver Update Request Model
class NameserverUpdateRequest {
  final int domainId;
  final String? ns1;
  final String? ns2;
  final String? ns3;
  final String? ns4;
  final String? ns5;

  NameserverUpdateRequest({
    required this.domainId,
    required this.ns1,
    required this.ns2,
    this.ns3,
    this.ns4,
    this.ns5,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'domainid': domainId};

    if (ns1 != null && ns1!.isNotEmpty) data['ns1'] = ns1;
    if (ns2 != null && ns2!.isNotEmpty) data['ns2'] = ns2;
    if (ns3 != null && ns3!.isNotEmpty) data['ns3'] = ns3;
    if (ns4 != null && ns4!.isNotEmpty) data['ns4'] = ns4;
    if (ns5 != null && ns5!.isNotEmpty) data['ns5'] = ns5;

    return data;
  }

  // Validate that required nameservers are provided
  bool get isValid {
    return ns1 != null && ns1!.isNotEmpty && ns2 != null && ns2!.isNotEmpty;
  }

  // Get all non-empty nameservers
  List<String> get allNameservers {
    final List<String> servers = [];
    if (ns1 != null && ns1!.isNotEmpty) servers.add(ns1!);
    if (ns2 != null && ns2!.isNotEmpty) servers.add(ns2!);
    if (ns3 != null && ns3!.isNotEmpty) servers.add(ns3!);
    if (ns4 != null && ns4!.isNotEmpty) servers.add(ns4!);
    if (ns5 != null && ns5!.isNotEmpty) servers.add(ns5!);
    return servers;
  }
}
