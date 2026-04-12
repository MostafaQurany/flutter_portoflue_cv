import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project form validated. Persistence is deferred to a future backend phase.'),
        ),
      );
    }
  }

  String? _validateRepositoryUrl(String? value) {
    final text = value?.trim() ?? '';
    final uri = Uri.tryParse(text);

    if (text.isEmpty || uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return 'Enter a valid URL';
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
              validateRepositoryUrl: _validateRepositoryUrl,
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
              validateRepositoryUrl: _validateRepositoryUrl,
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
              validateRepositoryUrl: _validateRepositoryUrl,
              isDesktop: true,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddProjectContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final header = isDesktop
        ? Row(
            children: [
              Expanded(child: _HeaderBlock()),
              TextButton(onPressed: onSignOut, child: const Text('Sign out')),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderBlock(),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onSignOut,
                  child: const Text('Sign out'),
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
                    decoration: const InputDecoration(labelText: 'Project title'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.trim().length < 20) {
                        return 'Enter at least 20 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: repositoryController,
                    decoration: const InputDecoration(labelText: 'Repository URL'),
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
                      'Thumbnail upload is intentionally deferred until storage and API contracts exist.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: onSubmit,
                      child: const Text('Submit project'),
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

class _HeaderBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add project', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          'Frontend-only admin form with validation and route protection in place.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
