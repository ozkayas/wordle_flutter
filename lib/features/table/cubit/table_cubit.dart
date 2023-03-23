import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/letter.dart';

part 'table_state.dart';

class TableCubit extends Cubit<TableState> {
  TableCubit() : super(TableState.initial());

  String targetWord = '';

  /// We have 6 wordles in a Column, which one is active at the moment?
  /// increment this when enter pressed and guess is evaluated
  int activeWordIndex = 0;
  String activeText = '';

  void letterOnTap(String text) {
    if (text == activeText.trimRight()) return;

    if (text.length < 5) {
      activeText = text.padRight(5);
    } else {
      activeText = text.substring(0, 5);
    }

    print(activeText);

    /// fill active wordle with the activeText
    List<String> newWordsList = [...state.words];
    newWordsList[activeWordIndex] = activeText;
    final newTableState = state.copyWith(
      words: newWordsList,
      targetWord: targetWord,
      wordsAsLetters: lettersFromWordsList(newWordsList),
    );
    emit(newTableState);
  }

  void enterOnTap() {}

  void resetTable() {
    // targetWord = targets[Random().nextInt(targets.length)];
    targetWord = "KALEM";

    activeWordIndex = 0;
    activeText = '';

    emit(TableState.initial());
  }

  ///Convert List<String> words of the state to List<List<Letter>> wordsAsLetters
  List<List<Letter>> lettersFromWordsList(List<String> words){

    List<List<Letter>> result = [];

    for(String word in words){
      List<Letter> list = [];
      for (int i = 0; i < word.length; i++) {
        list.add(Letter(char: word[i],flag: 2));
      }
      result.add(list);
    }
    return result;
  }
}
