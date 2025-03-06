// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:turkish/turkish.dart';
import 'package:wordle_flutter/repositories/words_repository.dart';

import 'app_text.dart';
import 'features/keyboard/keyboard.dart';
import 'features/keyboard/keyboard_cubit.dart';
import 'features/table/cubit/table_cubit.dart';
import 'features/table/models/letter.dart';
import 'features/table/widgets/wordle_table.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TableCubit>(
      create: (_) => TableCubit(),
      child: const PuzzleView(),
    );
  }
}

class PuzzleView extends StatefulWidget {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  _PuzzleViewState createState() => _PuzzleViewState();
}

class _PuzzleViewState extends State<PuzzleView> {
  //Game is over
  //Game is over
  //Game is over
  bool gameOver = false;

  late TableCubit cubit;
  late KeyboardCubit _keyboardCubit;

  @override
  void initState() {
    super.initState();

    cubit = context.read<TableCubit>();
    cubit.initTextEditingController();
    cubit.resetTable();

    cubit.textController.addListener(() {
      if (cubit.textController.text.length > 5) {
        cubit.textController.text = cubit.textController.text.substring(0, 5);
      }
      cubit.letterOnTap(cubit.textController.text);
      // context.read<TableCubit>().resetTable();
    });
  }

  @override
  void dispose() {
    cubit.textController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _keyboardCubit = BlocProvider.of<KeyboardCubit>(context);
    super.didChangeDependencies();
  }

  void paintKeyboard(List<Letter> letters) {
    for (Letter letter in letters) {
      _keyboardCubit.paintLetter(letter.char, letter.flag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // https://www.youtube.com/watch?v=5ykfmHhJUu4
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent) {
            /// enter ise
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              bool isValid = WordsRepository.targets.contains(cubit.activeText);
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
              cubit.enterOnTap(context, paintKeyboard);
            }

            /// delete ise
            else if (event.logicalKey == LogicalKeyboardKey.backspace) {
              String activeText = cubit.textController.text;
              cubit.textController.text = activeText.substring(0, activeText.length - 1);
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
                if (cubit.textController.text.length >= 5) {
                  return;
                }
                String currentActiveText = cubit.textController.text;
                currentActiveText += event.character!.toUpperCaseTr();
                cubit.textController.text = currentActiveText;
              }
            }
          }
        },
        child: Scaffold(
          body: Center(
            child: ValueListenableBuilder<bool>(
                valueListenable: cubit.isGameOver,
                builder: (context, gameOver, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const WordleTable(),
                            const Spacer(),
                            KeyBoardWidget(
                              textController: context.read<TableCubit>().textController,
                              handleEnter: () {
                                bool isValid = WordsRepository.targets.contains(cubit.activeText);
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
                                cubit.enterOnTap(context, paintKeyboard);
                              }, //handleEnter,
                            )
                          ],
                        ),
                      ),
                      if (gameOver)
                        Positioned(
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
                            //height: 200.h,
                            width: 320,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    cubit.resetTable();
                                    _keyboardCubit.resetKeyboardState();
                                  },
                                  child: const Text(
                                    AppTxt.playAgain,
                                    style: TextStyle(fontSize: 30, color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
