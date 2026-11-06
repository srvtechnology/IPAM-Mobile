class MembershipTierInfo {
  final String key;
  final String name;
  final int annualPrice;
  final int lifetimePrice;
  final List<String> features;
  final String badge;
  final bool isPopular;

  const MembershipTierInfo({
    required this.key,
    required this.name,
    required this.annualPrice,
    required this.lifetimePrice,
    required this.features,
    required this.badge,
    this.isPopular = false,
  });

  factory MembershipTierInfo.fromMap(String key, Map<String, dynamic> map) {
    return MembershipTierInfo(
      key: key,
      name: map['name']?.toString() ?? key,
      annualPrice: (map['annualPrice'] as num?)?.toInt() ?? 0,
      lifetimePrice: (map['lifetimePrice'] as num?)?.toInt() ?? 0,
      features: (map['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      badge: map['badge']?.toString() ?? 'Tier Plan',
      isPopular: map['isPopular'] == true || key == 'GOLD_PATRON',
    );
  }
}

class MembershipStatus {
  final String currentTier;
  final String status;
  final DateTime? startDate;
  final DateTime? validUntil;
  final bool autoRenew;
  final int annualDuesPaid;
  final List<MembershipTierInfo> availableTiers;

  const MembershipStatus({
    required this.currentTier,
    required this.status,
    this.startDate,
    this.validUntil,
    required this.autoRenew,
    this.annualDuesPaid = 150,
    required this.availableTiers,
  });

  factory MembershipStatus.fromJson(Map<String, dynamic> json) {
    final rawTiers = json['availableTiers'];
    final List<MembershipTierInfo> tierList = [];

    if (rawTiers is Map) {
      rawTiers.forEach((key, val) {
        if (val is Map) {
          tierList.add(MembershipTierInfo.fromMap(
            key.toString(),
            Map<String, dynamic>.from(val),
          ));
        }
      });
    }

    if (tierList.isEmpty) {
      tierList.addAll(defaultTiers());
    }

    return MembershipStatus(
      currentTier: json['currentTier']?.toString() ?? 'GOLD_PATRON',
      status: json['status']?.toString() ?? 'ACTIVE',
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? ''),
      validUntil: DateTime.tryParse(json['validUntil']?.toString() ?? '') ??
          DateTime(2027, 1, 1),
      autoRenew: json['autoRenew'] == true,
      annualDuesPaid: (json['annualDuesPaid'] as num?)?.toInt() ?? 150,
      availableTiers: tierList,
    );
  }

  static List<MembershipTierInfo> defaultTiers() {
    return const [
      MembershipTierInfo(
        key: 'STANDARD',
        name: 'Standard Alumni Member',
        annualPrice: 0,
        lifetimePrice: 0,
        features: [
          'Digital ID Pass & QR Code',
          'Global Directory Browsing',
          'Job Board & Application Tracking',
          'Alumni News & Event Notifications',
        ],
        badge: 'Complimentary Tier',
      ),
      MembershipTierInfo(
        key: 'SILVER_LIFETIME',
        name: 'Silver Lifetime Fellow',
        annualPrice: 50,
        lifetimePrice: 250,
        features: [
          'All Standard Privileges',
          'Physical PVC ID Card Included',
          'Priority RSVP & Reserved Event Seating',
          'Mentorship Pipeline & Fellow Directory Badge',
        ],
        badge: 'Recommended',
        isPopular: false,
      ),
      MembershipTierInfo(
        key: 'GOLD_PATRON',
        name: 'Gold University Patron',
        annualPrice: 120,
        lifetimePrice: 500,
        features: [
          'All Silver Privileges',
          'Gold RFID Smart Card with NFC Issuance',
          'Executive Council Voting Rights',
          'VIP University & Convocation Receptions',
          'USL Endowment Advisory Recognition',
        ],
        badge: 'Active Tier',
        isPopular: true,
      ),
    ];
  }

  static MembershipStatus sampleActivePatron() {
    return MembershipStatus(
      currentTier: 'GOLD_PATRON',
      status: 'ACTIVE',
      startDate: DateTime(2026, 1, 1),
      validUntil: DateTime(2027, 1, 1),
      autoRenew: true,
      annualDuesPaid: 150,
      availableTiers: defaultTiers(),
    );
  }
}
