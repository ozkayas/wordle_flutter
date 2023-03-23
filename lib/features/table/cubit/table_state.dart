part of 'table_cubit.dart';

class TableState extends Equatable {
  final List<String> wordles;
  final String targetWord;

  const TableState({required this.wordles, required this.targetWord});

  TableState.initial()
      : wordles = List.generate(6, (index) => '     '),
        targetWord = '';

  TableState copyWith({List<String>? wordles, String? targetWord}) {
    return TableState(wordles: wordles ?? this.wordles, targetWord: targetWord ?? this.targetWord);
  }

  @override
  String toString() {
    return wordles.toString() + targetWord;
  }

  @override
  List<Object?> get props => [wordles, targetWord];
}
