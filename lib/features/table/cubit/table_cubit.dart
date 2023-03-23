import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:turkish/turkish.dart';
import 'package:wordle_flutter/repositories/words_repository.dart';

import '../models/letter.dart';

part 'table_state.dart';

class TableCubit extends Cubit<TableState> {
  TableCubit() : super(TableState.initial());

  ValueNotifier<bool> isGameOver = ValueNotifier<bool>(false);
  late final TextEditingController textController;
  String targetWord = '';

  /// We have 6 wordles in a Column, which one is active at the moment?
  /// increment this when enter pressed and guess is evaluated
  int activeWordIndex = 0;
  String activeText = '';

  void initTextEditingController() {
    textController = TextEditingController();
  }

  void letterOnTap(String text) {
    if (text == activeText.trimRight()) return;

    if (text.length < 5) {
      activeText = text.padRight(5);
    } else {
      activeText = text.substring(0, 5);
    }

    /// fill active wordle with the activeText
    List<String> newWordsList = [...state.words];
    newWordsList[activeWordIndex] = activeText;

    var newLetterListForActiveIndex = List<Letter>.from(lettersFromWord(activeText));
    var newWordsAsLetters = List<List<Letter>>.from(state.wordsAsLetters!);
    newWordsAsLetters[activeWordIndex] = newLetterListForActiveIndex;
    final newTableState = state.copyWith(
      words: newWordsList,
      targetWord: targetWord,
      wordsAsLetters: newWordsAsLetters,
    );
    emit(newTableState);
  }

  Future<void> enterOnTap(BuildContext context, void Function(List<Letter> activeLetters) paintKeyboard) async {
    if (activeText.trimRight().length < 5) return;

    List<Letter> list = colorizeLettersForIndex(activeWordIndex);
    List<List<Letter>> allNewList = [...?state.wordsAsLetters];
    allNewList[activeWordIndex] = List<Letter>.from(list);
    final newState = state.copyWith(
      wordsAsLetters: allNewList,
    );
    // print(newState == state);
    emit(newState);
    paintKeyboard.call(newState.wordsAsLetters![activeWordIndex]);

    /// burada oyun bitti mi kontrolleri olacak/
    /// eger aktif indexteki flagler 0 veya -1 icermiyorsa
    ///
    if (isAllLettersGreen(state.wordsAsLetters![activeWordIndex])) {
      showToast(
        'BRAVO 🎉',
        alignment: Alignment.center,
        position: StyledToastPosition.center,
        context: context,
        animation: StyledToastAnimation.scale,
      );
      isGameOver.value = true;
    } else if (activeWordIndex == 5) {
      /// we are at the bottom on the list, and all letters are not green
      /// Game OVer
      showToast(
        'GAME OVER ⛔️',
        alignment: Alignment.center,
        position: StyledToastPosition.center,
        context: context,
        animation: StyledToastAnimation.scale,
      );
      isGameOver.value = true;
    } else {
      activeWordIndex++;
      activeText = '';
      textController.clear();
    }
  }

  void resetTable() {
    // targetWord = "KALEM";
      targetWord = WordsRepository.targets[Random().nextInt(WordsRepository.targets.length)].toUpperCaseTr();

    activeWordIndex = 0;
    activeText = '';
    textController.clear();
    isGameOver.value=false;

    emit(TableState.initial());


    //todo: reset keyboard also
  }

  bool isAllLettersGreen(List<Letter> letters) {
    for (var letter in letters) {
      if (letter.flag == 0 || letter.flag == -1) return false;
    }

    return true;
  }

  ///Convert List<String> words of the state to List<List<Letter>> wordsAsLetters
  List<Letter> lettersFromWord(String word) {
    List<Letter> result = [];

    for (int i = 0; i < word.length; i++) {
      result.add(Letter(char: word[i], flag: 2));
    }
    return result;
  }

  ///Colorizes the letter of a selected row, after calculations
  List<Letter> colorizeLettersForIndex(int index) {
    List<int> flags = [0, 0, 0, 0, 0];

    var wordAsList = activeText.split('');
    var targetAsList = targetWord.split('');

    //Firstly fill flag 1s
    for (var i = 0; i < wordAsList.length; i++) {
      if (wordAsList[i] == targetAsList[i]) {
        flags[i] = 1;
      }
    }
    //Remove chars at green places
    for (var i = 0; i < flags.length; i++) {
      if (flags[i] == 1) {
        targetAsList.remove(wordAsList[i]);
      }
    }

    //Secondly loop over remaining letters and fill flag -1s if target contains any
    for (var i = 0; i < wordAsList.length; i++) {
      if (flags[i] != 1 && targetAsList.contains(wordAsList[i])) {
        flags[i] = -1;
        targetAsList.remove(wordAsList[i]);
      }
    }

    ///Create List<Letter> using word and flags.
    final List<Letter> letters = [];

    for (int i = 0; i < wordAsList.length; i++) {
      letters.add(Letter(char: wordAsList[i], flag: flags[i]));
    }

    return letters;
  }
}
