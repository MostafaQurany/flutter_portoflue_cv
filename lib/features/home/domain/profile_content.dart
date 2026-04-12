class ProfileContent {
  const ProfileContent({
    required this.greeting,
    required this.name,
    required this.role,
    required this.summary,
    required this.primaryCtaLabel,
    required this.secondaryCtaLabel,
    required this.stats,
    required this.techStack,
    required this.services,
    required this.aboutTitle,
    required this.aboutSummary,
  });

  final String greeting;
  final String name;
  final String role;
  final String summary;
  final String primaryCtaLabel;
  final String secondaryCtaLabel;
  final List<ProfileStat> stats;
  final List<String> techStack;
  final List<ProfileService> services;
  final String aboutTitle;
  final String aboutSummary;

  factory ProfileContent.fromJson(Map<String, dynamic> json) {
    return ProfileContent(
      greeting: json['greeting'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      primaryCtaLabel: json['primaryCtaLabel'] as String? ?? '',
      secondaryCtaLabel: json['secondaryCtaLabel'] as String? ?? '',
      stats: (json['stats'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProfileStat.fromJson)
          .toList(growable: false),
      techStack: (json['techStack'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      services: (json['services'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProfileService.fromJson)
          .toList(growable: false),
      aboutTitle: json['aboutTitle'] as String? ?? '',
      aboutSummary: json['aboutSummary'] as String? ?? '',
    );
  }
}

class ProfileStat {
  const ProfileStat({required this.value, required this.label});

  final String value;
  final String label;

  factory ProfileStat.fromJson(Map<String, dynamic> json) {
    return ProfileStat(
      value: json['value'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }
}

class ProfileService {
  const ProfileService({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final String icon;

  factory ProfileService.fromJson(Map<String, dynamic> json) {
    return ProfileService(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}
