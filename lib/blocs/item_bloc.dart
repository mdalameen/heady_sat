import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:heady_sat/common/app_preferences.dart';
import 'package:heady_sat/common/data_processor.dart';
import 'package:heady_sat/common/data_provder.dart';
import 'package:heady_sat/models/items.dart';

import 'data_event.dart';
import 'data_state.dart';

class ItemBloc extends Bloc<DataEvent, DataState<ItemOut>> {
  BuildContext context;
  ItemBloc(this.context) : super(DataNotFetched());

  @override
  Stream<DataState<ItemOut>> mapEventToState(DataEvent event) async* {
    if (event is LoadDataEvent) {
      yield DataLoadingState();
      ItemOut cOut = await AppPreferences.getCachedItem();

      if (cOut != null) {
        yield DataCachedState(cOut);
      }
      var itemOut = await DataProvider.getAllItems(context);
      if (itemOut.isSuccess) {
        DataProcessor().setData(itemOut.data);
        AppPreferences.setCachedItem(itemOut.data);
        yield DataLiveState(itemOut.data);
      } else {
        yield DataErrorState(itemOut.errorMessage);
      }
    }
  }
}
