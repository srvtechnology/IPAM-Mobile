class EventAdmissionTier {
  final String id;
  final String name;
  final String badgeText;
  final bool isRecommended;
  final double priceUsd;
  final int priceNle;
  final String description;

  const EventAdmissionTier({
    required this.id,
    required this.name,
    this.badgeText = '',
    this.isRecommended = false,
    required this.priceUsd,
    required this.priceNle,
    required this.description,
  });

  String get priceFormatted =>
      priceUsd == 0 ? r'$0 USD / NLe 0' : '\$${priceUsd.toInt()} USD / NLe $priceNle';
}

class EventAttendee {
  final String name;
  final String role;
  final bool isKeynote;

  const EventAttendee({
    required this.name,
    required this.role,
    this.isKeynote = false,
  });
}

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final String category;
  final int rsvpCount;
  final bool isRsvp;

  // Rich attributes matching attached designs
  final bool isFeatured;
  final String? featuredTag;
  final String? imageUrl;
  final String price;
  final bool isFree;
  final String badgeTag;
  final String registeredText;
  final List<String> keynoteSpeakers;
  final String dateMonth;
  final String dateDay;
  final String timeFormatted;
  final String venueType;
  final bool isPassOpen;
  final bool isBookmarked;
  final String chapter;
  final String? ticketCode;
  final String? ticketTier;
  final int seatsRemaining;
  final String dressCode;
  final String parkingInfo;
  final List<EventAdmissionTier> admissionTiers;
  final List<EventAttendee> attendees;

  /// Whether the event is upcoming (i.e. scheduled for today or a future date)
  bool get isUpcoming {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return !dateTime.isBefore(todayStart);
  }

  /// Whether the event is in the past / backdated
  bool get isPast => !isUpcoming;

  static const List<EventAdmissionTier> defaultTiers = [
    EventAdmissionTier(
      id: 'standard',
      name: 'Standard Alumni Pass',
      badgeText: 'Recommended',
      isRecommended: true,
      priceUsd: 0,
      priceNle: 0,
      description:
          'Full access pass including entry badge, beachfront welcome cocktail, dinner buffet, and curated alumni networking booklet.',
    ),
    EventAdmissionTier(
      id: 'patron',
      name: 'Patron Sponsor Pass',
      badgeText: 'Scholarship Fund',
      isRecommended: false,
      priceUsd: 50,
      priceNle: 1200,
      description:
          'Includes VIP reserved roundtable with the National Executive Council, commemorative lapel crest, and \$35 endowed to the IPAM Student Scholarship Fund.',
    ),
  ];

  static const List<EventAttendee> defaultAttendees = [
    EventAttendee(
      name: 'Prof. Aminata Bangura',
      role: 'President & Keynote',
      isKeynote: true,
    ),
    EventAttendee(
      name: 'David Okoro',
      role: 'VP Outreach & Lead Consultant',
    ),
    EventAttendee(
      name: 'Elena Rodriguez',
      role: 'Treasurer, Standard Chartered',
    ),
  ];

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.category,
    this.rsvpCount = 0,
    this.isRsvp = false,
    this.isFeatured = false,
    this.featuredTag,
    this.imageUrl,
    this.price = 'Free Admission',
    this.isFree = true,
    this.badgeTag = 'All Events',
    this.registeredText = '',
    this.keynoteSpeakers = const [],
    this.dateMonth = '',
    this.dateDay = '',
    this.timeFormatted = '',
    this.venueType = '',
    this.isPassOpen = true,
    this.isBookmarked = false,
    this.chapter = 'All Chapters',
    this.ticketCode,
    this.ticketTier,
    this.seatsRemaining = 58,
    this.dressCode = 'Smart Casual',
    this.parkingInfo =
        'Located right at the venue. Show your IPAM Virtual Alumni ID badge at the security gate for reserved covered parking.',
    this.admissionTiers = defaultTiers,
    this.attendees = defaultAttendees,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? location,
    String? category,
    int? rsvpCount,
    bool? isRsvp,
    bool? isFeatured,
    String? featuredTag,
    String? imageUrl,
    String? price,
    bool? isFree,
    String? badgeTag,
    String? registeredText,
    List<String>? keynoteSpeakers,
    String? dateMonth,
    String? dateDay,
    String? timeFormatted,
    String? venueType,
    bool? isPassOpen,
    bool? isBookmarked,
    String? chapter,
    String? ticketCode,
    String? ticketTier,
    int? seatsRemaining,
    String? dressCode,
    String? parkingInfo,
    List<EventAdmissionTier>? admissionTiers,
    List<EventAttendee>? attendees,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      category: category ?? this.category,
      rsvpCount: rsvpCount ?? this.rsvpCount,
      isRsvp: isRsvp ?? this.isRsvp,
      isFeatured: isFeatured ?? this.isFeatured,
      featuredTag: featuredTag ?? this.featuredTag,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      isFree: isFree ?? this.isFree,
      badgeTag: badgeTag ?? this.badgeTag,
      registeredText: registeredText ?? this.registeredText,
      keynoteSpeakers: keynoteSpeakers ?? this.keynoteSpeakers,
      dateMonth: dateMonth ?? this.dateMonth,
      dateDay: dateDay ?? this.dateDay,
      timeFormatted: timeFormatted ?? this.timeFormatted,
      venueType: venueType ?? this.venueType,
      isPassOpen: isPassOpen ?? this.isPassOpen,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      chapter: chapter ?? this.chapter,
      ticketCode: ticketCode ?? this.ticketCode,
      ticketTier: ticketTier ?? this.ticketTier,
      seatsRemaining: seatsRemaining ?? this.seatsRemaining,
      dressCode: dressCode ?? this.dressCode,
      parkingInfo: parkingInfo ?? this.parkingInfo,
      admissionTiers: admissionTiers ?? this.admissionTiers,
      attendees: attendees ?? this.attendees,
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dateTime: json['dateTime'] != null
          ? DateTime.tryParse(json['dateTime']) ?? DateTime.now()
          : DateTime.now(),
      location: json['location'] ?? 'IPAM Main Auditorium, Freetown',
      category: json['category'] ?? 'Reunion',
      rsvpCount: json['rsvpCount'] ?? 0,
      isRsvp: json['isRsvp'] == true,
      isFeatured: json['isFeatured'] == true,
      featuredTag: json['featuredTag'],
      imageUrl: json['imageUrl'],
      price: json['price'] ?? 'Free Admission',
      isFree: json['isFree'] ?? true,
      badgeTag: json['badgeTag'] ?? 'All Events',
      registeredText: json['registeredText'] ?? '',
      keynoteSpeakers: (json['keynoteSpeakers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      dateMonth: json['dateMonth'] ?? '',
      dateDay: json['dateDay'] ?? '',
      timeFormatted: json['timeFormatted'] ?? '',
      venueType: json['venueType'] ?? '',
      isPassOpen: json['isPassOpen'] ?? true,
      isBookmarked: json['isBookmarked'] == true,
      chapter: json['chapter'] ?? 'All Chapters',
      ticketCode: json['ticketCode'],
      ticketTier: json['ticketTier'],
    );
  }
}
