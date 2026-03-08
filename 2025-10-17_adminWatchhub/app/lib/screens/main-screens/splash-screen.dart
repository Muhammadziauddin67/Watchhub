import 'package:flutter/material.dart';

void main() {
  runApp(WatchhubApp());
}

class WatchhubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WatchhubHome(),
    );
  }
}

class WatchhubHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: Size(100, 100),
              painter: ClockPainter(),
            ),
            SizedBox(width: 20),
            Text(
              'Watchhub',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintCircle = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Color(0xFFD4A95D); // Light gold color

    final hourHandPaint = Paint()
      ..color = Color(0xFFD4A95D)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final minuteHandPaint = Paint()
      ..color = Color(0xFFD4A95D)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Draw circle
    canvas.drawCircle(center, radius, paintCircle);

    // Hour hand (pointing at 2)
    final hourHandX = center.dx + radius * 0.5;
    final hourHandY = center.dy;
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandPaint);

    // Minute hand (pointing at 11)
    final minHandX = center.dx - radius * 0.3;
    final minHandY = center.dy - radius * 0.8;
    canvas.drawLine(center, Offset(minHandX, minHandY), minuteHandPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
