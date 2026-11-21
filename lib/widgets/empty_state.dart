import 'package:flutter/material.dart';

// Shown when a list has nothing in it: empty cart, no favorites, no orders...
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Scrollable, so it doesn't overflow on short screens (e.g. landscape),
    // but still centered when there's enough space.
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: _buildContent(context)),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          Text(title, style: TextTheme.of(context).titleMedium),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          if (buttonText != null) ...[
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30),
              ),
              child: Text(buttonText!),
            ),
          ],
        ],
      ),
    );
  }
}
