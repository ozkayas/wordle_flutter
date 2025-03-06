import 'package:flutter/material.dart';
import 'package:wordle_flutter/features/table/models/letter.dart';

import 'charbox.dart';

// A row of 5 CharBoxes
class WordleWidget extends StatelessWidget {
  const WordleWidget({
    super.key,
    required this.word,
    this.letters,
  });
  final String word;
  final List<Letter>? letters;

  List<CharBox> getCharBox() {
    if (letters != null && letters!.isEmpty) {
      return word.split('').map((e) => CharBox(letter: Letter(char: e))).toList();
    } else {
      return letters!.map((letter) => CharBox(letter: letter)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: getCharBox());
  }
}
