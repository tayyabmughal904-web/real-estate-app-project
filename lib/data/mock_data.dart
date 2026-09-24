import '../models/agent_model.dart';
import '../models/property_model.dart';
import '../models/chat_model.dart';
import '../models/review_model.dart';
import '../models/notification_model.dart';

class MockData {
  // -------------------------------------------------------------
  // AGENTS
  // -------------------------------------------------------------
  static const Agent agent1 = Agent(
    id: 'agent_1',
    name: 'Sarah Jenkins',
    agency: 'Luxeylin Premier Realty',
    avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&auto=format&fit=crop&q=80',
    phone: '+1 (555) 234-8901',
    email: 'sarah.j@luxeylin.com',
    rating: 4.9,
    reviewsCount: 128,
    about: 'Over 8 years of luxury residential real estate experience. Specialized in modern architectural villas, beachfront properties, and downtown penthouses.',
    listingsCount: 24,
    isVerified: true,
  );

  static const Agent agent2 = Agent(
    id: 'agent_2',
    name: 'Marcus Vance',
    agency: 'Metropolis Prime Properties',
    avatarUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=300&auto=format&fit=crop&q=80',
    phone: '+1 (555) 443-1289',
    email: 'marcus.v@metropolis.com',
    rating: 4.8,
    reviewsCount: 94,
    about: 'Dedicated commercial and luxury home specialist committed to finding ideal spaces for high-end lifestyle seekers and smart investors.',
    listingsCount: 16,
    isVerified: true,
  );

  static const Agent agent3 = Agent(
    id: 'agent_3',
    name: 'Elena Rostova',
    agency: 'Horizon Grand Estates',
    avatarUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=300&auto=format&fit=crop&q=80',
    phone: '+1 (555) 902-3411',
    email: 'elena.r@horizongrand.com',
    rating: 4.95,
    reviewsCount: 210,
    about: 'Recognized top producer in high-value estates and architectural landmarks. Passionate about seamless client experience.',
    listingsCount: 31,
    isVerified: true,
  );

  // -------------------------------------------------------------
  // REVIEWS
  // -------------------------------------------------------------
  static const List<PropertyReview> defaultReviews1 = [
    PropertyReview(
      id: 'rev_1',
      userName: 'David Sterling',
      userAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80',
      rating: 5.0,
      date: '2 weeks ago',
      comment: 'An absolute masterpiece of modern architecture. The sunset views from the infinity pool deck are unforgettable!',
    ),
    PropertyReview(
      id: 'rev_2',
      userName: 'Charlotte Moore',
      userAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      rating: 4.8,
      date: '1 month ago',
      comment: 'Exceptional finishes throughout the chef kitchen and smart automation made staying here an absolute dream.',
    ),
  ];

  static const List<PropertyReview> defaultReviews2 = [
    PropertyReview(
      id: 'rev_3',
      userName: 'James Harrison',
      userAvatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150&auto=format&fit=crop&q=80',
      rating: 5.0,
      date: '3 weeks ago',
      comment: 'Unrivaled 360 penthouse skyline view. The private elevator and 24/7 concierge made everything seamless.',
    ),
  ];

  // -------------------------------------------------------------
  // PROPERTIES LIST GETTER
  // -------------------------------------------------------------
  static List<Property> get properties => [
    Property(
      id: 'prop_1',
      title: 'Modern Haven Villa with Infinity Pool',
      description:
          'Experience unparalleled luxury in this masterfully crafted modern villa. Boasting panoramic views, floor-to-ceiling glass walls, an open-concept living area, private infinity pool, landscaped garden, and smart home automation throughout. Perfect for modern luxury living and private entertainment.',
      price: 3450,
      priceSuffix: '/mo',
      type: PropertyType.villa,
      address: '742 Evergreen Terrace, Beverly Hills',
      city: 'Los Angeles, CA',
      bedrooms: 4,
      bathrooms: 3,
      areaSqft: 3600,
      parkingSpaces: 2,
      yearBuilt: 2023,
      rating: 4.9,
      reviewsCount: 42,
      images: [
        'assets/images/house1.jpg',
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=900&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=900&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?w=900&auto=format&fit=crop&q=80',
      ],
      amenities: [
        'Swimming Pool',
        'High-Speed Wi-Fi',
        '2-Car Garage',
        'Smart Security',
        'Central AC & Heating',
        'Private Garden',
        'Balcony / Terrace',
        'EV Charging Station',
      ],
      neighborhood: [
        const NeighborhoodSpot(title: 'Metro Station', distance: '0.4 mi', category: 'Metro'),
        const NeighborhoodSpot(title: 'Beverly Hills High', distance: '0.7 mi', category: 'School'),
        const NeighborhoodSpot(title: 'Cedars-Sinai Hospital', distance: '1.2 mi', category: 'Hospital'),
        const NeighborhoodSpot(title: 'Rodeo Drive Mall', distance: '0.9 mi', category: 'Mall'),
      ],
      reviews: defaultReviews1,
      isFeatured: true,
      isForRent: true,
      agent: agent1,
      latitude: 34.0736,
      longitude: -118.4004,
    ),
    Property(
      id: 'prop_2',
      title: 'Skyline Penthouse with Panoramic Terrace',
      description:
          'Perched high above the city, this breathtaking penthouse offers 360-degree metropolitan views. Designed with imported Italian marble, custom chef kitchen with Miele appliances, private elevator access, and a wrap-around sky terrace with a heated Jacuzzi.',
      price: 5200,
      priceSuffix: '/mo',
      type: PropertyType.penthouse,
      address: '1000 Grand Ave, Penthouse 45',
      city: 'Downtown, NY',
      bedrooms: 3,
      bathrooms: 3,
      areaSqft: 2850,
      parkingSpaces: 2,
      yearBuilt: 2022,
      rating: 4.95,
      reviewsCount: 38,
      images: [
        'assets/images/house2.jpg',
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=900&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=900&auto=format&fit=crop&q=80',
      ],
      amenities: [
        'Sky Terrace',
        'Private Elevator',
        'Concierge 24/7',
        'Fitness Gym',
        'Jacuzzi',
        'Smart Thermostat',
        'Pet Friendly',
        'Underground Parking',
      ],
      neighborhood: [
        const NeighborhoodSpot(title: 'Grand Central Metro', distance: '0.2 mi', category: 'Metro'),
        const NeighborhoodSpot(title: 'Manhattan Grammar', distance: '0.5 mi', category: 'School'),
        const NeighborhoodSpot(title: 'NY Presbyterian', distance: '1.0 mi', category: 'Hospital'),
        const NeighborhoodSpot(title: 'Hudson Yards', distance: '0.6 mi', category: 'Mall'),
      ],
      reviews: defaultReviews2,
      isFeatured: true,
      isForRent: true,
      agent: agent3,
      latitude: 40.7580,
      longitude: -73.9855,
    ),
    Property(
      id: 'prop_3',
      title: 'Serene Scandinavian Contemporary House',
      description:
          'Nestled in a tranquil upscale neighborhood, this contemporary residence pairs warm natural cedar accents with minimalist Nordic aesthetics. Features radiant floor heating, expansive zen courtyard, solar energy array, and spacious ensuite bedrooms.',
      price: 1250000,
      priceSuffix: '',
      type: PropertyType.house,
      address: '28 Forest Glen Lane',
      city: 'Seattle, WA',
      bedrooms: 5,
      bathrooms: 4,
      areaSqft: 4200,
      parkingSpaces: 3,
      yearBuilt: 2024,
      rating: 4.88,
      reviewsCount: 19,
      images: [
        'assets/images/house3.jpg',
        'https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=900&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1600573472591-ee6b68d14c68?w=900&auto=format&fit=crop&q=80',
      ],
      amenities: [
        'Solar Roof Panels',
        'Zen Garden',
        'Wine Cellar',
        'Radiant Heating',
        '3-Car Garage',
        'Home Cinema Room',
        'Security System',
      ],
      neighborhood: [
        const NeighborhoodSpot(title: 'Link Light Rail', distance: '0.8 mi', category: 'Metro'),
        const NeighborhoodSpot(title: 'Cascadia Academy', distance: '0.4 mi', category: 'School'),
        const NeighborhoodSpot(title: 'Swedish Medical', distance: '1.5 mi', category: 'Hospital'),
        const NeighborhoodSpot(title: 'University Village', distance: '1.1 mi', category: 'Mall'),
      ],
      reviews: defaultReviews1,
      isFeatured: true,
      isForRent: false,
      agent: agent2,
      latitude: 47.6062,
      longitude: -122.3321,
    ),
    Property(
      id: 'prop_4',
      title: 'Luxury Waterfront Designer Apartment',
      description:
          'Sunlit luxury apartment overlooking marina yacht docks. Enjoy floor-to-ceiling windows, quartz stone countertops, designer brass fixtures, private yacht mooring access, and resort-style communal amenities.',
      price: 2800,
      priceSuffix: '/mo',
      type: PropertyType.apartment,
      address: '55 Marina Boulevard, Suite 8B',
      city: 'Miami, FL',
      bedrooms: 2,
      bathrooms: 2,
      areaSqft: 1450,
      parkingSpaces: 1,
      yearBuilt: 2021,
      rating: 4.79,
      reviewsCount: 56,
      images: [
        'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=900&auto=format&fit=crop&q=80',
        'assets/images/house1.jpg',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=900&auto=format&fit=crop&q=80',
      ],
      amenities: [
        'Waterfront View',
        'Resort Pool',
        'Gym & Spa',
        'Private Balcony',
        'Covered Parking',
        'High-Speed Wi-Fi',
      ],
      neighborhood: [
        const NeighborhoodSpot(title: 'Biscayne MetroMover', distance: '0.3 mi', category: 'Metro'),
        const NeighborhoodSpot(title: 'Bayfront Prep', distance: '0.6 mi', category: 'School'),
        const NeighborhoodSpot(title: 'Miami Health Center', distance: '1.4 mi', category: 'Hospital'),
        const NeighborhoodSpot(title: 'Bayside Market', distance: '0.5 mi', category: 'Mall'),
      ],
      reviews: defaultReviews2,
      isFeatured: false,
      isForRent: true,
      agent: agent1,
      latitude: 25.7617,
      longitude: -80.1918,
    ),
    Property(
      id: 'prop_5',
      title: 'The Glass Horizon Minimalist Villa',
      description:
          'An architectural tour de force featuring cantilevered steel structures, heated plunge pool, internal bamboo atrium, and seamless indoor-outdoor transitions with motorized glass pocket doors.',
      price: 2400000,
      priceSuffix: '',
      type: PropertyType.villa,
      address: '14 Coastal Ridge Way',
      city: 'Los Angeles, CA',
      bedrooms: 4,
      bathrooms: 5,
      areaSqft: 5100,
      parkingSpaces: 4,
      yearBuilt: 2024,
      rating: 4.96,
      reviewsCount: 31,
      images: [
        'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=900&auto=format&fit=crop&q=80',
        'assets/images/house2.jpg',
        'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=900&auto=format&fit=crop&q=80',
      ],
      amenities: [
        'Infinity Plunge Pool',
        'Ocean View',
        'Smart Lighting',
        'Spa & Sauna',
        'Security Cameras',
        'Designer Kitchen',
        'Outdoor BBQ Grill',
      ],
      neighborhood: [
        const NeighborhoodSpot(title: 'Pacific Coast Transit', distance: '0.5 mi', category: 'Metro'),
        const NeighborhoodSpot(title: 'Malibu Country Day', distance: '1.0 mi', category: 'School'),
        const NeighborhoodSpot(title: 'Santa Monica Hospital', distance: '3.5 mi', category: 'Hospital'),
        const NeighborhoodSpot(title: 'Malibu Lumber Yard', distance: '1.2 mi', category: 'Mall'),
      ],
      reviews: defaultReviews1,
      isFeatured: true,
      isForRent: false,
      agent: agent3,
      latitude: 34.0259,
      longitude: -118.7798,
    ),
    Property(
      id: 'prop_6',
      title: 'Downtown Executive Business Suite',
      description:
          'Prime commercial office space configured for high-growth tech firms or creative agencies. Equipped with high-speed fiber internet, modular boardrooms, acoustic phone booths, and barista kitchen bar.',
      price: 4500,
      priceSuffix: '/mo',
      type: PropertyType.commercial,
      address: '400 Financial Plaza, Floor 12',
      city: 'San Francisco, CA',
      bedrooms: 0,
      bathrooms: 2,
      areaSqft: 2200,
      parkingSpaces: 5,
      yearBuilt: 2020,
      rating: 4.75,
      reviewsCount: 14,
      images: [
        'https://images.unsplash.com/photo-1497366216548-37526070297c?w=900&auto=format&fit=crop&q=80',
        'assets/images/house3.jpg',
      ],
      amenities: [
        'Fiber Internet',
        'Conference Rooms',
        '24/7 Keycard Access',
        'Kitchen Lounge',
        'Reserved Parking',
        'HVAC Climate Control',
      ],
      neighborhood: [
        const NeighborhoodSpot(title: 'Montgomery BART', distance: '0.1 mi', category: 'Metro'),
        const NeighborhoodSpot(title: 'SF Financial Hub', distance: '0.2 mi', category: 'Mall'),
        const NeighborhoodSpot(title: 'Saint Francis Hospital', distance: '1.1 mi', category: 'Hospital'),
      ],
      reviews: defaultReviews2,
      isFeatured: false,
      isForRent: true,
      agent: agent2,
      latitude: 37.7749,
      longitude: -122.4194,
    ),
  ];

  // -------------------------------------------------------------
  // INITIAL CHATS
  // -------------------------------------------------------------
  static List<ChatConversation> get initialConversations => [
    ChatConversation(
      id: 'chat_1',
      agentId: agent1.id,
      agentName: agent1.name,
      agentAvatar: agent1.avatarUrl,
      propertyTitle: 'Modern Haven Villa with Infinity Pool',
      propertyThumbnail: 'assets/images/house1.jpg',
      unreadCount: 1,
      messages: [
        MessageItem(
          id: 'm1',
          senderId: agent1.id,
          text: 'Hello! Thanks for your interest in Modern Haven Villa. How can I assist you today?',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isFromMe: false,
        ),
        MessageItem(
          id: 'm2',
          senderId: 'user',
          text: 'Hi Sarah, is this property available for an in-person viewing this Saturday?',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          isFromMe: true,
        ),
        MessageItem(
          id: 'm3',
          senderId: agent1.id,
          text: 'Yes! We have slots open at 11:00 AM and 3:00 PM. Feel free to use the Schedule Tour button anytime!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          isFromMe: false,
        ),
      ],
    ),
    ChatConversation(
      id: 'chat_2',
      agentId: agent3.id,
      agentName: agent3.name,
      agentAvatar: agent3.avatarUrl,
      propertyTitle: 'Skyline Penthouse with Panoramic Terrace',
      propertyThumbnail: 'assets/images/house2.jpg',
      unreadCount: 0,
      messages: [
        MessageItem(
          id: 'm201',
          senderId: agent3.id,
          text: 'Hi! Elena here from Horizon Grand Estates. The Skyline Penthouse comes fully furnished if preferred.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isFromMe: false,
        ),
        MessageItem(
          id: 'm202',
          senderId: 'user',
          text: 'That sounds fantastic! Are utilities included in the monthly lease?',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          isFromMe: true,
        ),
        MessageItem(
          id: 'm203',
          senderId: agent3.id,
          text: 'Water, gas, and building concierge services are fully covered in the rate.',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          isFromMe: false,
        ),
      ],
    ),
  ];

  // -------------------------------------------------------------
  // INITIAL NOTIFICATIONS
  // -------------------------------------------------------------
  static List<AppNotification> get initialNotifications => [
    AppNotification(
      id: 'notif_1',
      title: 'Tour Confirmed 🎉',
      message: 'Your in-person tour for Modern Haven Villa is confirmed for Saturday at 11:00 AM.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      type: NotificationType.tour,
      isRead: false,
      propertyId: 'prop_1',
    ),
    AppNotification(
      id: 'notif_2',
      title: 'Price Drop Alert 🏷️',
      message: 'Skyline Penthouse in Downtown NY has dropped from \$5,500/mo to \$5,200/mo.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: NotificationType.priceDrop,
      isRead: false,
      propertyId: 'prop_2',
    ),
    AppNotification(
      id: 'notif_3',
      title: 'New Luxury Listing ✨',
      message: 'A new 4-bedroom architectural villa in Los Angeles has just been listed.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.system,
      isRead: true,
      propertyId: 'prop_5',
    ),
  ];
}
