import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectLinkButton extends StatelessWidget {
  const ProjectLinkButton({
    super.key,
    required this.label,
    required this.icon,
    required this.url,
  });

  final String label;
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _openUrl(context),
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Future<void> _openUrl(BuildContext context) async {
    final uri = Uri.tryParse(url);

    if (uri == null || !await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unable to open $label link.')));
      }
    }
  }
}
