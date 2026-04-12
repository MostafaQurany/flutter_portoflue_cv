class ContactContent {
  const ContactContent({
    required this.title,
    required this.summary,
    required this.items,
    required this.infoCards,
  });

  final String title;
  final String summary;
  final List<ContactItem> items;
  final List<ContactInfoCard> infoCards;

  factory ContactContent.fromJson(Map<String, dynamic> json) {
    return ContactContent(
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ContactItem.fromJson)
          .toList(growable: false),
      infoCards: (json['infoCards'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ContactInfoCard.fromJson)
          .toList(growable: false),
    );
  }
}

class ContactItem {
  const ContactItem({required this.type, required this.label});

  final String type;
  final String label;

  factory ContactItem.fromJson(Map<String, dynamic> json) {
    return ContactItem(
      type: json['type'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }
}

class ContactInfoCard {
  const ContactInfoCard({required this.title, required this.description});

  final String title;
  final String description;

  factory ContactInfoCard.fromJson(Map<String, dynamic> json) {
    return ContactInfoCard(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
