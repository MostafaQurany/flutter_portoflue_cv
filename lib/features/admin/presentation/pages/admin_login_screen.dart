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

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref.read(adminSessionProvider.notifier).signIn();
    context.go(RoutePaths.adminAddProject);
  }

  @override
  Widget build(BuildContext context) {
    return PortfolioScaffold(
      currentSection: PortfolioSection.contacts,
      child: SingleChildScrollView(
        child: SectionContainer(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: ResponsiveBuilder(
            mobileBuilder: (context) => _AdminLoginCard(
              formKey: _formKey,
              usernameController: _usernameController,
              passwordController: _passwordController,
              onSubmit: _submit,
            ),
            tabletBuilder: (context) => _AdminLoginCard(
              formKey: _formKey,
              usernameController: _usernameController,
              passwordController: _passwordController,
              onSubmit: _submit,
            ),
            desktopBuilder: (context) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: _AdminLoginCard(
                  formKey: _formKey,
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                  onSubmit: _submit,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminLoginCard extends ConsumerWidget {
  const _AdminLoginCard({
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final strings = AppStrings.of(currentLocale);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.adminLogin, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                strings.adminSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: strings.username),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return strings.enterUsername;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: strings.password),
                validator: (value) {
                  if (value == null || value.trim().length < 4) {
                    return strings.enterPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  child: Text(strings.enterAdminArea),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
