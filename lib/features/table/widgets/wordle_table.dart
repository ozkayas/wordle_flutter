import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_flutter/features/table/widgets/wordle_widget.dart';

import '../cubit/table_cubit.dart';

class WordleTable extends StatelessWidget {
  const WordleTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableCubit, TableState>(
      builder: (context, state) {
        return Column(
          children: state.wordsAsLetters!
              .map((wordAsLetter) => WordleWidget(word: '', letters: wordAsLetter))
              .intersperse(const SizedBox(height: 8))
              .toList(),
        );
      },
    );
  }
}
