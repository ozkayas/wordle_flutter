// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordle_flutter/keyboard/built_in_keyboard.dart';
import 'package:wordle_flutter/keyboard/cubit/keyboard_cubit.dart';

import '../models/enums.dart';

// Wrapper Widget around forked built_in_keyboard package
class KeyBoardWidget extends StatefulWidget {
  const KeyBoardWidget({
    Key? key,
    required this.textController,
    required this.handleEnter,
  }) : super(key: key);
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
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: BlocBuilder<KeyboardCubit, Map<String, LetterState>>(
        builder: (context, state) {
          return BuiltInKeyboard(
            handleEnter: handleEnter,
            layoutType: 'TR',
            letterStatus: state,
            borderRadius: BorderRadius.circular(8),
            controller: textController,
            enableLongPressUppercase: false,
            enableSpaceBar: false,
            enableBackSpace: true,
            enableCapsLock: false,
            color: Colors.blueGrey.shade300,
          );
        },
      ),
    );
  }
}
