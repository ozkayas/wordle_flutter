import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/enums.dart';

class BuiltInTRKeyboard extends StatefulWidget {
  // layoutType of the keyboard
  final String layoutType;

  // The controller connected to the InputField
  final TextEditingController controller;

  // Vertical spacing between key rows
  final double spacing;

  // Border radius of the keys
  final BorderRadius? borderRadius;

  // Color of the keys
  final Color color;

  // TextStyle of the letters in the keys (fontsize, fontface)
  final TextStyle letterStyle;

  // the additional key that can be added to the keyboard
  // not in use actively at the moment
  final bool enableSpaceBar;
  final bool enableBackSpace;
  final bool enableCapsLock;

  // height and width of each key
  final double? height;
  final double? width;

  // Additional functionality for the keys //

  // Makes the keyboard uppercase
  final bool enableAllUppercase;

  // Long press to write uppercase letters
  final bool enableLongPressUppercase;

  // The color displayed when the key is pressed
  final Color? highlightColor;
  final Color? splashColor;

  // Callback for pressing enter
  final VoidCallback handleEnter;

  final Map<String, LetterState> letterStatus;

  const BuiltInTRKeyboard({
    super.key,
    required this.controller,
    required this.layoutType,
    required this.handleEnter,
    required this.letterStatus,
    this.height,
    this.width,
    this.spacing = 8.0,
    this.borderRadius,
    this.color = Colors.lightBlue,
    this.letterStyle = const TextStyle(fontSize: 25, color: Colors.white),
    this.enableSpaceBar = false,
    this.enableBackSpace = true,
    this.enableCapsLock = false,
    this.enableAllUppercase = false,
    this.enableLongPressUppercase = false,
    this.highlightColor,
    this.splashColor,
  });
  @override
  BuiltInTRKeyboardState createState() => BuiltInTRKeyboardState();
}

class BuiltInTRKeyboardState extends State<BuiltInTRKeyboard> {
  late double height;
  late double width;
  bool capsLockUppercase = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    height = screenHeight > 800 ? screenHeight * 0.059 : screenHeight * 0.07;
    width = screenWidth > 350 ? screenWidth * 0.084 : screenWidth * 0.082;
    List<Widget> keyboardLayout = layout(widget.layoutType);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Column(
        children: [
          // Wrap(
          //   alignment: WrapAlignment.center,
          //   spacing: 3,
          //   runSpacing: 5,
          //   children: keyboardLayout.sublist(0, 10),
          // ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: keyboardLayout.sublist(0, 10)),
          SizedBox(
            height: widget.spacing,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            const SizedBox(
              width: 10,
            ),
            ...keyboardLayout.sublist(10, 21),
            const SizedBox(
              width: 10,
            )
          ]),
          SizedBox(
            height: widget.spacing,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [enterButton(widget.handleEnter), ...keyboardLayout.sublist(21), backSpace()],
          ),
          widget.enableSpaceBar
              ? Column(
                  children: [
                    SizedBox(
                      height: widget.spacing,
                    ),
                    spaceBar(),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  // Letter button widget
  Widget buttonLetter(String letter) {
    return Flexible(
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
        child: Container(
          margin: const EdgeInsets.all(1),
          height: widget.height ?? height,
          width: widget.width ?? width,
          child: Material(
            type: MaterialType.button,
            color: (widget.letterStatus[letter] as LetterState).color,
            child: InkWell(
              highlightColor: widget.highlightColor,
              splashColor: widget.splashColor,
              onTap: () {
                HapticFeedback.heavyImpact();
                widget.controller.text += letter;
                widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
              },
              onLongPress: () {
                if (widget.enableLongPressUppercase && !widget.enableAllUppercase) {
                  widget.controller.text += letter.toUpperCase();
                  widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
                }
              },
              child: Center(
                child: Text(
                  letter,
                  style: widget.letterStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Spacebar button widget
  Widget spaceBar() {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      child: SizedBox(
        height: widget.height ?? height,
        width: (widget.width ?? width) + 160,
        child: Material(
          type: MaterialType.button,
          color: widget.color,
          child: InkWell(
            highlightColor: widget.highlightColor,
            splashColor: widget.splashColor,
            onTap: () {
              HapticFeedback.heavyImpact();
              widget.controller.text += ' ';
              widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
            },
            child: Center(
              child: Text(
                '_________',
                style: TextStyle(
                  fontSize: widget.letterStyle.fontSize,
                  color: widget.letterStyle.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Backspace button widgetx
  Widget backSpace() {
    return Flexible(
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
        child: SizedBox(
          height: widget.height ?? height,
          width: (widget.width ?? width) + 20,
          child: Material(
            type: MaterialType.button,
            color: widget.color,
            child: InkWell(
              highlightColor: widget.highlightColor,
              splashColor: widget.splashColor,
              onTap: () {
                HapticFeedback.heavyImpact();
                if (widget.controller.text.isNotEmpty) {
                  widget.controller.text = widget.controller.text.substring(0, widget.controller.text.length - 1);
                  widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
                }
              },
              onLongPress: () {
                if (widget.controller.text.isNotEmpty) {
                  widget.controller.text = '';
                  widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
                }
              },
              child: Center(
                child: Icon(
                  Icons.backspace,
                  size: widget.letterStyle.fontSize,
                  color: widget.letterStyle.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Capslock button widget
  Widget capsLock() {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      child: SizedBox(
        height: widget.height ?? height,
        width: (widget.width ?? width) + 20,
        child: Material(
          type: MaterialType.button,
          color: widget.color,
          child: InkWell(
            highlightColor: widget.highlightColor,
            splashColor: widget.splashColor,
            onTap: () {
              HapticFeedback.heavyImpact();
              setState(() {
                capsLockUppercase = !capsLockUppercase;
              });
            },
            child: Center(
              child: Icon(
                Icons.keyboard_capslock,
                size: widget.letterStyle.fontSize,
                color: widget.letterStyle.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Capslock button widget
  Widget enterButton(VoidCallback handleEnter) {
    return Flexible(
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
        child: SizedBox(
          height: widget.height ?? height,
          width: (widget.width ?? width) + 20,
          child: Material(
            type: MaterialType.button,
            color: widget.color,
            child: InkWell(
              highlightColor: widget.highlightColor,
              splashColor: widget.splashColor,
              onTap: () {
                HapticFeedback.heavyImpact();
                handleEnter();
              },
              child: Center(
                child: Icon(
                  Icons.keyboard_return,
                  size: widget.letterStyle.fontSize,
                  color: widget.letterStyle.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Keyboard layout list
  List<Widget> layout(String layoutType) {
    List<String> letters = [];
    if (layoutType == 'EN') {
      if (widget.enableAllUppercase || capsLockUppercase) {
        letters = 'qwertyuiopasdfghjklzxcvbnm'.toUpperCase().split("");
      } else {
        letters = 'qwertyuiopasdfghjklzxcvbnm'.split("");
      }
    } else if (layoutType == 'FR') {
      if (widget.enableAllUppercase || capsLockUppercase) {
        letters = 'azertyuiopqsdfghjklmwxcvbn'.toUpperCase().split("");
      } else {
        letters = 'azertyuiopqsdfghjklmwxcvbn'.split("");
      }
    } else if (layoutType == 'TR') {
      if (widget.enableAllUppercase || capsLockUppercase) {
        letters = 'ERTYUIOPĞÜASDFGHJKLŞİZCVBNMÖÇ'.split("");
      } else {
        letters = 'ERTYUIOPĞÜASDFGHJKLŞİZCVBNMÖÇ'.split("");
      }
    }

    List<Widget> keyboard = [];
    for (var letter in letters) {
      keyboard.add(
        buttonLetter(letter),
      );
    }
    return keyboard;
  }
}
