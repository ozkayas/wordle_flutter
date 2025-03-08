// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_flutter/core/theme/app_color_ext.dart';

import 'enums.dart';
import 'built_in_keyboard.dart';
import 'keyboard_cubit.dart';

// Wrapper Widget around forked built_in_keyboard package
class KeyBoardWidget extends StatefulWidget {
  const KeyBoardWidget({
    super.key,
    required this.textController,
    required this.handleEnter,
  });
  final TextEditingController textController;
  final VoidCallback handleEnter;

  @override
  _KeyBoardWidgetState createState() => _KeyBoardWidgetState();
}

class _KeyBoardWidgetState extends State<KeyBoardWidget> {
  late TextEditingController textController;
  late VoidCallback handleEnter;

  @override
  void initState() {
    super.initState();
    textController = widget.textController;
    handleEnter = widget.handleEnter;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: BlocBuilder<KeyboardCubit, Map<String, LetterState>>(
        builder: (context, state) {
          return BuiltInTRKeyboard(
            handleEnter: handleEnter,
            layoutType: 'TR',
            letterStatus: state,
            letterStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: context.color.text),
            borderRadius: BorderRadius.circular(8),
            controller: textController,
            enableLongPressUppercase: false,
            enableSpaceBar: false,
            enableBackSpace: true,
            enableCapsLock: false,
            color: context.color.boxDefault,
          );
        },
      ),
    );
  }
}
