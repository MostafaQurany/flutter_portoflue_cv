import 'package:flutter/material.dart';
import 'package:flutter_portoflue_cv/core/localization/app_locale.dart';
import 'package:flutter_portoflue_cv/features/koolyum/domain/koolyum_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/atoms/project_chip.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../projects/domain/project.dart';
import '../providers/koolyum_details_provider.dart';
import '../widgets/koolyum_service_section.dart';

class KoolyumProjectDetailsPage extends ConsumerWidget {
  const KoolyumProjectDetailsPage({
    super.key,
    required this.project,
  });

  final ProjectModel project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(koolyumDetailsProvider);
    final currentLocale = ref.watch(localeProvider);
    final strings = AppStrings.of(currentLocale);
    final palette = context.palette;

    final labels = KoolyumLabels(
      keyFeatures: strings.koolyumKeyFeatures,
    );

    return detailsAsync.when(
      data: (details) => ResponsiveBuilder(
        mobileBuilder: (context) => _KoolyumContent(
          project: project,
          details: details,
          horizontalPadding: 20,
          labels: labels,
        ),
        tabletBuilder: (context) => _KoolyumContent(
          project: project,
          details: details,
          horizontalPadding: 28,
          labels: labels,
        ),
        desktopBuilder: (context) => _KoolyumContent(
          project: project,
          details: details,
          horizontalPadding: 48,
          labels: labels,
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          strings.errorLoadingDetails,
          style: TextStyle(color: palette.textPrimary),
        ),
      ),
    );
  }
}

class _KoolyumContent extends ConsumerWidget {
  const _KoolyumContent({
    required this.project,
    required this.details,
    required this.horizontalPadding,
    required this.labels,
  });

  final ProjectModel project;
  final double horizontalPadding;
  final KoolyumDetailsModel details;
  final KoolyumLabels labels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final currentLocale = ref.watch(localeProvider);
    final strings = AppStrings.of(currentLocale);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: palette.border),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [palette.surface, palette.surfaceMuted],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details.subtitle,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      details.title,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      details.summary,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: palette.textMuted,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: project.technologies
                          .map((tech) => ProjectChip(label: tech, compact: false))
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _TextSection(
                title: details.overviewTitle,
                body: details.overviewSummary,
              ),
              const SizedBox(height: 32),
              _TextSection(
                title: details.roleTitle,
                body: details.roleSummary,
              ),
              const SizedBox(height: 28),
              _BulletPanel(
                title: details.architectureTitle,
                items: details.architectureNotes,
              ),
              const SizedBox(height: 28),
              _BulletPanel(
                title: details.contributionTitle,
                items: details.contributionHighlights,
              ),
              const SizedBox(height: 36),
              Text(
                details.servicesTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                details.servicesSummary,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: palette.textMuted,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: details.services
                    .map(
                      (service) => Chip(
                        label: Text(service.title),
                        avatar: Icon(
                          Icons.hub_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: 24),
              ...details.services.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: KoolyumServiceSection(
                    service: service,
                    labels: labels,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                strings.koolyumDetailFootnote,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextSection extends StatelessWidget {
  const _TextSection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: palette.textMuted,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _BulletPanel extends StatelessWidget {
  const _BulletPanel({
    required this.title,
    required this.items,
  });

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: palette.textMuted,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
