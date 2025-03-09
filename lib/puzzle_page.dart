// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:turkish/turkish.dart';
import 'package:wordle_flutter/core/theme/app_color_ext.dart';
import 'package:wordle_flutter/widgets/play_again_button.dart';
import 'package:wordle_flutter/repositories/words_repository.dart';
import 'package:wordle_flutter/widgets/settings_button.dart';

import 'core/theme/app_text.dart';
import 'features/keyboard/keyboard.dart';
import 'features/keyboard/keyboard_cubit.dart';
import 'features/table/cubit/table_cubit.dart';
import 'features/table/models/letter.dart';
import 'features/table/widgets/wordle_table.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TableCubit()),
        BlocProvider(create: (_) => KeyboardCubit()),
      ],
      child: const PuzzleView(),
    );
  }
}

class PuzzleView extends StatefulWidget {
  const PuzzleView({super.key});

  @override
  _PuzzleViewState createState() => _PuzzleViewState();
}

class _PuzzleViewState extends State<PuzzleView> {
  bool gameOver = false;

  late TableCubit tableCubit;
  late KeyboardCubit keyboardCubit;

  @override
  void initState() {
    super.initState();

    tableCubit = context.read<TableCubit>();
    keyboardCubit = context.read<KeyboardCubit>();
    tableCubit.initTextEditingController();
    tableCubit.resetTable();
    keyboardCubit.resetKeyboardState();

    tableCubit.textController.addListener(() {
      if (tableCubit.textController.text.length > 5) {
        tableCubit.textController.text = tableCubit.textController.text.substring(0, 5);
      }
      tableCubit.letterOnTap(tableCubit.textController.text);
    });
  }

  @override
  void dispose() {
    tableCubit.textController.dispose();
    super.dispose();
  }

  void paintKeyboard(List<Letter> letters) {
    for (Letter letter in letters) {
      keyboardCubit.paintLetter(letter.char, letter.flag);
    }
  }

  void onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      /// enter ise
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        bool isValid = WordsRepository.targets.contains(tableCubit.activeText);
        if (!isValid && mounted) {
          showToast(
            AppTxt.invalidWord,
            alignment: Alignment.center,
            position: StyledToastPosition.center,
            context: context,
            animation: StyledToastAnimation.scale,
          );
          return;
        }
        tableCubit.enterOnTap(context, paintKeyboard);
      }

      /// delete ise
      else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        String activeText = tableCubit.textController.text;
        tableCubit.textController.text = activeText.substring(0, activeText.length - 1);
      } else if (event.logicalKey.keyLabel.length == 1 &&
          (RegExp(r'[a-z]').hasMatch(event.logicalKey.keyLabel) ||
              RegExp(r'[A-Z]').hasMatch(event.logicalKey.keyLabel) ||
              event.logicalKey.keyLabel == 'ı' ||
              event.logicalKey.keyLabel == 'I' ||
              event.logicalKey.keyLabel == 'ç' ||
              event.logicalKey.keyLabel == 'Ç' ||
              event.logicalKey.keyLabel == 'i' ||
              event.logicalKey.keyLabel == 'İ' ||
              event.logicalKey.keyLabel == 'ğ' ||
              event.logicalKey.keyLabel == 'Ğ' ||
              event.logicalKey.keyLabel == 'ö' ||
              event.logicalKey.keyLabel == 'Ö' ||
              event.logicalKey.keyLabel == 'ü' ||
              event.logicalKey.keyLabel == 'Ü' ||
              event.logicalKey.keyLabel == 'ş' ||
              event.logicalKey.keyLabel == 'Ş')) {
        if (event.character != null) {
          if (tableCubit.textController.text.length >= 5) {
            return;
          }
          String currentActiveText = tableCubit.textController.text;
          currentActiveText += event.character!.toUpperCaseTr();
          tableCubit.textController.text = currentActiveText;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKeyEvent: onKeyEvent,
      child: Scaffold(
        backgroundColor: context.color.scaffoldBackground,
        body: Center(
          child: ValueListenableBuilder<bool>(
              valueListenable: tableCubit.isGameOver,
              builder: (context, gameOver, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SettingsButton(),
                          const Spacer(flex: 75),
                          const WordleTable(),
                          const Spacer(flex: 100),
                          keyboard(context)
                        ],
                      ),
                    ),
                    if (true) const PlayAgainButton()
                    // if (gameOver) const PlayAgainButton()
                  ],
                );
              }),
        ),
      ),
    );
  }

  KeyBoardWidget keyboard(BuildContext context) {
    return KeyBoardWidget(
      textController: context.read<TableCubit>().textController,
      handleEnter: () {
        bool isValid = WordsRepository.targets.contains(tableCubit.activeText);
        if (!isValid && mounted) {
          showToast(
            AppTxt.invalidWord,
            alignment: Alignment.center,
            position: StyledToastPosition.center,
            context: context,
            animation: StyledToastAnimation.scale,
          );
          return;
        }
        tableCubit.enterOnTap(context, paintKeyboard);
      }, //handleEnter,
    );
  }
}
