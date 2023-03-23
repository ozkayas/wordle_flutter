// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:turkish/turkish.dart';

import 'features/keyboard/keyboard.dart';
import 'features/keyboard/keyboard_cubit.dart';
import 'features/table/cubit/table_cubit.dart';
import 'features/table/widgets/wordle_widget.dart';

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
  bool gameOver = false;

  late String target;

  //counter holds which wordle is active [0 .. 5]
  //each row of the table is a wordle
  int activeLine = 0;

  //wordle text length
  int maxChar = 5;
  TextEditingController textController = TextEditingController();
  // List<Wordle> tableState = List.generate(
  //     6, (_) => Wordle(List<Letter>.generate(5, (_) => Letter.empty())));

  late KeyboardCubit _keyboardCubit;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<TableCubit>();
    cubit.resetTable();
    textController.addListener(() {
      if (textController.text.length > 5) {
        textController.text = textController.text.substring(0, 5);
      }
      cubit.letterOnTap(textController.text);
      // context.read<TableCubit>().resetTable();
    });
  }

  @override
  void didChangeDependencies() {
    _keyboardCubit = BlocProvider.of<KeyboardCubit>(context);
    super.didChangeDependencies();
  }

  // void resetGame() {
  //   //TODO: reset keyboard state also
  //   BlocProvider.of<KeyboardCubit>(context).resetKeyboardState();
  //   resetTarget();
  //   activeLine = 0;
  //   textController.text = '';
  //   tableState = List.generate(
  //       6, (_) => Wordle(List<Letter>.generate(5, (_) => Letter.empty())));
  // }

  // void handleEnter() async {
  //   // 5 harf de girilmis mi?
  //   if (textController.text.length == maxChar) {
  //     // Kelimeyi tdk da sorgula
  //     bool response = await isValid(textController.text);
  //     // Eger kelime gecerliyse Flag hesaplat ve boyat
  //     if (!response && mounted) {
  //       showToast(
  //         'Geçersiz Sözcük',
  //         alignment: Alignment.center,
  //         position: StyledToastPosition.center,
  //         context: context,
  //         animation: StyledToastAnimation.scale,
  //       );
  //     } else {
  //       var activeFlag =
  //       calculateFlag(target.toUpperCaseTr(), textController.text);
  //       await paintBoxes(activeFlag);
  //       if (!activeFlag.contains(0) && !activeFlag.contains(-1)) {
  //         setState(() {
  //           gameOver = true;
  //         });
  //       }
  //
  //       //if painted line is not the last one
  //       if (activeLine != 5) {
  //         activeLine++;
  //         textController.text = '';
  //       } else {
  //         if (activeFlag.contains(0) || activeFlag.contains(-1)) {
  //           if (mounted) {
  //             showToast(
  //               'ÜZGÜNÜM BU KEZ OLMADI',
  //               context: context,
  //               position: StyledToastPosition.center,
  //               animation: StyledToastAnimation.scale,
  //             );
  //           }
  //           setState(() {
  //             gameOver = true;
  //           });
  //         } else {
  //           if (mounted) {
  //             showToast(
  //               'BRAVO :)',
  //               context: context,
  //               position: StyledToastPosition.top,
  //               animation: StyledToastAnimation.scale,
  //             );
  //           }
  //           setState(() {
  //             gameOver = true;
  //           });
  //         }
  //       }
  //     }
  //   }
  // }

  // void resetTarget() {
  //   target = targets[Random().nextInt(targets.length)];
  // }

  Future<bool> isValid(String wordle) async {
    // TODO: https://sozluk.gov.tr/gts?ara=kaput
    // {"error":"Sonuç bulunamadı"} == hata gelirse donen response
    if (kDebugMode) {
      print(wordle.toLowerCaseTr());
    }
    var url = Uri.parse('https://sozluk.gov.tr/gts?ara=${wordle.toLowerCaseTr()}');
    var response = await http.read(url);
    var decodedResponse = jsonDecode(response);

    if (decodedResponse is List) {
      return true;
    } else if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('error')) {
      return false;
    } else {
      return false;
    }
  }

  // Method paints boxes after a word is checked according to flags
  // Future<void> paintBoxes(List<int> flags) async {
  //   for (var i = 0; i < flags.length; i++) {
  //     tableState[activeLine].lettersList[i].flag = flags[i];
  //     _keyboardCubit.paintLetter(
  //         tableState[activeLine].lettersList[i].char, flags[i]);
  //   }
  //   setState(() {});
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   return Future.value();
  // }

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
      // https://www.youtube.com/watch?v=5ykfmHhJUu4
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            print("enter pressed");
          }
        },
        child: Scaffold(
/*          // appBar: AppBar(actions: [
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
          // ]),*/
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed:() {
                  textController.clear();
                  context.read<TableCubit>().resetTable;},
                child: const Text("Reset", style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      BlocBuilder<TableCubit, TableState>(
                        builder: (context, state) {
                          return Column(
                            children: state.wordsAsLetters!.map((wordAsLetter) => WordleWidget(
                              word: '',
                              // targetWord: '',
                              letters: wordAsLetter,
                            )).toList(),
                            // children: state.words
                            //     .map((wordle) => WordleWidget(
                            //           word: wordle,
                            //           targetWord: state.targetWord,
                            //
                            //         ))
                            //     .toList(),
                          );
                        },
                      ),
                      const Spacer(),
                      KeyBoardWidget(
                        textController: textController,
                        handleEnter: context.read<TableCubit>().enterOnTap, //handleEnter,
                      )
                    ],
                  ),
                ),
                if (gameOver)
                  Container(
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
                            // setState(() {
                            context.read<TableCubit>().resetTable();
                            gameOver = false;
                            // });
                          },
                          child: const Text(
                            'TEKRAR OYNA',
                            style: TextStyle(fontSize: 30, color: Colors.green),
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
