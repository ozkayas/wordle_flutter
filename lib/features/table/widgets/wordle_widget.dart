
// A row of 5 CharBoxes
import 'package:flutter/material.dart';
import 'package:wordle_flutter/models/wordle.dart';

import 'charbox.dart';

class WordleWidget extends StatelessWidget {
  const WordleWidget({Key? key, required this.wordle}) : super(key: key);
  final Wordle wordle;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        wordle.letters.map((letter) => CharBox(letter: letter)).toList());
  }
}
