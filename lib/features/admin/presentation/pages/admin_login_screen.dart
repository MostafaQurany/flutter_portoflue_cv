import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class _AdminLoginCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Admin login', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                'This is a guarded frontend-only admin entry point prepared for future backend integration.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.trim().length < 4) {
                    return 'Enter at least 4 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text('Enter admin area'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
