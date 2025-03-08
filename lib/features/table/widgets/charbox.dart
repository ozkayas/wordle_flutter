import 'package:flutter/material.dart';
import 'package:wordle_flutter/core/theme/app_color_ext.dart';
import 'package:wordle_flutter/features/table/models/letter.dart';

// Visual Box for Letter objects
class CharBox extends StatelessWidget {
  const CharBox({super.key, required this.letter});
  final Letter letter;

  @override
  Widget build(BuildContext context) {
    final Color color = letter.flag == 0
        ? context.color.boxDark
        : letter.flag == 1
            ? context.color.boxGreen
            : letter.flag == 2
                ? Colors.blueGrey.shade300
                : Colors.yellow.shade700;
    return AnimatedContainer(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: color,
      ),
      width: 60,
      height: 60,
      duration: const Duration(milliseconds: 400),
      child: Center(
          child: Text(
        letter.char,
        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: context.color.text),
      )),
    );
  }
}
