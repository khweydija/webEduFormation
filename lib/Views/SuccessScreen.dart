import 'package:flutter/material.dart';

class SignUpSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedCheckMark(),
            SizedBox(height: 20),
            Text(
              'Your Sign up was successful',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Navigate to Home Screen
                Navigator.pushNamed(context, '/home');
              },
              child: Text(
                'Continue to Home',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCheckMark extends StatefulWidget {
  @override
  _AnimatedCheckMarkState createState() => _AnimatedCheckMarkState();
}

class _AnimatedCheckMarkState extends State<AnimatedCheckMark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: Stack(
        children: [
          Center(
            child: CustomPaint(
              painter: CirclePainter(),
              size: Size(150, 150),
            ),
          ),
          Center(
            child: CustomPaint(
              painter: CheckMarkPainter(progress: _animation.value),
              size: Size(150, 150), // Adjust the size to match the circle
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return false;
  }
}

class CheckMarkPainter extends CustomPainter {
  final double progress;

  CheckMarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.5); // Start within the circle
    path.lineTo(size.width * 0.45, size.height * 0.65);
    path.lineTo(size.width * 0.75, size.height * 0.35);

    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(0.0, pathMetrics.length * progress);

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(CheckMarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
