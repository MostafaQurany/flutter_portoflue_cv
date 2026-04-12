class Project {
  const Project({
    required this.title,
    required this.description,
    required this.githubUrl,
    required this.stack,
  });

  final String title;
  final String description;
  final String githubUrl;
  final List<String> stack;
}
