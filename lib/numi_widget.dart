import 'package:flutter/material.dart';

class NumiWidget extends StatelessWidget {
  final int points;
  final bool isOverfed;

  const NumiWidget({
    super.key,
    required this.points,
    this.isOverfed = false,
  });

  int get stage {
    if (points <= 5) return 0;
    if (points <= 30) return 1;
    if (points <= 60) return 2;
    if (points <= 100) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(160, 180),
          painter: NumiPainter(stage: stage, isOverfed: isOverfed),
        ),
        const SizedBox(height: 8),
        Text(
          _getMessage(),
          style: const TextStyle(color: Colors.grey, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          _getName(),
          style: const TextStyle(
            color: Color(0xFF2196F3),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildProgressBar() {
    final int nextMilestone = stage == 0
        ? 6
        : stage == 1
            ? 31
            : stage == 2
                ? 61
                : stage == 3
                    ? 101
                    : 101;
    final int prevMilestone = stage == 0
        ? 0
        : stage == 1
            ? 6
            : stage == 2
                ? 31
                : stage == 3
                    ? 61
                    : 101;
    final double progress = stage == 4
        ? 1.0
        : ((points - prevMilestone) / (nextMilestone - prevMilestone))
            .clamp(0.0, 1.0);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stage == 4
              ? 'Max level reached! $points pts'
              : '$points pts · next evolution at $nextMilestone pts',
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
      ],
    );
  }

  String _getName() {
    if (stage == 0) return '';
    if (isOverfed) return 'Numi is a bit full today!';
    switch (stage) {
      case 1: return 'Numi just hatched!';
      case 2: return 'Numi Jr.';
      case 3: return 'Numi Pro';
      case 4: return 'Numi Max';
      default: return '';
    }
  }

  String _getMessage() {
    if (stage == 0) return 'Log your meals and water to hatch Numi!';
    if (isOverfed) return 'Try to balance your calories today';
    switch (stage) {
      case 1: return 'Numi is happy you started tracking!';
      case 2: return 'Numi is growing strong!';
      case 3: return 'Numi is glowing with health!';
      case 4: return 'Numi has reached ultimate form!';
      default: return '';
    }
  }
}

class NumiPainter extends CustomPainter {
  final int stage;
  final bool isOverfed;

  NumiPainter({required this.stage, required this.isOverfed});

  final Paint _paint = Paint()..style = PaintingStyle.fill;
  final Paint _stroke = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.65;

    if (stage == 0) {
      _drawEgg(canvas, cx, cy, 0);
    } else if (stage == 1) {
      _drawEgg(canvas, cx, cy, 3);
    } else {
      _drawCreature(canvas, cx, cy - 20, stage, isOverfed);
    }
  }

  void _drawEgg(Canvas canvas, double cx, double cy, int crackLevel) {
    _paint.color = const Color(0xFFFFF8E7);
    _stroke.color = const Color(0xFFFAC775);

    final eggPath = Path()
      ..addOval(Rect.fromCenter(
          center: Offset(cx, cy), width: 80, height: 110));
    canvas.drawPath(eggPath, _paint);
    canvas.drawPath(eggPath, _stroke);

    if (crackLevel >= 1) {
      _stroke.color = const Color(0xFFFAC775);
      _stroke.strokeWidth = 2;
      final p1 = Path()
        ..moveTo(cx - 8, cy - 35)
        ..lineTo(cx - 2, cy - 22)
        ..lineTo(cx + 7, cy - 30);
      canvas.drawPath(p1, _stroke);
    }

    if (crackLevel >= 2) {
      final p2 = Path()
        ..moveTo(cx + 12, cy - 20)
        ..lineTo(cx + 5, cy - 8)
        ..lineTo(cx + 16, cy - 4);
      canvas.drawPath(p2, _stroke);
    }

    if (crackLevel >= 3) {
      _paint.color = const Color(0xFFA8D8EA);
      canvas.drawCircle(Offset(cx, cy - 16), 18, _paint);

      _paint.color = const Color(0xFF2C3E50);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx - 6, cy - 18), width: 10, height: 13),
          _paint);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx + 6, cy - 18), width: 10, height: 13),
          _paint);

      _paint.color = Colors.white;
      canvas.drawCircle(Offset(cx - 5, cy - 19), 3, _paint);
      canvas.drawCircle(Offset(cx + 7, cy - 19), 3, _paint);

      _stroke.color = const Color(0xFF2C3E50);
      _stroke.strokeWidth = 1.5;
      final smile = Path()
        ..moveTo(cx - 5, cy - 8)
        ..quadraticBezierTo(cx, cy - 4, cx + 5, cy - 8);
      canvas.drawPath(smile, _stroke);

      _stroke.color = const Color(0xFFA8D8EA);
      _stroke.strokeWidth = 2.5;
      final a1 = Path()
        ..moveTo(cx - 9, cy - 30)
        ..quadraticBezierTo(cx - 12, cy - 38, cx - 7, cy - 34);
      final a2 = Path()
        ..moveTo(cx + 9, cy - 30)
        ..quadraticBezierTo(cx + 12, cy - 38, cx + 7, cy - 34);
      canvas.drawPath(a1, _stroke);
      canvas.drawPath(a2, _stroke);
    }
  }

  void _drawCreature(
      Canvas canvas, double cx, double cy, int stage, bool overfed) {
    final bodyR = stage == 2 ? 28.0 : stage == 3 ? 34.0 : 40.0;
    final headR = stage == 2 ? 22.0 : stage == 3 ? 26.0 : 30.0;
    const bodyColor = Color(0xFFA8D8EA);
    const wingColor = Color(0xFF85C1E9);

    _paint.color = wingColor.withValues(alpha: 0.7);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx - bodyR * 0.9, cy + 10),
            width: bodyR * 1.2,
            height: bodyR * 0.9),
        _paint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx + bodyR * 0.9, cy + 10),
            width: bodyR * 1.2,
            height: bodyR * 0.9),
        _paint);

    _paint.color = bodyColor;
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx, cy + 10),
            width: bodyR * 2,
            height: bodyR * (overfed ? 2.2 : 1.8)),
        _paint);
    canvas.drawCircle(Offset(cx, cy - headR * 0.3), headR, _paint);

    final eyeSize = headR * 0.24;
    _paint.color = const Color(0xFF2C3E50);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx - headR * 0.32, cy - headR * 0.35),
            width: eyeSize * 2,
            height: eyeSize * 2.5),
        _paint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx + headR * 0.32, cy - headR * 0.35),
            width: eyeSize * 2,
            height: eyeSize * 2.5),
        _paint);

    _paint.color = Colors.white;
    canvas.drawCircle(
        Offset(cx - headR * 0.26, cy - headR * 0.4), eyeSize * 0.7, _paint);
    canvas.drawCircle(
        Offset(cx + headR * 0.38, cy - headR * 0.4), eyeSize * 0.7, _paint);

    _stroke.color = const Color(0xFF2C3E50);
    _stroke.strokeWidth = 1.5;
    final smile = Path()
      ..moveTo(cx - headR * 0.3, cy + headR * 0.05)
      ..quadraticBezierTo(
          cx, cy + headR * 0.2, cx + headR * 0.3, cy + headR * 0.05);
    canvas.drawPath(smile, _stroke);

    final antennaColor =
        stage >= 4 ? const Color(0xFFFAC775) : const Color(0xFFA8D8EA);
    _stroke.color = antennaColor;
    _stroke.strokeWidth = stage >= 4 ? 3.5 : 2.5;
    final a1 = Path()
      ..moveTo(cx - headR * 0.28, cy - headR * 0.85)
      ..quadraticBezierTo(
          cx - headR * 0.38, cy - headR * 1.3, cx - headR * 0.22, cy - headR * 1.1);
    final a2 = Path()
      ..moveTo(cx + headR * 0.28, cy - headR * 0.85)
      ..quadraticBezierTo(
          cx + headR * 0.38, cy - headR * 1.3, cx + headR * 0.22, cy - headR * 1.1);
    canvas.drawPath(a1, _stroke);
    canvas.drawPath(a2, _stroke);

    if (stage >= 3) {
      _paint.color = const Color(0xFFFAC775)
          .withValues(alpha: stage >= 4 ? 0.9 : 0.7);
      final sparkles = [
        Offset(cx - bodyR * 1.1, cy - headR * 1.0),
        Offset(cx + bodyR * 1.0, cy - headR * 0.8),
        Offset(cx + bodyR * 0.8, cy - headR * 1.4),
      ];
      if (stage >= 4) {
        sparkles.addAll([
          Offset(cx - bodyR * 0.7, cy - headR * 1.5),
          Offset(cx, cy - headR * 1.7),
        ]);
      }
      for (final s in sparkles) {
        canvas.drawCircle(s, stage >= 4 ? 4.5 : 3.5, _paint);
      }
    }

    _paint.color = wingColor;
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx - bodyR * 0.45, cy + bodyR * 0.75),
            width: bodyR * 0.45,
            height: bodyR * 0.28),
        _paint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx + bodyR * 0.45, cy + bodyR * 0.75),
            width: bodyR * 0.45,
            height: bodyR * 0.28),
        _paint);
  }

  @override
  bool shouldRepaint(NumiPainter oldDelegate) =>
      oldDelegate.stage != stage || oldDelegate.isOverfed != isOverfed;
}