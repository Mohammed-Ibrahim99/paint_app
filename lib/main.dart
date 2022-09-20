import 'dart:html';

import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: 'Flutter'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
                ),
                const SizedBox(
                  height: 10,
                ),
                /***************************************
                 * Buttons at the Bottom of the screen *
                 **************************************/
                Container(
                  width: width * 0.80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  child: Row(
                    children: <Widget>[
                      ButtonBar(
                        children: [
                          IconButton(onPressed: null,
                              icon: const Icon(Icons.color_lens)),
                          IconButton(onPressed: null,
                              icon: const Icon(Icons.layers_clear)),
                          IconButton(onPressed: null,
                              icon: const Icon(Icons.select_all))
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
