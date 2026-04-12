import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/project.dart';

final projectsProvider = Provider<List<Project>>((ref) {
  return const [
    Project(
      title: 'Commerce Dashboard',
      description:
          'A multi-role Flutter dashboard focused on clean data workflows, sales visibility, and responsive operations tooling.',
      githubUrl: 'https://github.com/example/commerce-dashboard',
      stack: ['Flutter', 'Riverpod', 'GoRouter'],
    ),
    Project(
      title: 'Portfolio CMS Shell',
      description:
          'A content-ready admin experience for managing portfolio entries, drafts, and presentation-friendly metadata.',
      githubUrl: 'https://github.com/example/portfolio-cms',
      stack: ['Flutter Web', 'Dart', 'REST-ready'],
    ),
    Project(
      title: 'Booking Experience',
      description:
          'A responsive reservation flow with explicit loading and error states, optimized for web and mobile surfaces.',
      githubUrl: 'https://github.com/example/booking-experience',
      stack: ['Flutter', 'Animations', 'Testing'],
    ),
  ];
});
