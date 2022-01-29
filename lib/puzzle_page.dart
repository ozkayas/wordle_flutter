import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordle_flutter/wordle.dart';
import 'package:http/http.dart' as http;

import 'keyboard.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  //counter holds which wordle is active [0 .. 5]
  int activeLine = 0;
  //wordle text length
  int maxChar = 5;
  TextEditingController textController = TextEditingController();
  List<Wordle> tableState = List.generate(
      6, (_) => Wordle(List<Letter>.generate(5, (_) => Letter.empty())));

  void handleEnter() async {
    // 5 harf de girilmis mi?
    if (textController.text.length == maxChar) {
      // Kelimeyi tdk da sorgula
      bool response = await isValid(textController.text);
      // Eger kelime gecerliyse Flag hesaplat ve boyat
      if (response) {
        var activeFlag = calculateFlag(textController.text);
        print('activeFlag: $activeFlag');
        paintBoxes(activeFlag);
        activeLine++;
        textController.text = '';
      }
    }
  }

  Future<bool> isValid(String wordle) async {
    // TODO: https://sozluk.gov.tr/gts?ara=kaput
    // {"error":"Sonuç bulunamadı"} == hata gelirse donen response
    var url = Uri.parse('https://sozluk.gov.tr/gts?ara=$wordle');
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

  void paintBoxes(List<int> flags) {
    for (var i = 0; i < flags.length; i++) {
      tableState[activeLine].letters[i].flag = flags[i];
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'WORDLEY',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Center(
        child: Column(
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
            )
          ],
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
        ? Colors.blueGrey
        : letter.flag == 1
            ? Colors.lightGreen
            : Colors.yellow.shade800;
    return AnimatedContainer(
      margin: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: color,
      ),
      width: 60.w,
      height: 60.w,
      duration: const Duration(milliseconds: 600),
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
