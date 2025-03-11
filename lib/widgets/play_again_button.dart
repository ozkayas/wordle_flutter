// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_flutter/core/theme/app_color_ext.dart';
import 'package:wordle_flutter/core/theme/app_text.dart';
import 'package:wordle_flutter/features/keyboard/keyboard_cubit.dart';
import 'package:wordle_flutter/features/table/cubit/table_cubit.dart';

class PlayAgainButton extends StatefulWidget {
  const PlayAgainButton({super.key});

  @override
  State<PlayAgainButton> createState() => _PlayAgainButtonState();
}

class _PlayAgainButtonState extends State<PlayAgainButton> {
  final showMeanings = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: context.color.onBackground,
            offset: Offset(5.0, 5.0),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ], color: context.color.scaffoldBackground, borderRadius: BorderRadius.circular(16)),
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
AppTxt.targetWord(context.read<TableCubit>().targetWord),
              style: TextStyle(fontSize: 24, color: context.color.onBackground),
            ),
            const SizedBox(height: 16),
            showMeaning(context),
            const SizedBox(height: 16),
            playAgain(context),
          ],
        ),
      ),
    );
  }

  Widget showMeaning(BuildContext context) {
    final buttonWidth = MediaQuery.sizeOf(context).width * 0.5;
    return ValueListenableBuilder<bool>(
        valueListenable: showMeanings,
        builder: (context, value, child) {
          if (value) {
            final meanings = context.read<TableCubit>().meanings;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < meanings.length; i++)
                  Text(
                    "${i + 1}. ${meanings[i].replaceAll("► ", "")}",
                    style: TextStyle(fontSize: 16, color: context.color.onBackground),
                  ),
              ],
            );
          }

          return TextButton(
            onPressed: () => showMeanings.value = true,
            style: TextButton.styleFrom(
              fixedSize: Size(buttonWidth, 56),
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.green, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              AppTxt.showMeaning,
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          );
        });
  }

  Widget playAgain(BuildContext context) {
    final buttonWidth = MediaQuery.sizeOf(context).width * 0.5;
    return TextButton(
      onPressed: () {
        context.read<TableCubit>().resetTable();
        context.read<KeyboardCubit>().resetKeyboardState();
      },
      style: TextButton.styleFrom(
        fixedSize: Size(buttonWidth, 56),
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.green, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text(
        AppTxt.playAgain,
        style: TextStyle(fontSize: 24, color: Colors.green),
      ),
    );
  }
}
