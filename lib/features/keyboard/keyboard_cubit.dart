
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/enums.dart';

class KeyboardCubit extends Cubit<Map<String, LetterState>> {
  KeyboardCubit()
      : super({
          'E': LetterState.light,
          'R': LetterState.light,
          'T': LetterState.light,
          'Y': LetterState.light,
          'U': LetterState.light,
          'I': LetterState.light,
          'O': LetterState.light,
          'P': LetterState.light,
          'Ğ': LetterState.light,
          'Ü': LetterState.light,
          'A': LetterState.light,
          'S': LetterState.light,
          'D': LetterState.light,
          'F': LetterState.light,
          'G': LetterState.light,
          'H': LetterState.light,
          'J': LetterState.light,
          'K': LetterState.light,
          'L': LetterState.light,
          'Ş': LetterState.light,
          'İ': LetterState.light,
          'Z': LetterState.light,
          'C': LetterState.light,
          'V': LetterState.light,
          'B': LetterState.light,
          'N': LetterState.light,
          'M': LetterState.light,
          'Ö': LetterState.light,
          'Ç': LetterState.light,
        });

  //Harfler ver ilgili flag bilgisi 0,1,-1 buraya gelecek
  //Keyboard icin burada ayri degerlendirme yapilacak
  void paintLetter(String letter, int flag) {
    var state = this.state;

    // print('$letter,$flag,${state[letter]}');

    //If letter state is not dark and not green
    if (state[letter] != LetterState.dark &&
        state[letter] != LetterState.green) {
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

    emit(state);
  }

  void resetKeyboardState() => emit({
        'E': LetterState.light,
        'R': LetterState.light,
        'T': LetterState.light,
        'Y': LetterState.light,
        'U': LetterState.light,
        'I': LetterState.light,
        'O': LetterState.light,
        'P': LetterState.light,
        'Ğ': LetterState.light,
        'Ü': LetterState.light,
        'A': LetterState.light,
        'S': LetterState.light,
        'D': LetterState.light,
        'F': LetterState.light,
        'G': LetterState.light,
        'H': LetterState.light,
        'J': LetterState.light,
        'K': LetterState.light,
        'L': LetterState.light,
        'Ş': LetterState.light,
        'İ': LetterState.light,
        'Z': LetterState.light,
        'C': LetterState.light,
        'V': LetterState.light,
        'B': LetterState.light,
        'N': LetterState.light,
        'M': LetterState.light,
        'Ö': LetterState.light,
        'Ç': LetterState.light,
      });
}
