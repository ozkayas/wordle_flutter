import 'package:flutter/material.dart';
import 'package:wordle_flutter/core/theme/app_color_ext.dart';
import 'package:wordle_flutter/features/table/models/letter.dart';

// Visual Box for Letter objects
class CharBox extends StatelessWidget {
  const CharBox({super.key, required this.letter});
  final Letter letter;

  @override
  Widget build(BuildContext context) {
    final Color boxColor = letter.flag == 0
        ? context.color.boxDark
        : letter.flag == 1
            ? context.color.boxGreen
            : letter.flag == 2
                ? context.color.boxEmpty
                : context.color.boxYellow;
    final Color textColor = letter.flag == 2 ? context.color.passiveText : context.color.activeText;

    return AnimatedContainer(
      // margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: boxColor,
        boxShadow: [
          BoxShadow(
            color: context.color.onBackground.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      width: 60,
      height: 60,
      duration: const Duration(milliseconds: 400),
      child: Center(
          child: Text(
        letter.char,
        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: textColor),
      )),
    );
  }
}
