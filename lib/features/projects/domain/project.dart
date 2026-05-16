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

enum ProjectDetailsType {
  defaultProject,
  externalServerEcosystem;

  factory ProjectDetailsType.fromJson(String? value) {
    return switch (value) {
      'external_server_ecosystem' => ProjectDetailsType.externalServerEcosystem,
      _ => ProjectDetailsType.defaultProject,
    };
  }
}

class ProjectModel {
  final String id;
  final String title;
  final String subtitle;
  final String cardDescription;
  final String fullDescription;
  final List<String> technologies;
  final String logo;
  final List<String> screenshots;
  final ProjectLinks links;
  final ProjectDetailsType detailsType;
  final String? detailsDataKey;
  final bool isExternalServerData;

  ProjectModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.cardDescription,
    required this.fullDescription,
    required this.technologies,
    required this.logo,
    required this.screenshots,
    required this.links,
    required this.detailsType,
    required this.detailsDataKey,
    required this.isExternalServerData,
  });

  ProjectModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? cardDescription,
    String? fullDescription,
    List<String>? technologies,
    String? logo,
    List<String>? screenshots,
    ProjectLinks? links,
    ProjectDetailsType? detailsType,
    String? detailsDataKey,
    bool? isExternalServerData,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      cardDescription: cardDescription ?? this.cardDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      technologies: technologies ?? this.technologies,
      logo: logo ?? this.logo,
      screenshots: screenshots ?? this.screenshots,
      links: links ?? this.links,
      detailsType: detailsType ?? this.detailsType,
      detailsDataKey: detailsDataKey ?? this.detailsDataKey,
      isExternalServerData: isExternalServerData ?? this.isExternalServerData,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final title = json['title'] ?? '';
    final detailsType = ProjectDetailsType.fromJson(json['detailsType'] as String?);
    return ProjectModel(
      id: (json['id'] as String?)?.trim().isNotEmpty == true
          ? (json['id'] as String).trim()
          : _slugifyTitle(title),
      title: title,
      subtitle: json['subtitle'] ?? '',
      cardDescription: json['cardDescription'] ?? '',
      fullDescription: json['fullDescription'] ?? '',
      technologies: List<String>.from(json['technologies'] ?? []),
      logo: json['logo'] ?? '',
      screenshots: List<String>.from(json['screenshots'] ?? []),
      links: ProjectLinks.fromJson(json['links'] ?? {}),
      detailsType: detailsType,
      detailsDataKey: (json['detailsDataKey'] as String?)?.trim().isNotEmpty == true
          ? (json['detailsDataKey'] as String).trim()
          : null,
      isExternalServerData:
          json['isExternalServerData'] == true ||
          detailsType == ProjectDetailsType.externalServerEcosystem,
    );
  }
}

String _slugifyTitle(String title) {
  final normalized = title
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
  return normalized.isEmpty ? 'project' : normalized;
}
