// A row of 5 CharBoxes
import 'package:flutter/material.dart';
import 'package:wordle_flutter/features/table/models/letter.dart';
// ignore: unused_import
import 'package:wordle_flutter/models/wordle.dart';

import 'charbox.dart';

class WordleWidget extends StatelessWidget {
  const WordleWidget({
    super.key,
    required this.word,
    // required this.targetWord,
    this.letters,
  });
  final String word;
  // final String targetWord;
  final List<Letter>? letters;

  List<CharBox> getCharBox() {
    if (letters != null && letters!.isEmpty) {
      return word.split('').map((e) => CharBox(letter: Letter(char: e))).toList();
    } else {
      return letters!.map((letter) => CharBox(letter: letter)).toList();
    }

    // return const [
    //   CharBox(letter: Letter.empty()),
    //   CharBox(letter: Letter.empty()),
    //   CharBox(letter: Letter.empty()),
    //   CharBox(letter: Letter.empty()),
    //   CharBox(letter: Letter.empty()),
    // ];
  }

  @override
  Widget build(BuildContext context) {
    // print("=== building a wordle row");
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: getCharBox());
  }
}
