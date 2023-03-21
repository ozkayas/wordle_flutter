

import 'package:flutter_bloc/flutter_bloc.dart';

part 'table_state.dart';

class TableCubit extends Cubit<TableState> {
  TableCubit() : super(TableInitial());
}
