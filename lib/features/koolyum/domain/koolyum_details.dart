class KoolyumDetailsModel {
  const KoolyumDetailsModel({
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.overviewTitle,
    required this.overviewSummary,
    required this.roleTitle,
    required this.roleSummary,
    required this.servicesTitle,
    required this.servicesSummary,
    required this.architectureTitle,
    required this.architectureNotes,
    required this.contributionTitle,
    required this.contributionHighlights,
    required this.ecosystemFlowchartTitle,
    required this.ecosystemFlowchartTd,
    required this.services,
  });

  final String title;
  final String subtitle;
  final String summary;
  final String overviewTitle;
  final String overviewSummary;
  final String roleTitle;
  final String roleSummary;
  final String servicesTitle;
  final String servicesSummary;
  final String architectureTitle;
  final List<String> architectureNotes;
  final String contributionTitle;
  final List<String> contributionHighlights;
  final String ecosystemFlowchartTitle;
  final String ecosystemFlowchartTd;
  final List<KoolyumServiceModel> services;

  factory KoolyumDetailsModel.fromJson(Map<String, dynamic> json) {
    return KoolyumDetailsModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      overviewTitle: json['overviewTitle'] as String? ?? '',
      overviewSummary: json['overviewSummary'] as String? ?? '',
      roleTitle: json['roleTitle'] as String? ?? '',
      roleSummary: json['roleSummary'] as String? ?? '',
      servicesTitle: json['servicesTitle'] as String? ?? '',
      servicesSummary: json['servicesSummary'] as String? ?? '',
      architectureTitle: json['architectureTitle'] as String? ?? '',
      architectureNotes: (json['architectureNotes'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      contributionTitle: json['contributionTitle'] as String? ?? '',
      contributionHighlights:
          (json['contributionHighlights'] as List<dynamic>? ?? const [])
              .whereType<String>()
              .toList(growable: false),
      ecosystemFlowchartTitle: json['ecosystemFlowchartTitle'] as String? ?? '',
      ecosystemFlowchartTd: json['ecosystemFlowchartTd'] as String? ?? '',
      services: (json['services'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(KoolyumServiceModel.fromJson)
          .toList(growable: false),
    );
  }
}

class KoolyumServiceModel {
  const KoolyumServiceModel({
    required this.id,
    required this.title,
    required this.kind,
    required this.repoPath,
    required this.shortDescription,
    required this.fullDescription,
    required this.responsibilities,
    required this.keyFeatures,
    required this.techStack,
    required this.contractsOrEndpoints,
    required this.flowchartTitle,
    required this.flowchartTd,
    required this.evidenceNotes,
  });

  final String id;
  final String title;
  final String kind;
  final String repoPath;
  final String shortDescription;
  final String fullDescription;
  final List<String> responsibilities;
  final List<String> keyFeatures;
  final List<String> techStack;
  final List<String> contractsOrEndpoints;
  final String flowchartTitle;
  final String flowchartTd;
  final List<String> evidenceNotes;

  factory KoolyumServiceModel.fromJson(Map<String, dynamic> json) {
    return KoolyumServiceModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      kind: json['kind'] as String? ?? '',
      repoPath: json['repoPath'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      fullDescription: json['fullDescription'] as String? ?? '',
      responsibilities:
          (json['responsibilities'] as List<dynamic>? ?? const [])
              .whereType<String>()
              .toList(growable: false),
      keyFeatures: (json['keyFeatures'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      techStack: (json['techStack'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      contractsOrEndpoints:
          (json['contractsOrEndpoints'] as List<dynamic>? ?? const [])
              .whereType<String>()
              .toList(growable: false),
      flowchartTitle: json['flowchartTitle'] as String? ?? '',
      flowchartTd: json['flowchartTd'] as String? ?? '',
      evidenceNotes: (json['evidenceNotes'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
    );
  }
}
