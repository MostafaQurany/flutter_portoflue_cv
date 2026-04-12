class Project {
  const Project({
    required this.title,
    required this.description,
    required this.githubUrl,
    required this.stack,
    this.screenshots = const [],
  });

  final String title;
  final String description;
  final String githubUrl;
  final List<String> stack;
  final List<String> screenshots;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      githubUrl: json['githubUrl'] as String? ?? '',
      stack: (json['technologies'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      screenshots: (json['screenshots'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
    );
  }
}

