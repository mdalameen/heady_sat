import 'package:flutter_bloc/flutter_bloc.dart';

import 'item_bloc.dart';

class AllBlocs {
  static List<BlocProvider> get() {
    return [
      BlocProvider<ItemBloc>(
        create: (_) => ItemBloc(_),
      ),
    ];
  }
}
