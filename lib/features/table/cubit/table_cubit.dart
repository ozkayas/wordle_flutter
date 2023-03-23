import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/letter.dart';

part 'table_state.dart';

class TableCubit extends Cubit<TableState> {
  TableCubit() : super(TableState.initial());

  late final TextEditingController  textController;
  String targetWord = '';

  /// We have 6 wordles in a Column, which one is active at the moment?
  /// increment this when enter pressed and guess is evaluated
  int activeWordIndex = 0;
  String activeText = '';

  void initTextEditingController(){
    textController = TextEditingController();
  }

  void letterOnTap(String text) {
    if (text == activeText.trimRight()) return;

    if (text.length < 5) {
      activeText = text.padRight(5);
    } else {
      activeText = text.substring(0, 5);
    }

    print("===> Active Text:$activeText");
    print(state.toString());

    /// fill active wordle with the activeText
    List<String> newWordsList = [...state.words];
    newWordsList[activeWordIndex] = activeText;

    var newLetterListForActiveIndex = List<Letter>.from(lettersFromWord(activeText));
    var newWordsAsLetters =  List<List<Letter>>.from(state.wordsAsLetters!);
    newWordsAsLetters[activeWordIndex] = newLetterListForActiveIndex;
    final newTableState = state.copyWith(
      words: newWordsList,
      targetWord: targetWord,
      wordsAsLetters: newWordsAsLetters,
    );
    emit(newTableState);
  }

  void enterOnTap() {
    if (activeText.trimRight().length < 5) return;

    List<Letter> list = colorizeLettersForIndex(activeWordIndex);
    List<List<Letter>> allNewList = [...?state.wordsAsLetters];
    allNewList[activeWordIndex] = List<Letter>.from(list);
    final newState = state.copyWith(
      wordsAsLetters: allNewList,
    );
    // print(newState == state);
    emit(newState);
    activeWordIndex++;
    activeText = '';
    textController.clear();
  }

  void resetTable() {
    // targetWord = targets[Random().nextInt(targets.length)];
    targetWord = "KALEM";

    activeWordIndex = 0;
    activeText = '';

    emit(TableState.initial());
  }

  ///Convert List<String> words of the state to List<List<Letter>> wordsAsLetters
  List<List<Letter>> lettersFromWordsList(List<String> words) {
    List<List<Letter>> result = [];

    for (int i = activeWordIndex; i<words.length; i++) {
    // for (String word in words) {
      List<Letter> list = [];
      for (int j = 0; j < words[i].length; j++) {
        list.add(Letter(char: words[i][j], flag: 2));
      }
      result.add(list);
    }
    return result;
  }

  ///Convert List<String> words of the state to List<List<Letter>> wordsAsLetters
  List<Letter> lettersFromWord(String word) {
    List<Letter> result = [];

    for (int i = 0; i < word.length; i++) {
      // for (String word in words) {

      result.add(Letter(char: word[i], flag: 2));
    }
    return result;
  }

  ///Colorizes the letter of a selected row, after calculations
  List<Letter> colorizeLettersForIndex(int index) {
    //String target = 'E V R A K';
    //String wordle = 'D A C C E';
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
