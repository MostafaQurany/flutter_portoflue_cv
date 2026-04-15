class ProjectLinks {
  final String googlePlay;
  final String appStore;
  final String githubUrl;

  ProjectLinks({
    required this.googlePlay,
    required this.appStore,
    required this.githubUrl,
  });

  factory ProjectLinks.fromJson(Map<String, dynamic> json) {
    return ProjectLinks(
      googlePlay: json['googlePlay'] ?? '',
      appStore: json['appStore'] ?? '',
      githubUrl: json['githubUrl'] ?? '',
    );
  }
}

class ProjectModel {
  final String title;
  final String subtitle;
  final String cardDescription;
  final String fullDescription;
  final List<String> technologies;
  final String logo;
  final List<String> screenshots;
  final ProjectLinks links;

  ProjectModel({
    required this.title,
    required this.subtitle,
    required this.cardDescription,
    required this.fullDescription,
    required this.technologies,
    required this.logo,
    required this.screenshots,
    required this.links,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      cardDescription: json['cardDescription'] ?? '',
      fullDescription: json['fullDescription'] ?? '',
      technologies: List<String>.from(json['technologies'] ?? []),
      logo: json['logo'] ?? '',
      screenshots: List<String>.from(json['screenshots'] ?? []),
      links: ProjectLinks.fromJson(json['links'] ?? {}),
    );
  }
}
