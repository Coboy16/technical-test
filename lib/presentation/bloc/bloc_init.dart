import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:technical_test/presentation/feactures/requests/blocs/blocs.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getListBloc() {
  return [BlocProvider(create: (context) => RequestFilterBloc())];
}
