import 'package:flutter/material.dart';
import 'package:wordle_flutter/features/table/models/letter.dart';

// Visual Box for Letter objects
class CharBox extends StatelessWidget {
  const CharBox({super.key, required this.letter});
  final Letter letter;

  @override
  Widget build(BuildContext context) {
    final Color color = letter.flag == 0
        ? Colors.blueGrey.shade700
        : letter.flag == 1
            ? Colors.lightGreen
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
        style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
      )),
    );
  }
}
