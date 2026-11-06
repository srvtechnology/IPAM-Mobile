class DonationRecord {
  final String id;
  final String donorName;
  final String? donorEmail;
  final String? donorPhone;
  final double amount;
  final String currency;
  final String fund;
  final String frequency;
  final String paymentMethod;
  final String? paymentRef;
  final bool isAnonymous;
  final String? message;
  final String status;
  final DateTime createdAt;

  const DonationRecord({
    required this.id,
    required this.donorName,
    this.donorEmail,
    this.donorPhone,
    required this.amount,
    this.currency = 'USD',
    required this.fund,
    this.frequency = 'ONE_TIME',
    this.paymentMethod = 'CARD',
    this.paymentRef,
    this.isAnonymous = false,
    this.message,
    this.status = 'SUCCEEDED',
    required this.createdAt,
  });

  factory DonationRecord.fromJson(Map<String, dynamic> json) {
    return DonationRecord(
      id: json['id']?.toString() ?? '',
      donorName: json['donorName']?.toString() ?? 'Anonymous Donor',
      donorEmail: json['donorEmail']?.toString(),
      donorPhone: json['donorPhone']?.toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'USD',
      fund: json['fund']?.toString() ?? 'General University Fund',
      frequency: json['frequency']?.toString() ?? 'ONE_TIME',
      paymentMethod: json['paymentMethod']?.toString() ?? 'CARD',
      paymentRef: json['paymentRef']?.toString(),
      isAnonymous: json['isAnonymous'] == true,
      message: json['message']?.toString(),
      status: json['status']?.toString() ?? 'SUCCEEDED',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'donorName': donorName,
      'donorEmail': donorEmail,
      'donorPhone': donorPhone,
      'amount': amount,
      'currency': currency,
      'fund': fund,
      'frequency': frequency,
      'paymentMethod': paymentMethod,
      'paymentRef': paymentRef,
      'isAnonymous': isAnonymous,
      'message': message,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static List<DonationRecord> sampleDonations() {
    return [
      DonationRecord(
        id: 'don_1',
        donorName: 'Pranabesh Sarkar',
        amount: 150.0,
        currency: 'USD',
        fund: 'Student Scholarship Endowment',
        frequency: 'ONE_TIME',
        paymentMethod: 'CARD',
        paymentRef: 'DON-2026-9812',
        isAnonymous: false,
        message: 'Honoring IPAM mentors and supporting underprivileged students.',
        status: 'SUCCEEDED',
        createdAt: DateTime(2026, 10, 20, 14, 30),
      ),
      DonationRecord(
        id: 'don_2',
        donorName: 'Dr. Amara Sesay',
        amount: 250.0,
        currency: 'USD',
        fund: 'STEM Laboratory Fund',
        frequency: 'ANNUAL',
        paymentMethod: 'BANK',
        paymentRef: 'DON-2026-8741',
        isAnonymous: false,
        message: 'Supporting advanced computing infrastructure at Tower Hill.',
        status: 'SUCCEEDED',
        createdAt: DateTime(2026, 10, 18, 11, 15),
      ),
      DonationRecord(
        id: 'don_3',
        donorName: 'Anonymous Alumnus',
        amount: 500.0,
        currency: 'USD',
        fund: 'Tower Hill Infrastructure & Innovation Fund',
        frequency: 'ONE_TIME',
        paymentMethod: 'CARD',
        paymentRef: 'DON-2026-7733',
        isAnonymous: true,
        message: 'For the digital library modernization.',
        status: 'SUCCEEDED',
        createdAt: DateTime(2026, 10, 15, 16, 45),
      ),
      DonationRecord(
        id: 'don_4',
        donorName: 'Prof. Aminata Bangura',
        amount: 300.0,
        currency: 'USD',
        fund: 'Student Scholarship Endowment',
        frequency: 'ANNUAL',
        paymentMethod: 'CARD',
        paymentRef: 'DON-2026-6644',
        isAnonymous: false,
        message: 'Supporting female leadership scholarships in public administration.',
        status: 'SUCCEEDED',
        createdAt: DateTime(2026, 10, 10, 9, 0),
      ),
    ];
  }
}
