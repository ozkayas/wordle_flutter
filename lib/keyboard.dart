import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordle_flutter/built_in_keyboard.dart';

class KeyBoardWidget extends StatefulWidget {
  const KeyBoardWidget(
      {Key? key, required this.textController, required this.handleEnter})
      : super(key: key);
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
    // return Container(
    //   margin: EdgeInsets.all(10.w),
    //   color: Colors.orangeAccent,
    //   height: 120.h,
    //   width: 360.w,
    // );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: BuiltInKeyboard(
        handleEnter: handleEnter,
        layoutType: 'TR',
        borderRadius: BorderRadius.circular(8),
        controller: textController,
        enableLongPressUppercase: false,
        enableSpaceBar: false,
        enableBackSpace: true,
        enableCapsLock: false,
        color: Colors.blueGrey.shade100,
      ),
    );
  }
}
