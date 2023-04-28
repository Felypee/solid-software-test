import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:solid_software_test/feature/bg_color_change/utils/message_list.dart';

///
class HelloThere extends StatefulWidget {
  final Color? _bgColor;
  final Color? _textColor;
  final Color? _illustrationColor;

  /// A stateful widget that displays a "Hello there" phrase in the
  /// center of the screen,
  /// and changes the screen color to a random color when the user
  /// taps on the screen.
  const HelloThere({
    Key? key,
    Color? bgColor,
    Color? textColor,
    Color? illustrationColor,
  })  : _bgColor = bgColor,
        _textColor = textColor,
        _illustrationColor = illustrationColor,
        super(key: key);

  @override
  _HelloThereState createState() => _HelloThereState();
}

class _HelloThereState extends State<HelloThere> {
  ///It is used for assigning a new random color
  Color _bgColor = Colors.black;
  Color _textColor = Colors.white;
  Color _illustrationColor = Colors.blue;

  //Color code bits limit
  int colorCodeLimit = 256;

  ///Phrase text size
  final double _textSize = 30.0;

  ///It is used for showing the first message of the words list
  int _currentIndex = 0;

  ///Create random instance
  final random = math.Random();

  //Luminance limit
  final double luminanceLimit = 0.7;

  //padding percentage
  ///width 5% left-right
  final double widthPercentage = 0.05;

  ///height 20% top-bottom
  final double heigthPercentage = 0.2;

  @override
  void initState() {
    super.initState();
    _bgColor = widget._bgColor ?? Colors.black;
    _textColor = widget._textColor ?? Colors.white;
    _illustrationColor = widget._illustrationColor ?? Colors.blue;
  }

  void _changeColor() {
    // Generate three random integers between 0 and 255 to represent
    // the RGB values
    final r = random.nextInt(colorCodeLimit);
    final g = random.nextInt(colorCodeLimit);
    final b = random.nextInt(colorCodeLimit);

    // Use the RGB values to create a new Color object with 100% opacity
    //(alpha value of 255)
    final newColor = Color.fromARGB(255, r, g, b);
    // Calculate the luminance of the new color to determine whether the
    // text color should be black or white
    final luminance = (0.299 * newColor.red +
                0.587 * newColor.green +
                0.114 * newColor.blue) /
            colorCodeLimit -
        1;
    // Update the state variables to reflect the new background color and
    // text color

    _bgColor = newColor;
    // If the luminance is greater than 0.5 (i.e., the color is light),
    // use black text; otherwise, use white text
    _textColor = luminance > luminanceLimit ? Colors.black : Colors.white;
    //Generate the color for the illustration
    _illustrationColor = Color.fromARGB(
      colorCodeLimit - 1,
      random.nextInt(colorCodeLimit),
      random.nextInt(colorCodeLimit),
      random.nextInt(colorCodeLimit),
    );
  }

  void _changeMessage() {
    ///This mathematical formula is to jump to the next index and to
    /// restart the message to the first index after tapping the last index
    _currentIndex = (_currentIndex + 1) % words.length;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {
            _changeColor();
            _changeMessage();
          });
        }
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              width: size.width,
              height: size.height,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * widthPercentage,
                vertical: size.height * heigthPercentage,
              ),
              duration: const Duration(milliseconds: 500),
              color: _bgColor,
            ),
            ColorFiltered(
              colorFilter:
                  ColorFilter.mode(_illustrationColor, BlendMode.srcATop),
              child: Lottie.asset(
                "images/bg_illustration.json",
                height: size.height,
                width: size.width,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                words[_currentIndex],
                key: ValueKey<int>(_currentIndex),
                style: TextStyle(fontSize: _textSize, color: _textColor),
              ),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
