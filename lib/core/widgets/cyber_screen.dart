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

class AnimatedCyberCard extends StatelessWidget {
  const AnimatedCyberCard({
    super.key,
    required this.child,
    this.onTap,
    this.order = 0,
  });

  final Widget child;
  final VoidCallback? onTap;
  final int order;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + (order * 55)),
      curve: Curves.easeOutQuart,
      builder: (context, value, currentChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: Transform.scale(
              scale: 0.985 + (value * 0.015),
              child: currentChild,
            ),
          ),
        );
      },
      child: CyberCard(onTap: onTap, child: child),
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

/// Terminal interactif : affiche un historique de commandes et un champ de saisie.
/// [expectedCommand] est la commande attendue (comparaison insensible à la casse, espaces ignorés).
/// [successOutput] est la sortie affichée après une commande correcte.
/// [onSuccess] est appelé quand la commande est validée.
class InteractiveTerminal extends StatefulWidget {
  const InteractiveTerminal({
    super.key,
    required this.prompt,
    required this.expectedCommand,
    required this.successOutput,
    required this.onSuccess,
    this.hint,
    this.initialLines = const [],
    this.alreadyDone = false,
  });

  final String prompt;
  final String expectedCommand;
  final String successOutput;
  final VoidCallback onSuccess;
  final String? hint;
  final List<String> initialLines;
  final bool alreadyDone;

  @override
  State<InteractiveTerminal> createState() => _InteractiveTerminalState();
}

class _InteractiveTerminalState extends State<InteractiveTerminal> {
  final TextEditingController _inputCtrl = TextEditingController();
  final List<String> _lines = [];
  bool _done = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _lines.addAll(widget.initialLines);
    if (widget.alreadyDone) {
      _lines.add('\$ ${widget.expectedCommand}');
      _lines.add(widget.successOutput);
      _done = true;
    }
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final input = _inputCtrl.text.trim();
    if (input.isEmpty) return;
    final expected = widget.expectedCommand.trim().toLowerCase();
    final correct = input.toLowerCase() == expected;

    setState(() {
      _lines.add('\$ $input');
      _error = !correct;
      if (correct) {
        _lines.add(widget.successOutput);
        _done = true;
      } else {
        _lines.add('-bash: $input: command not found');
      }
      _inputCtrl.clear();
    });

    if (correct) widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _done
              ? const Color(0xFF00E5A8).withValues(alpha: 0.8)
              : (_error ? Colors.redAccent.withValues(alpha: 0.7) : const Color(0xFF00E5A8).withValues(alpha: 0.45)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // barre titre terminal
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00E5A8).withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                const Icon(Icons.terminal_rounded, size: 14, color: Color(0xFF65FFBF)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.prompt,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF65FFBF)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_done) const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF00E5A8)),
              ],
            ),
          ),
          // commande à saisir (instruction pédagogique)
          if (!_done)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Commande à saisir :',
                    style: TextStyle(fontSize: 11, color: Colors.white54),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E5A8).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF00E5A8).withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      widget.expectedCommand,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: Color(0xFF65FFBF),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // historique
          if (_lines.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Text(
                _lines.join('\n'),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: _done ? const Color(0xFF65FFBF) : Colors.white70,
                  height: 1.4,
                ),
              ),
            ),
          // champ de saisie
          if (!_done)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
              child: Row(
                children: [
                  const Text(
                    '\$ ',
                    style: TextStyle(fontFamily: 'monospace', color: Color(0xFF65FFBF), fontSize: 13),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _inputCtrl,
                      style: const TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: widget.hint ?? widget.expectedCommand,
                        hintStyle: const TextStyle(color: Colors.white24, fontFamily: 'monospace', fontSize: 13),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (_) => _submit(),
                      autofocus: false,
                    ),
                  ),
                  IconButton(
                    onPressed: _submit,
                    icon: const Icon(Icons.keyboard_return_rounded, size: 18, color: Color(0xFF00E5A8)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          if (!_done)
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Text(
                'Tape la commande ci-dessus puis appuie sur Entrée.',
                style: TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ),
        ],
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
