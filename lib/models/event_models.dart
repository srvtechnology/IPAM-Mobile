import '../core/network/api_client.dart';
import '../features/events/models/event_model.dart';

class EventSpeaker {
  final String name;
  final String? image;
  final String? title;

  const EventSpeaker({
    required this.name,
    this.image,
    this.title,
  });

  factory EventSpeaker.fromJson(Map<String, dynamic> json) {
    return EventSpeaker(
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString(),
      title: json['title']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'title': title,
      };
}

class EventAgendaItem {
  final String time;
  final String activity;

  const EventAgendaItem({
    required this.time,
    required this.activity,
  });

  factory EventAgendaItem.fromJson(Map<String, dynamic> json) {
    return EventAgendaItem(
      time: json['time']?.toString() ?? '',
      activity: json['activity']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'activity': activity,
      };
}

class EventItem {
  final String id;
  final String title;
  final String? slug;
  final String category;
  final DateTime date;
  final String? displayDate;
  final String? time;
  final String location;
  final String? venueDetails;
  final bool isVirtual;
  final String? virtualLink;
  final String? bannerImage;
  final List<String> bannerImages;
  final String description;
  final int capacity;
  final int registeredCount;
  final int? availableSeats;
  final bool isFree;
  final double ticketPrice;
  final String currency;
  final String status;
  final bool featured;
  final bool registered;
  final List<EventSpeaker> speakers;
  final List<EventAgendaItem> agenda;

  EventItem({
    required this.id,
    required this.title,
    this.slug,
    required this.category,
    required this.date,
    this.displayDate,
    this.time,
    required this.location,
    this.venueDetails,
    this.isVirtual = false,
    this.virtualLink,
    this.bannerImage,
    this.bannerImages = const [],
    required this.description,
    required this.capacity,
    required this.registeredCount,
    this.availableSeats,
    required this.isFree,
    required this.ticketPrice,
    this.currency = 'USD',
    this.status = 'UPCOMING',
    this.featured = false,
    this.registered = false,
    this.speakers = const [],
    this.agenda = const [],
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date'] ?? json['dateTime'];
    final parsedDate = DateTime.tryParse(rawDate?.toString() ?? '') ?? DateTime.now();

    // Price can be boolean isPaid / isFree, or string "15", or num
    final isPaid = json['isPaid'] == true;
    final isFreeExplicit = json['isFree'];
    final bool calculatedIsFree;
    if (isFreeExplicit != null) {
      calculatedIsFree = isFreeExplicit == true;
    } else {
      calculatedIsFree = !isPaid;
    }

    final rawPrice = json['ticketPrice'];
    double parsedPrice = 0.0;
    if (rawPrice != null) {
      if (rawPrice is num) {
        parsedPrice = rawPrice.toDouble();
      } else if (rawPrice is String) {
        parsedPrice = double.tryParse(rawPrice) ?? 0.0;
      }
    }

    final rawSpeakers = json['speakers'] as List<dynamic>? ?? [];
    final speakersList = rawSpeakers
        .whereType<Map<String, dynamic>>()
        .map((s) => EventSpeaker.fromJson(s))
        .toList();

    final rawAgenda = json['agenda'] as List<dynamic>? ?? [];
    final agendaList = rawAgenda
        .whereType<Map<String, dynamic>>()
        .map((a) => EventAgendaItem.fromJson(a))
        .toList();

    final rawBannerImages = json['bannerImages'] as List<dynamic>? ?? [];
    final bannerImagesList =
        rawBannerImages.map((e) => e.toString()).toList();

    return EventItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString(),
      category: json['category']?.toString() ?? 'NETWORKING',
      date: parsedDate,
      displayDate: json['displayDate']?.toString(),
      time: json['time']?.toString(),
      location: json['location']?.toString() ?? 'IPAM Campus',
      venueDetails: json['venueDetails']?.toString(),
      isVirtual: json['isVirtual'] == true,
      virtualLink: json['virtualLink']?.toString(),
      bannerImage: json['bannerImage']?.toString(),
      bannerImages: bannerImagesList,
      description: json['description']?.toString() ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      registeredCount: (json['registeredCount'] as num?)?.toInt() ?? 0,
      availableSeats: (json['availableSeats'] as num?)?.toInt(),
      isFree: calculatedIsFree && parsedPrice == 0.0,
      ticketPrice: parsedPrice,
      currency: json['currency']?.toString() ?? 'USD',
      status: json['status']?.toString() ?? 'UPCOMING',
      featured: json['featured'] == true,
      registered: json['registered'] == true,
      speakers: speakersList,
      agenda: agendaList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'category': category,
      'date': date.toIso8601String(),
      'displayDate': displayDate,
      'time': time,
      'location': location,
      'venueDetails': venueDetails,
      'isVirtual': isVirtual,
      'virtualLink': virtualLink,
      'bannerImage': bannerImage,
      'bannerImages': bannerImages,
      'description': description,
      'capacity': capacity,
      'registeredCount': registeredCount,
      'availableSeats': availableSeats,
      'isFree': isFree,
      'ticketPrice': ticketPrice,
      'currency': currency,
      'status': status,
      'featured': featured,
      'registered': registered,
      'speakers': speakers.map((s) => s.toJson()).toList(),
      'agenda': agenda.map((a) => a.toJson()).toList(),
    };
  }

  String? get formattedBannerUrl {
    if (bannerImage == null || bannerImage!.isEmpty) return null;
    return ApiClient.formatUrl(bannerImage!);
  }

  String get dateMonth {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return months[date.month - 1];
  }

  String get dateDay {
    return date.day.toString().padLeft(2, '0');
  }

  String get timeFormatted {
    if (displayDate != null && time != null) {
      return '$displayDate • $time GMT';
    }
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final weekday = days[date.weekday - 1];
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$weekday, $dateMonth $dateDay, ${date.year} • $hour:$minute $ampm GMT';
  }

  int get remainingSeats {
    if (availableSeats != null) return availableSeats!;
    if (capacity > registeredCount) return capacity - registeredCount;
    return 0;
  }

  String get priceFormatted {
    if (isFree || ticketPrice == 0.0) return 'Free Admission';
    final nle = (ticketPrice * 23.5).toInt();
    return '\$${ticketPrice.toInt()} USD / NLe $nle';
  }

  /// Whether the event is upcoming (i.e. scheduled for today or in the future)
  bool get isUpcoming {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return !date.isBefore(todayStart);
  }

  /// Whether the event is in the past / backdated
  bool get isPast => !isUpcoming;

  /// Bridges to the existing UI's EventModel cleanly
  EventModel toEventModel({String? ticketCode, String? ticketTier}) {
    final keynoteList = speakers
        .map((s) => s.title != null && s.title!.isNotEmpty
            ? '${s.name} (${s.title})'
            : s.name)
        .toList();

    final standardPriceUsd = isFree ? 0.0 : ticketPrice;
    final standardPriceNle = isFree ? 0 : (ticketPrice * 23.5).toInt();
    final patronPriceUsd = isFree ? 50.0 : (ticketPrice + 35.0);
    final patronPriceNle = isFree ? 1200 : (((ticketPrice + 35) * 24)).toInt();

    final dynamicTiers = [
      EventAdmissionTier(
        id: 'standard',
        name: 'Standard Alumni Pass',
        badgeText: 'Recommended',
        isRecommended: true,
        priceUsd: standardPriceUsd,
        priceNle: standardPriceNle,
        description: isVirtual
            ? 'Full access pass including live webinar stream, interactive Q&A session, and digital presentation materials.'
            : 'Full access pass including entry badge, beachfront welcome cocktail, dinner buffet, and curated alumni networking booklet.',
      ),
      EventAdmissionTier(
        id: 'patron',
        name: 'Patron Sponsor Pass',
        badgeText: 'Scholarship Fund',
        isRecommended: false,
        priceUsd: patronPriceUsd,
        priceNle: patronPriceNle,
        description:
            'Includes VIP reserved roundtable with the National Executive Council, commemorative lapel crest, and \$35 endowed to the IPAM Student Scholarship Fund.',
      ),
    ];

    return EventModel(
      id: id,
      title: title,
      description: description,
      dateTime: date,
      location: location,
      category: category,
      rsvpCount: registeredCount,
      isRsvp: registered || ticketCode != null,
      isFeatured: featured,
      featuredTag: featured ? 'FEATURED FLAGSHIP EVENT' : null,
      imageUrl: formattedBannerUrl,
      price: priceFormatted,
      isFree: isFree,
      badgeTag: category.replaceAll('_', ' '),
      registeredText: registeredCount > 0 ? '$registeredCount Alumni Registered' : '',
      keynoteSpeakers: keynoteList,
      dateMonth: dateMonth,
      dateDay: dateDay,
      timeFormatted: timeFormatted,
      venueType: venueDetails ?? (isVirtual ? 'Virtual Webinar Room' : location),
      isPassOpen: status == 'PUBLISHED' || status == 'UPCOMING',
      chapter: category == 'REGIONAL_MEETUP' ? 'Diaspora Chapter' : 'Freetown Chapter',
      seatsRemaining: remainingSeats,
      ticketCode: ticketCode,
      ticketTier: ticketTier ?? 'Standard Alumni Pass',
      admissionTiers: dynamicTiers,
      attendees: speakers.isNotEmpty
          ? speakers
              .map((s) => EventAttendee(
                    name: s.name,
                    role: s.title ?? 'Distinguished Speaker',
                    isKeynote: true,
                  ))
              .toList()
          : EventModel.defaultAttendees,
    );
  }
}

class EventBooking {
  final String id;
  final String bookingReference;
  final String? eventId;
  final int ticketCount;
  final double totalAmount;
  final String bookingStatus;
  final DateTime registeredAt;
  final EventItem event;

  EventBooking({
    required this.id,
    required this.bookingReference,
    this.eventId,
    required this.ticketCount,
    this.totalAmount = 0.0,
    required this.bookingStatus,
    required this.registeredAt,
    required this.event,
  });

  factory EventBooking.fromJson(Map<String, dynamic> json) {
    final rawDate = json['registeredAt'] ?? json['createdAt'];
    final parsedDate = DateTime.tryParse(rawDate?.toString() ?? '') ?? DateTime.now();

    final rawAmount = json['totalAmount'];
    double amount = 0.0;
    if (rawAmount is num) {
      amount = rawAmount.toDouble();
    } else if (rawAmount is String) {
      amount = double.tryParse(rawAmount) ?? 0.0;
    }

    final eventJson = json['event'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['event'])
        : <String, dynamic>{
            'id': json['eventId']?.toString() ?? '',
            'title': json['eventTitle']?.toString() ?? 'IPAM Alumni Event',
            'location': json['eventLocation']?.toString() ?? 'IPAM Campus',
            'date': json['eventDate']?.toString() ?? parsedDate.toIso8601String(),
            'description': '',
            'capacity': 100,
            'registeredCount': 1,
            'isFree': true,
            'ticketPrice': 0,
          };

    final bookingId = json['id']?.toString();
    final bookingRef = json['bookingReference']?.toString() ?? '';
    final resolvedId = (bookingId != null && bookingId.isNotEmpty) ? bookingId : bookingRef;

    return EventBooking(
      id: resolvedId,
      bookingReference: bookingRef,
      eventId: json['eventId']?.toString(),
      ticketCount: (json['ticketCount'] as num?)?.toInt() ?? 1,
      totalAmount: amount,
      bookingStatus: json['bookingStatus']?.toString() ??
          (json['registered'] == true ? 'CONFIRMED' : 'CONFIRMED'),
      registeredAt: parsedDate,
      event: EventItem.fromJson(eventJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingReference': bookingReference,
      'eventId': eventId,
      'ticketCount': ticketCount,
      'totalAmount': totalAmount,
      'bookingStatus': bookingStatus,
      'registeredAt': registeredAt.toIso8601String(),
      'event': event.toJson(),
    };
  }

  EventModel toEventModel() {
    final isPatron = totalAmount > (event.ticketPrice * ticketCount) && totalAmount > 0;
    return event.toEventModel(
      ticketCode: bookingReference,
      ticketTier: isPatron ? 'Patron Sponsor Pass' : 'Standard Alumni Pass',
    );
  }
}

class EventProposal {
  final String title;
  final String category;
  final String format;
  final String location;
  final String description;
  final String organizerEmail;
  final String? expectedAttendance;
  final String? proposedDate;

  const EventProposal({
    required this.title,
    required this.category,
    required this.format,
    required this.location,
    required this.description,
    required this.organizerEmail,
    this.expectedAttendance,
    this.proposedDate,
  });

  factory EventProposal.fromJson(Map<String, dynamic> json) {
    return EventProposal(
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? 'CAREER_WORKSHOP',
      format: json['format']?.toString() ?? 'HYBRID',
      location: json['location']?.toString() ?? 'IPAM Innovation Hub, Freetown',
      description: json['description']?.toString() ?? '',
      organizerEmail: json['organizerEmail']?.toString() ?? '',
      expectedAttendance: json['expectedAttendance']?.toString(),
      proposedDate: json['proposedDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'category': category,
      'format': format,
      'location': location,
      'description': description,
      'organizerEmail': organizerEmail,
    };
    if (expectedAttendance != null && expectedAttendance!.isNotEmpty) {
      map['expectedAttendance'] = expectedAttendance;
    }
    if (proposedDate != null && proposedDate!.isNotEmpty) {
      map['proposedDate'] = proposedDate;
    }
    return map;
  }
}
