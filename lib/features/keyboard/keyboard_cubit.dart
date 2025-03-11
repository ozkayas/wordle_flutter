import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_flutter/features/keyboard/keyboard_state.dart';

import 'enums.dart';

class KeyboardCubit extends Cubit<Map<String, LetterState>> {
  KeyboardCubit() : super(Map.from(initialKeyboardState));

  //Harfler ver ilgili flag bilgisi 0,1,-1 buraya gelecek
  //Keyboard icin burada ayri degerlendirme yapilacak
  void paintLetter(String letter, int flag) {
    // var state = this.state;

    // print('$letter,$flag,${state[letter]}');

    //If letter state is not dark and not green
    if (state[letter] != LetterState.dark && state[letter] != LetterState.green) {
      //If letterState is already yellow
      if (state[letter] == LetterState.yellow) {
        if (flag == 1) {
          state[letter] = LetterState.green;
        }
      } else {
        flag == 1
            ? state[letter] = LetterState.green
            : flag == 0
                ? state[letter] = LetterState.dark
                : state[letter] = LetterState.yellow;
      }
    }

    emit(Map<String, LetterState>.from(state));
  }

  void resetKeyboardState() => emit(Map.from(initialKeyboardState));
}
