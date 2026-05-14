import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/widgets/section_container.dart';
import '../../../home/domain/portfolio_section.dart';
import '../../../home/presentation/widgets/portfolio_scaffold.dart';
import '../providers/admin_session_provider.dart';

class AddProjectScreen extends ConsumerStatefulWidget {
  const AddProjectScreen({super.key});

  @override
  ConsumerState<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends ConsumerState<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repositoryController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _repositoryController.dispose();
    super.dispose();
  }

  void _submit() {
    final strings = AppStrings.of(ref.read(localeProvider));
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.formValidated),
        ),
      );
    }
  }

  String? _validateRepositoryUrl(String? value, AppStrings strings) {
    final text = value?.trim() ?? '';
    final uri = Uri.tryParse(text);

    if (text.isEmpty || uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return strings.enterValidUrl;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PortfolioScaffold(
      currentSection: PortfolioSection.projects,
      child: SingleChildScrollView(
        child: SectionContainer(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: ResponsiveBuilder(
            mobileBuilder: (context) => _AddProjectContent(
              formKey: _formKey,
              titleController: _titleController,
              descriptionController: _descriptionController,
              repositoryController: _repositoryController,
              onSignOut: () {
                ref.read(adminSessionProvider.notifier).signOut();
                context.go(RoutePaths.adminLogin);
              },
              onSubmit: _submit,
              validateRepositoryUrl: (v) => _validateRepositoryUrl(v, AppStrings.of(ref.watch(localeProvider))),
              isDesktop: false,
            ),
            tabletBuilder: (context) => _AddProjectContent(
              formKey: _formKey,
              titleController: _titleController,
              descriptionController: _descriptionController,
              repositoryController: _repositoryController,
              onSignOut: () {
                ref.read(adminSessionProvider.notifier).signOut();
                context.go(RoutePaths.adminLogin);
              },
              onSubmit: _submit,
              validateRepositoryUrl: (v) => _validateRepositoryUrl(v, AppStrings.of(ref.watch(localeProvider))),
              isDesktop: false,
            ),
            desktopBuilder: (context) => _AddProjectContent(
              formKey: _formKey,
              titleController: _titleController,
              descriptionController: _descriptionController,
              repositoryController: _repositoryController,
              onSignOut: () {
                ref.read(adminSessionProvider.notifier).signOut();
                context.go(RoutePaths.adminLogin);
              },
              onSubmit: _submit,
              validateRepositoryUrl: (v) => _validateRepositoryUrl(v, AppStrings.of(ref.watch(localeProvider))),
              isDesktop: true,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddProjectContent extends ConsumerWidget {
  const _AddProjectContent({
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.repositoryController,
    required this.onSignOut,
    required this.onSubmit,
    required this.validateRepositoryUrl,
    required this.isDesktop,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController repositoryController;
  final VoidCallback onSignOut;
  final VoidCallback onSubmit;
  final String? Function(String? value) validateRepositoryUrl;
  final bool isDesktop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final strings = AppStrings.of(currentLocale);

    final header = isDesktop
        ? Row(
            children: [
              const Expanded(child: _HeaderBlock()),
              TextButton(onPressed: onSignOut, child: Text(strings.signOut)),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeaderBlock(),
              const SizedBox(height: 12),
              Align(
                alignment: currentLocale == AppLocale.en ? Alignment.centerLeft : Alignment.centerRight,
                child: TextButton(
                  onPressed: onSignOut,
                  child: Text(strings.signOut),
                ),
              ),
            ],
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: strings.projectTitle),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return strings.enterTitle;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    minLines: 4,
                    maxLines: 6,
                    decoration: InputDecoration(labelText: strings.projectDescription),
                    validator: (value) {
                      if (value == null || value.trim().length < 20) {
                        return strings.enterDescription;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: repositoryController,
                    decoration: InputDecoration(labelText: strings.repositoryUrl),
                    validator: validateRepositoryUrl,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Text(
                      strings.thumbnailDeferred,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: currentLocale == AppLocale.en ? Alignment.centerLeft : Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onSubmit,
                      child: Text(strings.submitProject),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderBlock extends ConsumerWidget {
  const _HeaderBlock();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(ref.watch(localeProvider));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(strings.addProject, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          strings.adminFormSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
