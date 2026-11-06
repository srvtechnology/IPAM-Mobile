import '../../../models/event_models.dart';
import '../../../services/event_service.dart';
import '../models/event_model.dart';

class EventsProvider {
  final EventService _service;

  EventsProvider({EventService? service})
      : _service = service ?? EventService();

  Future<List<EventModel>> fetchEvents() async {
    try {
      final items = await _service.fetchEvents();
      if (items.isNotEmpty) {
        return items.map((e) => e.toEventModel()).toList();
      }
    } catch (_) {}

    return getCuratedEvents();
  }

  Future<EventModel?> getEventDetails(String id) async {
    try {
      final item = await _service.getEventDetails(id);
      return item.toEventModel();
    } catch (_) {
      return null;
    }
  }

  Future<List<EventModel>> fetchMyRegistrations() async {
    try {
      final registrations = await _service.fetchMyRegistrations();
      return registrations.map((r) => r.toEventModel()).toList();
    } catch (_) {}

    return getCuratedEvents().where((e) => e.isRsvp).toList();
  }

  Future<EventBooking?> registerForEvent(
    String eventId, {
    int ticketCount = 1,
    String? attendeeName,
    String? attendeeEmail,
    String? attendeePhone,
    String? notes,
    String paymentMethod = 'FREE',
  }) async {
    try {
      return await _service.registerForEvent(
        eventId,
        ticketCount: ticketCount,
        attendeeName: attendeeName,
        attendeeEmail: attendeeEmail,
        attendeePhone: attendeePhone,
        notes: notes,
        paymentMethod: paymentMethod,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> cancelRegistration(String bookingRef) async {
    try {
      await _service.cancelRegistration(bookingRef);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> submitProposal(EventProposal proposal) async {
    try {
      await _service.submitProposal(proposal);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> toggleRsvp(String eventId, bool currentStatus) async {
    return true; // Synchronous responsive optimistic update
  }

  List<EventModel> getCuratedEvents() {
    return [
      // 1. Featured Flagship Event (Exact match to Image 1 & 2)
      EventModel(
        id: 'ev_flagship',
        title: 'Freetown Young Alumni Networking Mixer',
        description:
            'Connecting Recent Graduates (Classes 2018–2025) with Established Industry Leaders in Tech, Banking, and Public Policy.',
        dateTime: DateTime(2026, 11, 6, 18, 0),
        location: 'Lumley Beach Pavilion, Aberdeen, Freetown',
        venueType: 'Lumley Beach Pavilion, Aberdeen, Freetown',
        category: 'Freetown & Local',
        chapter: 'Freetown Chapter',
        rsvpCount: 142,
        isRsvp: false,
        isFeatured: true,
        featuredTag: 'FEATURED FLAGSHIP EVENT',
        imageUrl:
            'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=1200&q=80',
        price: r'$15 USD / NLe 350',
        isFree: false,
        badgeTag: 'Flagship Mixer',
        registeredText: '142 Alumni Registered',
        keynoteSpeakers: const [
          'Prof. Aminata Bangura (President)',
          'David Okoro (VP Outreach)',
        ],
        dateMonth: 'NOV',
        dateDay: '06',
        timeFormatted: 'FRIDAY, NOV 6, 2026 • 6:00 PM – 10:00 PM GMT',
        isPassOpen: true,
        isBookmarked: true,
      ),

      // 2. Upcoming Gathering 1: Career Growth & Global Mobility Webinar (Exact match to Image 2)
      EventModel(
        id: 'ev_webinar',
        title: 'Career Growth & Global Mobility Webinar',
        description:
            'Navigating executive transitions, cross-border remote work, and international certifications.',
        dateTime: DateTime(2026, 11, 16, 15, 0),
        location: 'Global Virtual Stage',
        venueType: 'Global Virtual Stage',
        category: 'Virtual / Webinars',
        chapter: 'Virtual / Global',
        rsvpCount: 320,
        isRsvp: true, // Already registered (My Tickets)
        isFeatured: false,
        price: 'Free Admission',
        isFree: true,
        badgeTag: 'Free • Virtual',
        registeredText: '320+ Registered',
        keynoteSpeakers: const [
          'Hawa Koroma (Global Talent Lead, UK)',
          'Ibrahim Mansaray (Remote Eng Manager, US)',
        ],
        dateMonth: 'NOV',
        dateDay: '16',
        timeFormatted: 'Monday, Nov 16, 2026 • 15:00 GMT',
        isPassOpen: true,
        isBookmarked: false,
        ticketCode: 'IPAM-VIRT-3209',
        ticketTier: 'Complimentary Virtual Pass',
      ),

      // 3. Upcoming Gathering 2: London & Diaspora Chapter Winter Reception (Exact match to Image 3)
      EventModel(
        id: 'ev_london',
        title: 'London & Diaspora Chapter Winter Reception',
        description:
            'Annual gathering of UK, European, and diaspora graduates focused on investment in Sierra Leone innovation funds.',
        dateTime: DateTime(2027, 1, 15, 17, 30),
        location: 'The Royal Society of Arts, London',
        venueType: 'The Royal Society of Arts, London',
        category: 'International Chapters',
        chapter: 'UK & European Diaspora',
        rsvpCount: 95,
        isRsvp: true, // Already registered (My Tickets)
        isFeatured: false,
        price: r'$25 USD',
        isFree: false,
        badgeTag: 'UK Chapter • Hybrid',
        registeredText: '95+ Registered',
        keynoteSpeakers: const [
          'Mohamed Jalloh (Diaspora Investment Envoy)',
          'Dr. Fatima Sesay (UK High Commission Liaison)',
        ],
        dateMonth: 'JAN',
        dateDay: '15',
        timeFormatted: 'Friday, Jan 15, 2027 • 17:30 GMT',
        isPassOpen: true,
        isBookmarked: false,
        ticketCode: 'IPAM-UK27-0184',
        ticketTier: 'Executive Delegate Pass',
      ),

      // 4. Upcoming Gathering 3: West Africa Governance Summit
      EventModel(
        id: 'ev_governance',
        title: 'West Africa Governance & Fiscal Policy Summit',
        description:
            'Senior civil service, audit, and ministerial alumni address decentralisation, economic accountability, and cross-border trade.',
        dateTime: DateTime(2026, 11, 28, 10, 0),
        location: 'Bintumani Conference Centre, Aberdeen',
        venueType: 'Bintumani Conference Centre, Aberdeen',
        category: 'Freetown & Local',
        chapter: 'Freetown Chapter',
        rsvpCount: 180,
        isRsvp: false,
        isFeatured: false,
        price: 'Free Admission',
        isFree: true,
        badgeTag: 'Regional • In-Person',
        registeredText: '180+ Registered',
        keynoteSpeakers: const [
          'Hon. Samuel S. Bangura (Deputy Minister)',
          'Mariama Kamara (Auditor-General Office)',
        ],
        dateMonth: 'NOV',
        dateDay: '28',
        timeFormatted: 'Saturday, Nov 28, 2026 • 10:00 AM GMT',
        isPassOpen: true,
        isBookmarked: false,
      ),

      // 5. Upcoming Gathering 4: IPAM Founders & Angel Investors Forum
      EventModel(
        id: 'ev_founders',
        title: 'IPAM Founders & Angel Investors Forum',
        description:
            'Pitch sessions, venture capital insights, and co-founder speed-networking for alumni enterprises.',
        dateTime: DateTime(2026, 12, 12, 18, 0),
        location: 'Sierra Innovation Hub, Hill Station',
        venueType: 'Sierra Innovation Hub, Hill Station',
        category: 'Virtual / Webinars',
        chapter: 'Freetown Chapter',
        rsvpCount: 110,
        isRsvp: false,
        isFeatured: false,
        price: r'$10 USD / NLe 230',
        isFree: false,
        badgeTag: 'Tech & Founders • Hybrid',
        registeredText: '110+ Registered',
        keynoteSpeakers: const [
          'Kelfala Conteh (Venture Partner, AfricaSeed)',
          'Sia Williams (Managing Director, PaySalone)',
        ],
        dateMonth: 'DEC',
        dateDay: '12',
        timeFormatted: 'Thursday, Dec 12, 2026 • 18:00 GMT',
        isPassOpen: true,
        isBookmarked: false,
      ),
    ];
  }

  List<String> getChapterList() {
    return const [
      'All Chapters (12)',
      'Freetown Chapter',
      'UK & European Diaspora',
      'North America Chapter (US & Canada)',
      'West Africa / ECOWAS Regional',
      'Virtual / Global Stage',
      'Bo & Southern Province Chapter',
      'Makeni & Northern Province Chapter',
      'Kenema & Eastern Province Chapter',
    ];
  }
}
