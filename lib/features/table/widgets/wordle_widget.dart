
// A row of 5 CharBoxes
import 'package:flutter/material.dart';
import 'package:wordle_flutter/features/table/models/letter.dart';
// ignore: unused_import
import 'package:wordle_flutter/models/wordle.dart';

import 'charbox.dart';

class WordleWidget extends StatelessWidget {
  const WordleWidget({super.key, required this.word, required this.targetWord});
  final String word;
  final String targetWord;

  List<CharBox> getCharBox(){
        return word.split('').map((e) => CharBox(letter: Letter(char: e))).toList();
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:getCharBox());
  }
}
