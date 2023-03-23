part of 'table_cubit.dart';

class TableState extends Equatable {
  final List<String> words;
  final String targetWord;
  final List<List<Letter>>? wordsAsLetters;

  const TableState({required this.words, required this.targetWord, this.wordsAsLetters});

  TableState.initial()
      : words = List.generate(6, (index) => '     '),
        wordsAsLetters = List.generate(6, (index) => [...List.generate(5, (_) => const Letter.empty())]),
        targetWord = '';

  TableState copyWith({
    List<String>? words,
    String? targetWord,
    List<List<Letter>>? wordsAsLetters,
  }) {
    return TableState(
      words: words ?? this.words,
      targetWord: targetWord ?? this.targetWord,
      wordsAsLetters: wordsAsLetters ?? this.wordsAsLetters,
    );
  }

  @override
  String toString() {
    return words.toString() + targetWord;
  }

  @override
  List<Object?> get props => [words, targetWord];
}

extension Helper on TableState {
  /// Returns the letter models for a given row (index)
  List<Letter> lettersForRow(int index) {
    String word = words[index];
    String targetWord = this.targetWord;

    //String target = 'E V R A K';
    //String wordle = 'D A C C E';
    List<int> flags = [0, 0, 0, 0, 0];

    var wordAsList = word.split('');
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

    for (int i = 0; i < targetAsList.length; i++) {
      letters.add(Letter(char: wordAsList[i], flag: flags[i]));
    }

    return letters;
  }
}
