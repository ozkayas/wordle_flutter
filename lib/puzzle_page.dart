// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:wordle_flutter/models/wordle.dart';
import 'package:http/http.dart' as http;
import 'package:wordle_flutter/words.dart';
import 'package:turkish/turkish.dart';

import 'features/keyboard/keyboard.dart';
import 'features/keyboard/keyboard_cubit.dart';

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
  //each row of the table is a wordle
  int activeLine = 0;
  //wordle text length
  int maxChar = 5;
  TextEditingController textController = TextEditingController();
  List<Wordle> tableState = List.generate(
      6, (_) => Wordle(List<Letter>.generate(5, (_) => Letter.empty())));

  late KeyboardCubit _keyboardCubit;

  @override
  void didChangeDependencies() {
    _keyboardCubit = BlocProvider.of<KeyboardCubit>(context);
    super.didChangeDependencies();
  }

  void resetGame() {
    //TODO: reset keyboard state also
    BlocProvider.of<KeyboardCubit>(context).resetState();
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
      if (!response && mounted) {
        showToast(
          'Geçersiz Sözcük',
          alignment: Alignment.center,
          position: StyledToastPosition.center,
          context: context,
          animation: StyledToastAnimation.scale,
        );
      } else {
        var activeFlag =
            calculateFlag(target.toUpperCaseTr(), textController.text);
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
            if (mounted) {
              showToast(
                            'ÜZGÜNÜM BU KEZ OLMADI',
                            context: context,
                            position: StyledToastPosition.center,
                            animation: StyledToastAnimation.scale,
                          );
            }
            setState(() {
              gameOver = true;
            });
          } else {
            if (mounted) {
              showToast(
                            'BRAVO :)',
                            context: context,
                            position: StyledToastPosition.top,
                            animation: StyledToastAnimation.scale,
                          );
            }
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
    if (kDebugMode) {
      print(wordle.toLowerCaseTr());
    }
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

  // Method paints boxes after a word is checked according to flags
  Future<void> paintBoxes(List<int> flags) async {
    for (var i = 0; i < flags.length; i++) {
      tableState[activeLine].letters[i].flag = flags[i];
      _keyboardCubit.paintLetter(
          tableState[activeLine].letters[i].char, flags[i]);
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
//     final flutterWebviewPlugin = FlutterWebviewPlugin();
//
//     flutterWebviewPlugin.onStateChanged.listen((viewState) async {
//       if (viewState.type == WebViewState.finishLoad) {
//         flutterWebviewPlugin.evalJavascript(
//             '''<script language="JavaScript" type="text/javascript">\$('.tdk-search-input').val('liyakat')
// \$('.btdk-srch').click()'</script>''');
//       }
//     });

    return SafeArea(
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event){
          if(event.isKeyPressed(LogicalKeyboardKey.enter)){
            print("enter pressed");
          }
        },
        child: Scaffold(
          // appBar: AppBar(actions: [
          //   IconButton(
          //       onPressed: () async {
          //         await flutterWebviewPlugin.launch(
          //           'https://sozluk.gov.tr',
          //         );
          //         // // await Navigator.of(context).push(MaterialPageRoute(
          //         // //     builder: (context) => WebviewScaffold(
          //         // //           url: "https://sozluk.gov.tr",
          //         // //           appBar: AppBar(
          //         // //             title: const Text("TDK"),
          //         // //           ),
          //         // //         )));

          //         // flutterWebviewPlugin.evalJavascript(
          //         //     '<script language="JavaScript" type="text/javascript">alert("Hello World")</script>');

          //         // final url = 'https://sozluk.gov.tr/gts?ara=hacim';
          //         // // 'https://sozluk.gov.tr/gts?ara=${textController.text.toLowerCaseTr()}';

          //         // if (await canLaunch(url)) {
          //         //   launch(url);
          //         // }
          //       },
          //       icon: Icon(Icons.navigate_next))
          // ]),
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Column(children: tableState
                          .map((wordle) => WordleWidget(wordle: wordle))
                          .toList(),),
                      // ...tableState
                      //     .map((wordle) => WordleWidget(wordle: wordle))
                      //     .toList(),
                      const Spacer(),
                      KeyBoardWidget(
                        textController: textController,
                        handleEnter: handleEnter,
                      )
                    ],
                  ),
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
                    //height: 200.h,
                    width: 320,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              resetGame();
                              gameOver = false;
                            });
                          },
                          child: Text(
                            'TEKRAR OYNA',
                            style:
                                TextStyle(fontSize: 30, color: Colors.green),
                          ),
                        ),
                        // TextButton(
                        //   child: Text(
                        //       'Sözlükte Aç:${textController.text.toLowerCaseTr()}'),
                        //   onPressed: () {
                        //     Navigator.of(context).push(MaterialPageRoute(
                        //         builder: (context) => WebviewScaffold(
                        //               url: "https://www.google.com",
                        //               appBar: new AppBar(
                        //                 title: new Text("Widget webview"),
                        //               ),
                        //             )));
                        //     // final url = 'https://sozluk.gov.tr/gts?ara=hacim';
                        //     // // 'https://sozluk.gov.tr/gts?ara=${textController.text.toLowerCaseTr()}';

                        //     // if (await canLaunch(url)) {
                        //     //   launch(url);
                        //     // }
                        //   },
                        // )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// A row of 5 CharBoxes
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

// Visual Box for Letter objects
//
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
                : Colors.yellow.shade700;
    return AnimatedContainer(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: color,
      ),
      width: 60,
      height: 60,
      duration: const Duration(milliseconds: 400),
      child: Center(
          child: Text(
        letter.char,
        style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
      )),
    );
  }
}
