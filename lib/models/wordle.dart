import 'package:equatable/equatable.dart';

class Wordle extends Equatable{
  final String word;

  const Wordle({required this.word});

  Wordle copyWith({String? word}){
    return Wordle(
      word: word ?? this.word
    );
  }

  @override
  List<Object?> get props => [word];
}