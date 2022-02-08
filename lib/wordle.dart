import 'package:flutter/foundation.dart';

class Wordle {
  List<Letter> letters = List.filled(5, Letter.empty());

  Wordle(this.letters);

  String asString() {
    return letters.fold('', (prev, element) => prev + element.char);
  }
}

class Letter {
  String char;
  int flag;

  Letter(this.char, this.flag);

  Letter.empty([this.char = '', this.flag = 2]);
}

/// iki string alip trial ve target [1,0,0,-1,1] seklinda sonuc donen bi comparator lazim
List<int> calculateFlag(
    String target, String wordle, Function(String letter) paintLetter) {
  if (kDebugMode) {
    print(target);
  }
  // String target = 'MERAK';
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

  for (var i = 0; i < wordleList.length; i++) {
    //Paint non existing letters for keyboard
    if (flags[i] == 0) {
      paintLetter(wordleList[i]);
    }
  }

  //print(flags);
  return flags;
}

// TODO: https://sozluk.gov.tr/gts?ara=kaput
// {"error":"Sonuç bulunamadı"} == hata gelirse donen response
