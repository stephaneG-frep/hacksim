import 'package:flutter/material.dart';

class CyberScreen extends StatelessWidget {
  const CyberScreen({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF060B10), Color(0xFF101E2B), Color(0xFF051118)],
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _GridPainter(),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ],
    );
  }
}

class CyberCard extends StatelessWidget {
  const CyberCard({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF101C27),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00E5A8).withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5A8).withValues(alpha: 0.12),
            blurRadius: 14,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: child,
          ),
        ),
      ),
    );
  }
}

class TerminalPanel extends StatelessWidget {
  const TerminalPanel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00E5A8).withValues(alpha: 0.55)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'monospace',
          color: Color(0xFF65FFBF),
          height: 1.35,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5A8).withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const step = 28.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
