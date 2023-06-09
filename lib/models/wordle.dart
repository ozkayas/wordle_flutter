import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';


class Wordle extends Equatable{
  final String word;

  const Wordle({required this.word});

  Wordle copyWith({String? word}){
    return Wordle(
      word: word ?? this.word
    );
  }

  @override
  List<Object?> get props => [word];
}

extension on Wordle {

}


/// TODO: Why this method is outside of the class???
/// iki string alip trial ve target [1,0,0,-1,1] seklinda sonuc donen bi comparator lazim
List<int> calculateFlag(String target, String wordle,
    [Function(String letter)? paintLetter]) {
  if (kDebugMode) {
    print(target);
  }
  // String target = 'EVRAK';
  //String wordle = 'DACCE';
  List<int> flags = [0, 0, 0, 0, 0];

  var targetList = target.split('');
  var wordleList = wordle.split('');

  //Firstly fill flag 1s
  for (var i = 0; i < wordleList.length; i++) {
    if (wordleList[i] == targetList[i]) {
      flags[i] = 1;
    }
  }
  //Remove chars at green places
  for (var i = 0; i < flags.length; i++) {
    if (flags[i] == 1) {
      targetList.remove(wordleList[i]);
    }
  }

  //Secondly loop over remaining letters and fill flag -1s if target contains any
  for (var i = 0; i < wordleList.length; i++) {
    if (flags[i] != 1 && targetList.contains(wordleList[i])) {
      flags[i] = -1;
      targetList.remove(wordleList[i]);
    }
  }

  // for (var i = 0; i < wordleList.length; i++) {
  //   //Paint non existing letters for keyboard
  //   if (flags[i] == 0) {
  //     paintLetter(wordleList[i]);
  //   }
  // }

  //print(flags);
  return flags;
}
