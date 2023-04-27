import 'package:flutter/material.dart';
import 'package:solid_software_test/feature/bg_color_change/ui/hello_there.dart';

void main() {
  runApp(const Main());
}

///
class Main extends StatelessWidget {
  ///Initial flutter widget which contains the MaterialApp widget.
  const Main({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solid Software test',
      theme: ThemeData(),
      home: const HelloThere(),
    );
  }
}
