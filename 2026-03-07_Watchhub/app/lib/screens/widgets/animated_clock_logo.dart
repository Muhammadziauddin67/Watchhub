import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnimatedClockLogo extends StatefulWidget {
  final double size;
  const AnimatedClockLogo({super.key, this.size = 130});

  @override
  State<AnimatedClockLogo> createState() => _AnimatedClockLogoState();
}

class _AnimatedClockLogoState extends State<AnimatedClockLogo>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late DateTime _startTime;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();

    // 🕐 Start from your design time: 1:50:00
    _startTime = DateTime(2025, 1, 1, 1, 50, 0);

    // Drive animation frames
    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsed = elapsed;
      });
    });

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ⏱️ Simulated time — runs 6× faster than real time
    final simulatedTime =
        _startTime.add(Duration(milliseconds: _elapsed.inMilliseconds * 6));

    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _ClockPainter(simulatedTime),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final DateTime time;
  _ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const gold = Color(0xFFD4A95D);

    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = gold;

    final hourHandPaint = Paint()
      ..color = gold
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final minuteHandPaint = Paint()
      ..color = gold
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final secondHandPaint = Paint()
      ..color = gold.withOpacity(0.8)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Outer ring
    canvas.drawCircle(center, radius, circlePaint);

    // 🕒 Calculate hand angles
    final hourAngle =
        ((time.hour % 12) + time.minute / 60 + time.second / 3600) *
                30 *
                pi /
                180 -
            pi / 2;
    final minuteAngle =
        (time.minute * 6 + time.second * 0.1) * pi / 180 - pi / 2;
    final secondAngle = (time.second * 6) * pi / 180 - pi / 2;

    // 🕐 Hour hand
    final hourHandLength = radius * 0.5;
    final hourHandEnd = Offset(
      center.dx + hourHandLength * cos(hourAngle),
      center.dy + hourHandLength * sin(hourAngle),
    );
    canvas.drawLine(center, hourHandEnd, hourHandPaint);

    // 🕑 Minute hand
    final minuteHandLength = radius * 0.75;
    final minuteHandEnd = Offset(
      center.dx + minuteHandLength * cos(minuteAngle),
      center.dy + minuteHandLength * sin(minuteAngle),
    );
    canvas.drawLine(center, minuteHandEnd, minuteHandPaint);

    // 🕒 Second hand (ticks)
    final secondHandLength = radius * 0.85;
    final secondHandEnd = Offset(
      center.dx + secondHandLength * cos(secondAngle),
      center.dy + secondHandLength * sin(secondAngle),
    );
    canvas.drawLine(center, secondHandEnd, secondHandPaint);

    // Center dot
    canvas.drawCircle(center, 5, Paint()..color = gold);
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) => true;
}
