import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:wordle_flutter/wordle.dart';
import 'package:http/http.dart' as http;
import 'package:wordle_flutter/words.dart';
import 'package:turkish/turkish.dart';
import 'keyboard.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  //Game is over
  bool gameOver = false;

  late String target;
  //counter holds which wordle is active [0 .. 5]
  int activeLine = 0;
  //wordle text length
  int maxChar = 5;
  TextEditingController textController = TextEditingController();
  List<Wordle> tableState = List.generate(
      6, (_) => Wordle(List<Letter>.generate(5, (_) => Letter.empty())));

  Map<String, bool> letterStatus = {
    'E': true,
    'R': true,
    'T': true,
    'Y': true,
    'U': true,
    'I': true,
    'O': true,
    'P': true,
    'Ğ': true,
    'Ü': true,
    'A': true,
    'S': true,
    'D': true,
    'F': true,
    'G': true,
    'H': true,
    'J': true,
    'K': true,
    'L': true,
    'Ş': true,
    'İ': true,
    'Z': true,
    'C': true,
    'V': true,
    'B': true,
    'N': true,
    'M': true,
    'Ö': true,
    'Ç': true,
  };

  void paintLetter(String letter) {
    letterStatus[letter] = false;
  }

  void resetGame() {
    //TODO: reset keyboard state also
    resetTarget();
    activeLine = 0;
    textController.text = '';
    tableState = List.generate(
        6, (_) => Wordle(List<Letter>.generate(5, (_) => Letter.empty())));
  }

  void handleEnter() async {
    // 5 harf de girilmis mi?
    if (textController.text.length == maxChar) {
      // Kelimeyi tdk da sorgula
      bool response = await isValid(textController.text);
      // Eger kelime gecerliyse Flag hesaplat ve boyat
      if (!response) {
        showToast(
          'Geçersiz Sözcük',
          alignment: Alignment.center,
          position: StyledToastPosition.center,
          context: context,
          animation: StyledToastAnimation.scale,
        );
      } else {
        var activeFlag = calculateFlag(
            target.toUpperCaseTr(), textController.text, paintLetter);
        await paintBoxes(activeFlag);
        if (!activeFlag.contains(0) && !activeFlag.contains(-1)) {
          setState(() {
            gameOver = true;
          });
        }

        //if painted line is not the last one
        if (activeLine != 5) {
          activeLine++;
          textController.text = '';
        } else {
          if (activeFlag.contains(0) || activeFlag.contains(-1)) {
            showToast(
              'ÜZGÜNÜM BU KEZ OLMADI',
              context: context,
              position: StyledToastPosition.center,
              animation: StyledToastAnimation.scale,
            );
            setState(() {
              gameOver = true;
            });
          } else {
            showToast(
              'BRAVO :)',
              context: context,
              position: StyledToastPosition.center,
              animation: StyledToastAnimation.scale,
            );
            setState(() {
              gameOver = true;
            });
          }
        }
      }
    }
  }

  void resetTarget() {
    target = targets[Random().nextInt(targets.length)];
  }

  Future<bool> isValid(String wordle) async {
    // TODO: https://sozluk.gov.tr/gts?ara=kaput
    // {"error":"Sonuç bulunamadı"} == hata gelirse donen response
    print(wordle.toLowerCaseTr());
    var url =
        Uri.parse('https://sozluk.gov.tr/gts?ara=${wordle.toLowerCaseTr()}');
    var response = await http.read(url);
    var decodedResponse = jsonDecode(response);

    if (decodedResponse is List) {
      return true;
    } else if (decodedResponse is Map<String, dynamic> &&
        decodedResponse.containsKey('error')) {
      return false;
    } else {
      return false;
    }
  }

  Future<void> paintBoxes(List<int> flags) async {
    for (var i = 0; i < flags.length; i++) {
      tableState[activeLine].letters[i].flag = flags[i];
    }
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
    return Future.value();
  }

  @override
  void initState() {
    super.initState();
    resetTarget();
    textController.addListener(() {
      // Limit text length to 5 characters
      if (textController.text.length > maxChar) {
        textController.text = textController.text.substring(0, 5);
      }

      setState(() {
        //clear and fill active wordle wrt controller.text
        for (var letter in tableState[activeLine].letters) {
          letter.char = '';
        }
        for (var i = 0; i < textController.text.length; i++) {
          tableState[activeLine].letters[i].char = textController.text[i];
        }
        //print(textController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 840),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   title: const Text(
        //     'WORDLEY',
        //     style: TextStyle(fontSize: 30),
        //   ),
        // ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  ...tableState
                      .map((wordle) => WordleWidget(wordle: wordle))
                      .toList(),
                  const Spacer(),
                  KeyBoardWidget(
                    textController: textController,
                    handleEnter: handleEnter,
                    letterStatus: letterStatus,
                  )
                ],
              ),
              if (gameOver)
                Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          offset: Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  height: 150.h,
                  width: 320.w,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        resetGame();

                        gameOver = false;
                      });
                    },
                    child: Text(
                      'TEKRAR OYNA',
                      style: TextStyle(fontSize: 30.sp, color: Colors.green),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class WordleWidget extends StatelessWidget {
  const WordleWidget({Key? key, required this.wordle}) : super(key: key);
  final Wordle wordle;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            wordle.letters.map((letter) => CharBox(letter: letter)).toList());
  }
}

class CharBox extends StatelessWidget {
  const CharBox({
    Key? key,
    required this.letter,
  }) : super(key: key);
  final Letter letter;

  @override
  Widget build(BuildContext context) {
    final Color color = letter.flag == 0
        ? Colors.blueGrey.shade700
        : letter.flag == 1
            ? Colors.lightGreen
            : letter.flag == 2
                ? Colors.blueGrey.shade300
                : Colors.yellow.shade800;
    return AnimatedContainer(
      margin: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: color,
      ),
      width: 60.w,
      height: 60.w,
      duration: const Duration(milliseconds: 400),
      child: Center(
          child: Text(
        letter.char,
        style: TextStyle(
            fontSize: 34.sp,
            fontWeight: FontWeight.normal,
            color: Colors.white),
      )),
    );
  }
}
