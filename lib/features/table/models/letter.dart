import 'package:equatable/equatable.dart';

class Letter extends Equatable{
  final String char;
  final int flag;

  const Letter({this.char = "", this.flag = 2});
  const Letter.empty([this.char = '', this.flag = 2]);

  Letter copyWith({String? char, int? flag}){
    return Letter(
      char : char ?? this.char,
      flag : flag ?? this.flag,
    );
  }

  @override
  List<Object?> get props => [char, flag];
}