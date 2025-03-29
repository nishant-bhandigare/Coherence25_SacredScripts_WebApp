import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather/weather.dart';


class SunriseSunset extends StatelessWidget {
  SunriseSunset({super.key, required this.weather});
  Weather? weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.15,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(34, 42, 54, 1),
        // color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        // border: Border.all(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SunItem(time: "${weather?.sunrise?.hour}:${weather?.sunrise?.minute}" ?? "N/A", sunrise: true),
          SizedBox(
            width: 200,
            height: 200,
            child: CustomPaint(
              painter: ArcPainter(),
            ),
          ),
          SunItem(time: "${weather?.sunset?.hour}:${weather?.sunrise?.minute}" ?? "N/A", sunrise: false),
        ],
      ),
      // child: DashedArchWidget(),
    );
  }
}

class SunItem extends StatelessWidget {
  final String time;
  final bool sunrise;

  const SunItem({Key? key, required this.time, required this.sunrise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(sunrise ? "assets/icons/sunrise.png" : "assets/icons/sunset.png", width: 25, color: Colors.white,),
        const SizedBox(height: 5),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
      ],
    );
  }
}

class Arch extends StatelessWidget {
  const Arch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.5,
      decoration: BoxDecoration(border: Border.all()),
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
          startAngle: -180,
          endAngle: 0,
          showTicks: false,
          showLabels: false,
          axisLineStyle: const AxisLineStyle(thickness: 1, color: Colors.black, dashArray: <double>[5,10]),
        )
      ]),
    );
  }
}

// class ArcPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;
//
//     var path = Path()
//       ..addArc(
//         Rect.fromLTWH(0, 0, size.width, size.height),
//         3.14, // startAngle in radians
//         3.20, // sweepAngle in radians
//       );
//
//     // Draw a dashed arc within the Container
//     canvas.drawPath(
//       dashPath(
//         path,
//         dashArray: CircularIntervalList<double>(<double>[5.0, 5.0]),
//       ),
//       paint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    var path = Path()
      ..addArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        3.14, // startAngle in radians
        3.20, // sweepAngle in radians
      );

    // Draw a dashed arc within the Container
    canvas.drawPath(
      dashPath(
        path,
        dashArray: CircularIntervalList<double>(<double>[5.0, 5.0]),
      ),
      paint,
    );

    // Calculate start and end points of the dashed arc
    final startPoint = path.getBounds().topLeft;
    final endPoint = path.getBounds().bottomRight;

    // Modify position and shape of the ellipse
    final offsetX =1.0; // Modify the X-coordinate to change the horizontal position
    final offsetY = 15.0; // Modify the Y-coordinate to change the vertical position
    final ellipseWidth = 50.0; // Modify the width of the ellipse
    final ellipseHeight = 30.0; // Modify the height of the ellipse

    // Draw a filled ellipse with modified position and shape
    // paint.style = PaintingStyle.fill;
    // canvas.drawOval(
    //   Rect.fromPoints(
    //     Offset(startPoint.dx + offsetX, startPoint.dy + offsetY),
    //     Offset(endPoint.dx - offsetX, endPoint.dy - offsetY),
    //   ).inflate(1),
    //   paint,
    // );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}