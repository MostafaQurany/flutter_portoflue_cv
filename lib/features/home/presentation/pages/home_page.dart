import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/section_container.dart';
import '../../../about/presentation/widgets/about_section_widget.dart';
import '../../domain/portfolio_section.dart';
import '../providers/home_bootstrap_provider.dart';
import '../providers/portfolio_scroll_provider.dart';
import '../widgets/contact_section.dart';
import '../../../projects/presentation/widgets/projects_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/home_startup_loader.dart';
import '../widgets/portfolio_scaffold.dart';
import '../widgets/tech_stack_marquee.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scroll = ref.watch(portfolioScrollControllerProvider);
    final bootstrap = ref.watch(homeBootstrapProvider);

    return PortfolioScaffold(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 420),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeIn,
        child: bootstrap.when(
          loading: () => const HomeStartupLoader(),
          error: (_, __) => const HomeStartupLoader(),
          data: (_) => LayoutBuilder(
            key: const ValueKey('home-content'),
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth <= 400 ? 16.0 : 24.0;
              final heroBottomPadding = constraints.maxWidth <= 400 ? 24.0 : 32.0;
              final sectionBottomPadding = constraints.maxWidth <= 400 ? 32.0 : 40.0;

              return SingleChildScrollView(
                controller: scroll.scrollController,
                child: Column(
                  children: [
                    KeyedSubtree(
                      key: scroll.sectionKeys[PortfolioSection.home],
                      child: SectionContainer(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          24,
                          horizontalPadding,
                          heroBottomPadding,
                        ),
                        child: const HeroSection(),
                      ),
                    ),
                    SectionContainer(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        28,
                      ),
                      child: const TechStackMarquee(),
                    ),
                    KeyedSubtree(
                      key: scroll.sectionKeys[PortfolioSection.about],
                      child: SectionContainer(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          8,
                          horizontalPadding,
                          sectionBottomPadding,
                        ),
                        child: const AboutSectionWidget(),
                      ),
                    ),
                    KeyedSubtree(
                      key: scroll.sectionKeys[PortfolioSection.projects],
                      child: SectionContainer(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          0,
                          horizontalPadding,
                          sectionBottomPadding,
                        ),
                        child: const ProjectsSection(),
                      ),
                    ),
                    KeyedSubtree(
                      key: scroll.sectionKeys[PortfolioSection.contacts],
                      child: SectionContainer(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          0,
                          horizontalPadding,
                          44,
                        ),
                        child: const ContactSection(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
