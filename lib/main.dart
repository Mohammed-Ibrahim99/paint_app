// All credit goes to:
// https://www.youtube.com/watch?v=Zv5T2C1oKus
import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter'),
    );
  }
}

class DrawingArea
{
  Offset point;
  Paint areaPaint;

  DrawingArea({required this.point, required this.areaPaint});
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<DrawingArea?> points = [];
  Color selectedColor = Colors.black;
  double? strokeWidth;

  @override
  void initState()
  {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }
    void selectColour()
    {
      showDialog(context: context,
          builder: (context) => AlertDialog(
            title: const Text("Colour Chooser"),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color)
                {
                  this.setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ),
            // actions: <Widget>[
            //   FlatButton(
            //     onPressed: ()
            //         {
            //           Navigator.of(context).pop();
            //         },
            //     child: Text("Close"))
            // ],
          ),

      );
    }
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Colour for application
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                  [
                    Color.fromRGBO(138, 35, 135, 1),
                    Color.fromRGBO(233, 64, 87, 1),
                    Color.fromRGBO(242, 113, 33, 1),
                  ])),
          ),

          Center(
            /***************************************
             * Canvas where all items are painted *
             **************************************/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width * 0.80,
                  height: height * 0.80,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all((Radius.circular(20.0))),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 5.0,
                        spreadRadius: 1.0
                    )
                  ]
                  ),

                  /***************************************
                   * Detecting when user clicks on      *
                   * canvas to draw                     *
                   **************************************/
                  child: GestureDetector
                  (
                    //User Tapping on screen
                    onPanDown: (details)
                    {
                      this.setState((){points.add(DrawingArea(point: details.localPosition,
                          areaPaint: Paint()
                            ..strokeCap = StrokeCap.round
                            ..isAntiAlias = true
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth!));});
                    },

                    //User moving on screen
                    onPanUpdate: (details)
                    {
                      this.setState((){points.add(DrawingArea(point: details.localPosition,
                          areaPaint: Paint()
                            ..strokeCap = StrokeCap.round
                            ..isAntiAlias = true
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth!));});
                    },

                    //User removing finger from screen
                    onPanEnd: (details)
                    {
                      this.setState(() {
                        points.add(null);
                      });

                    },

                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: CustomPaint
                           (
                              painter: MyCustomPainter(points: points, color: selectedColor, strokeWidth: strokeWidth!),
                           ),
                  ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /***************************************
                 * Space between canvas and buttons    *
                 **************************************/

                const SizedBox
                (
                  height: 20
                ),

                /***************************************
                 * Buttons at the Bottom of the screen *
                 **************************************/

                Container(
                  width: width * 0.80,
                  decoration: const BoxDecoration
                  (
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  child: Row(
                    children: <Widget>[
                      ButtonBar(
                        children: [
                          IconButton(

                              onPressed: (){
                            selectColour();
                          }, icon: Icon(Icons.color_lens, color: selectedColor,)),

                          Expanded(

                              child: Slider(

                              min: 1.0,
                              max: 7.0,
                              activeColor: selectedColor,
                              value:strokeWidth!, onChanged:(value)
                          {
                            this.setState(() {
                              strokeWidth = value;
                            });
                          })),

                          IconButton(onPressed: (){
                            this.setState(() {
                              points.clear();
                            });
                          }, icon: Icon(Icons.layers_clear)),
                          
                        ],
                      )
                    ],
                  ),
                )
              ],

            ),


          )
        ]
    )
    );
  }
}


class MyCustomPainter extends CustomPainter
{
  List<DrawingArea?> points;
  Color color;
  double strokeWidth;

  MyCustomPainter({required this.points, required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size)
  {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);


    for(int x=0; x<points.length-1; x++)
      {
        if(points[x] != null && points[x+1] != null)
          {
            Paint paint = points[x]!.areaPaint;
            canvas.drawLine(points[x]!.point, points[x + 1]!.point, paint);
          }
        else if (points[x] != null && points[x+1] == null)
          {
            Paint paint = points[x]!.areaPaint;
            canvas.drawPoints(PointMode.points, [points[x]!.point], paint);
          }
      }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate)
  {
    return true;
  }

}
