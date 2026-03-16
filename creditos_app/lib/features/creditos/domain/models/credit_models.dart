import 'dart:ui';
import 'dart:convert';

/// Credit type model.
class CreditType {
  final int id;
  final String name;
  final String? description;
  final double interestRate;
  final int minTermMonths;
  final int maxTermMonths;
  final double minAmount;
  final double maxAmount;
  final bool active;

  const CreditType({
    required this.id,
    required this.name,
    this.description,
    required this.interestRate,
    required this.minTermMonths,
    required this.maxTermMonths,
    required this.minAmount,
    required this.maxAmount,
    this.active = true,
  });

  factory CreditType.fromJson(Map<String, dynamic> json) {
    return CreditType(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      interestRate: (json['interestRate'] ?? json['interest_rate'] ?? 0).toDouble(),
      minTermMonths: json['minTermMonths'] ?? json['min_term_months'] ?? 1,
      maxTermMonths: json['maxTermMonths'] ?? json['max_term_months'] ?? 60,
      minAmount: (json['minAmount'] ?? json['min_amount'] ?? 0).toDouble(),
      maxAmount: (json['maxAmount'] ?? json['max_amount'] ?? 0).toDouble(),
      active: json['active'] ?? true,
    );
  }
}

/// Credit request model.
class CreditRequest {
  final int id;
  final int applicantUserId;
  final int creditTypeId;
  final String? creditTypeName;
  final double amount;
  final int termMonths;
  final String? purpose;
  final String status;
  final String? createdAt;
  final double? monthlyPayment;
  final double? totalPayment;
  final double? interestRate;
  final DebtorInfo? debtorAdditionalInfo;
  final List<Reference> debtorReferences;
  final List<CoDebtor> coDebtors;
  final List<PreviousCredit> previousCredits;

  const CreditRequest({
    required this.id,
    required this.applicantUserId,
    required this.creditTypeId,
    this.creditTypeName,
    required this.amount,
    required this.termMonths,
    this.purpose,
    required this.status,
    this.createdAt,
    this.monthlyPayment,
    this.totalPayment,
    this.interestRate,
    this.debtorAdditionalInfo,
    this.debtorReferences = const [],
    this.coDebtors = const [],
    this.previousCredits = const [],
  });

  factory CreditRequest.fromJson(Map<String, dynamic> json) {
    DebtorInfo? debtorInfo;
    if (json['debtorAdditionalInfo'] != null) {
      final additionalInfo = json['debtorAdditionalInfo'];
      if (additionalInfo is String && additionalInfo.isNotEmpty) {
        try {
          debtorInfo = DebtorInfo.fromJson(jsonDecode(additionalInfo));
        } catch (_) {}
      } else if (additionalInfo is Map<String, dynamic>) {
        debtorInfo = DebtorInfo.fromJson(additionalInfo);
      }
    }

    return CreditRequest(
      id: json['id'],
      applicantUserId: json['applicantUserId'] ?? 0,
      creditTypeId: json['creditTypeId'] ?? 0,
      creditTypeName: json['creditTypeName'] ?? json['credit_type_name'],
      amount: (json['amount'] ?? 0).toDouble(),
      termMonths: json['termMonths'] ?? json['term_months'] ?? 0,
      purpose: json['purpose'],
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] ?? json['created_at'],
      monthlyPayment: (json['monthlyPayment'] ?? json['monthly_payment'])?.toDouble(),
      totalPayment: (json['totalPayment'] ?? json['total_payment'])?.toDouble(),
      interestRate: (json['interestRate'] ?? json['interest_rate'])?.toDouble(),
      debtorAdditionalInfo: debtorInfo,
      debtorReferences: (json['debtorReferences'] != null)
          ? (json['debtorReferences'] as List)
              .map((r) => Reference.fromJson(r))
              .toList()
          : (json['references'] != null)
              ? (json['references'] as List)
                  .map((r) => Reference.fromJson(r))
                  .toList()
              : [],
      coDebtors: (json['coDebtors'] != null)
          ? (json['coDebtors'] as List)
              .map((c) => CoDebtor.fromJson(c))
              .toList()
          : [],
      previousCredits: (json['previousCredits'] != null)
          ? (json['previousCredits'] as List)
              .map((p) => PreviousCredit.fromJson(p))
              .toList()
          : (json['previous_credits'] != null)
              ? (json['previous_credits'] as List)
                  .map((p) => PreviousCredit.fromJson(p))
                  .toList()
              : [],
    );
  }

  String get statusDisplay {
    switch (status) {
      case 'SUBMITTED':
        return 'Enviada';
      case 'IN_REVIEW':
        return 'En Revisión';
      case 'APPROVED':
        return 'Aprobada';
      case 'REJECTED':
        return 'Rechazada';
      case 'DISBURSED':
        return 'Desembolsada';
      default:
        return 'Pendiente';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'APPROVED':
      case 'DISBURSED':
        return const Color(0xFF4CAF50);
      case 'REJECTED':
        return const Color(0xFFF44336);
      case 'IN_REVIEW':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF2196F3);
    }
  }
}

class DebtorInfo {
  final String documentType;
  final String documentNumber;
  final String documentExpeditionPlace;
  final String birthDate;
  final String street;
  final String neighborhood;
  final String city;
  final String? apartment;
  final bool isEmployed;
  final String? companyName;
  final String? position;
  final int? employmentYears;
  final String? workPhone;
  final String? corporateEmail;
  final String? contractType;
  final String? workAddress;

  const DebtorInfo({
    required this.documentType,
    required this.documentNumber,
    required this.documentExpeditionPlace,
    required this.birthDate,
    required this.street,
    required this.neighborhood,
    required this.city,
    this.apartment,
    required this.isEmployed,
    this.companyName,
    this.position,
    this.employmentYears,
    this.workPhone,
    this.corporateEmail,
    this.contractType,
    this.workAddress,
  });


  factory DebtorInfo.fromJson(Map<String, dynamic> json) {
    return DebtorInfo(
      documentType: json['documentType'] ?? json['document_type'] ?? '',
      documentNumber: json['documentNumber'] ?? json['document_number'] ?? '',
      documentExpeditionPlace: json['documentExpeditionPlace'] ?? json['document_expedition_place'] ?? '',
      birthDate: json['birthDate'] ?? json['birth_date'] ?? '',
      street: json['street'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      city: json['city'] ?? '',
      apartment: json['apartment'],
      isEmployed: json['isEmployed'] ?? json['is_employed'] ?? false,
      companyName: json['companyName'] ?? json['company_name'],
      position: json['position'],
      employmentYears: (json['employmentYears'] ?? json['employment_years']) is int
          ? (json['employmentYears'] ?? json['employment_years'])
          : int.tryParse((json['employmentYears'] ?? json['employment_years']).toString()),
      workPhone: json['workPhone'] ?? json['work_phone'],
      corporateEmail: json['corporateEmail'] ?? json['corporate_email'],
      contractType: json['contractType'] ?? json['contract_type'],
      workAddress: json['workAddress'] ?? json['work_address'],
    );
  }

  Map<String, dynamic> toJson() => {
        'documentType': documentType,
        'documentNumber': documentNumber,
        'documentExpeditionPlace': documentExpeditionPlace,
        'birthDate': birthDate,
        'street': street,
        'neighborhood': neighborhood,
        'city': city,
        'apartment': apartment,
        'isEmployed': isEmployed,
        'companyName': companyName,
        'position': position,
        'employmentYears': employmentYears,
        'workPhone': workPhone,
        'corporateEmail': corporateEmail,
        'contractType': contractType,
        'workAddress': workAddress,
      };
}

class Reference {
  String fullName;
  String phone;
  String relationship;
  String type; // PERSONAL or FAMILY

  Reference({
    this.fullName = '',
    this.phone = '',
    this.relationship = '',
    this.type = 'PERSONAL',
  });

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      relationship: json['relationship'] ?? '',
      type: json['type'] ?? 'PERSONAL',
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'phone': phone,
        'relationship': relationship,
        'type': type,
      };
}

class PreviousCredit {
  String bankName;
  double amount;
  String status;
  double monthlyInstallment;

  PreviousCredit({
    this.bankName = '',
    this.amount = 0,
    this.status = 'ACTIVE',
    this.monthlyInstallment = 0,
  });

  factory PreviousCredit.fromJson(Map<String, dynamic> json) {
    return PreviousCredit(
      bankName: json['bankName'] ?? json['bank_name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'ACTIVE',
      monthlyInstallment: (json['monthlyInstallment'] ?? json['monthly_installment'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'bankName': bankName,
        'amount': amount,
        'status': status,
        'monthlyInstallment': monthlyInstallment,
      };
}

class CoDebtor {
  String fullName;
  String documentId;
  String birthDate;
  String phone;
  String email;
  String address;
  bool isLegalRepresentative;
  String companyName;
  String position;
  int employmentYears;
  String workPhone;
  double monthlyIncome;
  double monthlyExpenses;

  CoDebtor({
    this.fullName = '',
    this.documentId = '',
    this.birthDate = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.isLegalRepresentative = false,
    this.companyName = '',
    this.position = '',
    this.employmentYears = 0,
    this.workPhone = '',
    this.monthlyIncome = 0,
    this.monthlyExpenses = 0,
  });

  factory CoDebtor.fromJson(Map<String, dynamic> json) {
    return CoDebtor(
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      documentId: json['documentId'] ?? json['document_id'] ?? '',
      birthDate: json['birthDate'] ?? json['birth_date'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      isLegalRepresentative: json['isLegalRepresentative'] ?? json['is_legal_representative'] ?? false,
      companyName: json['companyName'] ?? json['company_name'] ?? '',
      position: json['position'] ?? '',
      employmentYears: (json['employmentYears'] ?? json['employment_years'] ?? 0) is int 
          ? (json['employmentYears'] ?? json['employment_years'] ?? 0)
          : int.tryParse((json['employmentYears'] ?? json['employment_years'] ?? 0).toString()) ?? 0,
      workPhone: json['workPhone'] ?? json['work_phone'] ?? '',
      monthlyIncome: (json['monthlyIncome'] ?? json['monthly_income'] ?? 0).toDouble(),
      monthlyExpenses: (json['monthlyExpenses'] ?? json['monthly_expenses'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'documentId': documentId,
        'birthDate': birthDate,
        'phone': phone,
        'email': email,
        'address': address,
        'isLegalRepresentative': isLegalRepresentative,
        'companyName': companyName,
        'position': position,
        'employmentYears': employmentYears,
        'workPhone': workPhone,
        'monthlyIncome': monthlyIncome,
        'monthlyExpenses': monthlyExpenses,
      };
}
