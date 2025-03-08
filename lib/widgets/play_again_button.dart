// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_flutter/core/theme/app_text.dart';
import 'package:wordle_flutter/features/keyboard/keyboard_cubit.dart';
import 'package:wordle_flutter/features/table/cubit/table_cubit.dart';

class PlayAgainButton extends StatelessWidget {
  const PlayAgainButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(24)),
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                context.read<TableCubit>().resetTable();
                context.read<KeyboardCubit>().resetKeyboardState();
              },
              child: const Text(
                AppTxt.playAgain,
                style: TextStyle(fontSize: 30, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
