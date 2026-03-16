/// Model for customer address.
class CustomerAddress {
  final int? id;
  final String street;
  final String city;
  final String? state;
  final String country;
  final String? postalCode;
  final String type;

  const CustomerAddress({
    this.id,
    required this.street,
    required this.city,
    this.state,
    required this.country,
    this.postalCode,
    required this.type,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      id: json['id'],
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'],
      country: json['country'] ?? '',
      postalCode: json['postalCode'],
      type: json['type'] ?? 'Principal',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'street': street,
        'city': city,
        'state': state,
        'country': country,
        'postalCode': postalCode,
        'type': type,
      };
}

/// Model for customer contact.
class CustomerContact {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String? position;
  final String? documentNumber;
  final DateTime? birthDate;
  final bool? isLegalRepresentative;

  const CustomerContact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.position,
    this.documentNumber,
    this.birthDate,
    this.isLegalRepresentative,
  });

  factory CustomerContact.fromJson(Map<String, dynamic> json) {
    return CustomerContact(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      position: json['position'],
      documentNumber: json['documentNumber'],
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'])
          : null,
      isLegalRepresentative: json['isLegalRepresentative'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'position': position,
        'documentNumber': documentNumber,
        'birthDate': birthDate != null ? '${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}' : null,
        'isLegalRepresentative': isLegalRepresentative,
      };
}

/// Model for the authenticated customer profile.
class CustomerProfile {
  final int id;
  final String name;
  final String documentNumber;
  final String? email;
  final String? phone;
  final String type;
  final String status;
  final List<CustomerAddress> addresses;
  final List<CustomerContact> contacts;

  const CustomerProfile({
    required this.id,
    required this.name,
    required this.documentNumber,
    this.email,
    this.phone,
    required this.type,
    required this.status,
    this.addresses = const [],
    this.contacts = const [],
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json['id'],
      name: json['name'],
      documentNumber: json['documentNumber'],
      email: json['email'],
      phone: json['phone'],
      type: json['type'] ?? 'NATURAL',
      status: json['status'] ?? 'ACTIVE',
      addresses: (json['addresses'] as List?)
              ?.map((e) => CustomerAddress.fromJson(e))
              .toList() ??
          [],
      contacts: (json['contacts'] as List?)
              ?.map((e) => CustomerContact.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'documentNumber': documentNumber,
        'email': email,
        'phone': phone,
        'type': type,
        'status': status,
        'addresses': addresses.map((e) => e.toJson()).toList(),
        'contacts': contacts.map((e) => e.toJson()).toList(),
      };
}

/// Login response model.
class LoginResult {
  final String token;
  final String refreshToken;
  final int expiresIn;
  final CustomerProfile customer;

  const LoginResult({
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
    required this.customer,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      token: json['token'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
      customer: CustomerProfile.fromJson(json['customer']),
    );
  }
}
