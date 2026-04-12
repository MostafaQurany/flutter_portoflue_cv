import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/section_container.dart';
import '../../../about/presentation/widgets/about_section_widget.dart';
import '../../domain/portfolio_section.dart';
import '../providers/portfolio_scroll_provider.dart';
import '../widgets/contact_section.dart';
import '../../../projects/presentation/widgets/projects_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/portfolio_scaffold.dart';
import '../widgets/tech_stack_marquee.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scroll = ref.watch(portfolioScrollControllerProvider);

    return PortfolioScaffold(
      child: SingleChildScrollView(
        controller: scroll.scrollController,
        child: Column(
          children: [
            KeyedSubtree(
              key: scroll.sectionKeys[PortfolioSection.home],
              child: const SectionContainer(
                padding: EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: HeroSection(),
              ),
            ),
            const SectionContainer(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: TechStackMarquee(),
            ),
            KeyedSubtree(
              key: scroll.sectionKeys[PortfolioSection.about],
              child: const SectionContainer(
                padding: EdgeInsets.fromLTRB(24, 12, 24, 40),
                child: AboutSectionWidget(),
              ),
            ),
            KeyedSubtree(
              key: scroll.sectionKeys[PortfolioSection.projects],
              child: const SectionContainer(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: ProjectsSection(),
              ),
            ),
            KeyedSubtree(
              key: scroll.sectionKeys[PortfolioSection.contacts],
              child: const SectionContainer(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 48),
                child: ContactSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
